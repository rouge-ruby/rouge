module Rouge
  class Lexer
    class << self
      def make(opts={}, &b)
        _sup = self

        Class.new(self) do
          @lazy_load_proc = b
          @default_options = _sup.default_options.merge(opts)
          @parent = _sup
        end
      end

      def lex(stream, opts={})
        new(opts).lex(stream)
      end

    protected
      def force_load!
        return self if @force_load
        @force_load = true
        @lazy_load_proc && instance_eval(&@lazy_load_proc)

        self
      end
    public

      def new(*a, &b)
        force_load!
        super(*a, &b)
      end

      def default_options
        @default_options ||= {}
      end

      def find(name)
        registry[name.to_s]
      end

      def register(name, lexer)
        registry[name.to_s] = lexer
      end

      def tag(t=nil)
        return @tag if t.nil?

        @tag = t.to_s
        aliases @tag
      end

      def aliases(*args)
        args.each { |arg| Lexer.register(arg, self) }
      end

    private
      def registry
        @registry ||= {}
      end
    end

    # -*- instance methods -*- #

    def initialize(opts={}, &b)
      options(opts)
      @lazy_load_proc = b
    end

    def options(o={})
      (@options ||= {}).merge!(o)

      self.class.default_options.merge(@options)
    end

    def option(k, v=:absent)
      if v == :absent
        options[k.to_s]
      else
        options({ k.to_s => v })
      end
    end

    def debug(&b)
      puts(b.call) if option :debug
    end

    def get_tokens(stream)
      lex(stream).to_a
    end

    def lex(stream, &b)
      return enum_for(:lex, stream) unless block_given?

      stream_tokens(stream, &b)
    end

    def stream_tokens(stream, &b)
      raise 'abstract'
    end
  end

  class RegexLexer < Lexer
    class Rule
      attr_reader :callback
      attr_reader :next_lexer
      attr_reader :re
      def initialize(re, callback, next_lexer)
        @orig_re = re
        @re = Regexp.new %/\\A(?:#{re.source})/
        @callback = callback
        @next_lexer = next_lexer
      end

      def inspect
        "#<Rule #{@orig_re.inspect}>"
      end

      def consume(stream, &b)
        # TODO: I'm sure there is a much faster way of doing this.
        # also, encapsulate the stream in its own class.
        match = stream.match(@re)

        if match
          stream.slice!(0...$&.size)
          yield match
          return true
        end

        false
      end
    end

    class << self
      def rules
        force_load!
        @rules ||= []
      end

      def lexer(name, opts={}, &defn)
        @scope ||= {}
        name = name.to_s
        new_opts = default_options.merge(opts)

        if block_given?
          l = @scope[name] = make(new_opts, &defn)
          l.instance_variable_set :@name, name
          l
        else
          lexer_class = @scope[name]
          inst = lexer_class && lexer_class.new(new_opts)
          inst || @parent && @parent.lexer(name, opts)
        end
      end

      def mixin(lexer)
        lexer = get_lexer(lexer)

        rules << lexer
      end

      def rule(re, token=nil, next_lexer=nil, &callback)
        if block_given?
          next_lexer = token
        else
          if token.is_a? String
            token = Token[token]
          end

          callback = proc { |match, &b| b.call token, match }
        end

        rules << Rule.new(re, callback, get_lexer(next_lexer))
      end

      def get_lexer(o)
        case o
        when RegexLexer, :pop!
          o
        else
          lexer o
        end
      end
    end

    def initialize(parent=nil, opts={}, &defn)
      if parent.is_a? Hash
        opts = parent
        parent = nil
      end

      @parent = parent
      super(opts, &defn)
    end

    def rules
      self.class.rules
    end

    def stream_tokens(stream, &b)
      stream = stream.dup
      stack = [self]

      stream_with_stack(stream.dup, [self], &b)
    end

    def stream_with_stack(stream, stack, &b)
      return true if stream.empty?

      until stream.empty?
        debug { "stack: #{stack.map(&:name).inspect}" }
        debug { "parsing #{stream.slice(0..20).inspect}" }
        success = stack.last.step(stream, stack, &b)

        if !success
          debug { "    no match, yielding Error" }
          b.call(Token['Error'], stream.slice!(0..0))
        end
      end
    end

    def step(stream, stack, &b)
      rules.each do |rule|
        return true if run_rule(rule, stream, stack, &b)
      end

      false
    end

  private
    def get_lexer(o)
      self.class.get_lexer(o)
    end

    def run_rule(rule, stream, stack, &b)
      case rule
      when String, RegexLexer
        lexer = get_lexer(rule)
        debug { "  entering mixin #{lexer.name}" }
        get_lexer(rule).step(stream, stack, &b)
      when Rule
        debug { "  trying #{rule.inspect}" }
        rule.consume(stream) do |match|
          debug { "    got #{match[0].inspect}" }

          rule.callback.call(*match) do |tok, res|
            if tok.is_a? String
              tok = Token[tok]
            end

            debug { "    yielding #{tok.name.inspect}, #{res.inspect}" }
            b.call(tok, res)
          end

          if rule.next_lexer == :pop!
            debug { "    popping stack" }
            stack.pop
          elsif rule.next_lexer
            lexer = get_lexer(rule.next_lexer)
            debug { "    entering #{lexer.name}" }
            stack.push lexer
          end
        end
      end
    end

  end
end
