module Rouge
  class Lexer
    class << self
      def create(opts={}, &b)
        new(opts, &b).send(:force_load!)
      end

      def find(name)
        registry[name.to_s]
      end

      def register(name, lexer)
        registry[name.to_s] = lexer
      end

    private
      def registry
        @registry ||= {}
      end
    end

    def name(n=nil)
      return @name if n.nil?

      @name = n.to_s
      aliases @name
    end

    def aliases(*args)
      args.each { |arg| Lexer.register(arg, self) }
    end

    def initialize(opts={}, &b)
      options opts
      @lazy_load_proc = b
    end

    def default_options
      {}
    end

    def options(o={})
      (@options ||= default_options).merge!(o)

      @options
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
      enum_tokens(stream).to_a
    end

    def enum_tokens(stream)
      Enumerator.new do |out|
        stream_tokens(stream) do |token, value|
          out << [token, value]
        end
      end
    end

    def stream_tokens(stream)
      raise 'abstract'
    end

  protected

    def force_load!
      return self if @force_load
      @force_load = true
      instance_eval &@lazy_load_proc

      self
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

    def initialize(parent=nil, opts={}, &defn)
      if parent.is_a? Hash
        opts = parent
        parent = nil
      end

      @parent = parent
      super(opts, &defn)
    end

    def lexer(name, opts={}, &defn)
      @scope ||= {}
      name = name.to_s

      if block_given?
        l = @scope[name] = RegexLexer.new(self, options.merge(opts), &defn)
        l.instance_variable_set :@name, name
        l
      else
        @scope[name] || @parent && @parent.lexer(name)
      end
    end

    def mixin(lexer)
      lexer = get_lexer(lexer)
      lexer.force_load!

      rules << lexer
    end

    def rules
      force_load!
      @rules ||= []
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
      case o
      when RegexLexer, :pop!
        o
      else
        lexer o
      end
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
