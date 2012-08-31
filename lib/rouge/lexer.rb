module Rouge
  class Lexer
    def initialize(&b)
      instance_eval(&b)
    end

    def default_options
      {}
    end

    def options(o={})
      (@options ||= default_options).merge!(o)
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
      Enumerator.new do |out|
        stream_tokens(stream) do |token, value|
          out << [token, value]
        end
      end.to_a
    end

    def stream_tokens(stream)
      raise 'abstract'
    end
  end

  class RegexLexer < Lexer
    class Rule
      attr_reader :callback
      attr_reader :next_lexer
      attr_reader :re
      def initialize(re, callback, next_lexer)
        @re = Regexp.new %/\\A#{re.source}/
        @callback = callback
        @next_lexer = next_lexer
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

    def initialize(parent=nil, &defn)
      @parent = parent
      super(&defn)
    end

    def lexer(name, &defn)
      name = name.to_s

      if block_given?
        scope[name] = RegexLexer.new(self, &defn)
      else
        scope[name] || parent && parent.lexer(name)
      end
    end

    def scope
      @scope ||= {}
    end

    def mixin(lexer)
      rules << lexer
    end

    def rules
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

      rules << Rule.new(re, callback, next_lexer)
    end

    def step(stream, stack, &b)
      debug { "parsing #{stream.inspect}" }
      if stack.empty?
        raise 'empty stack!'
      end

      lexer = stack.last

      lexer.rules.each do |rule|
        rule.consume(stream) do |match|

          return true
        end
      end

      return false
    end

    def stream_tokens(stream, &b)
      stream = stream.dup
      stack = [self]

      stream_with_stack(stream.dup, [self], &b)
    end

    def stream_with_stack(stream, stack, &b)
      return true if stream.empty?

      until stream.empty?
        debug { "parsing #{stream.inspect}" }
        success = stack.last.step(stream, stack, &b)

        if !success
          debug { "    failed parse, returning text" }
          b.call(Token['Text'], stream)
          return false
        end
      end
    end

    def step(stream, stack, &b)
      rules.each do |rule|
        debug { "  trying #{rule.re.inspect}" }
        return true if run_rule(rule, stream, stack, &b)
      end

      false
    end

  private
    def get_lexer(o)
      case o
      when RegexLexer
        o
      else
        lexer o
      end
    end

    def run_rule(rule, stream, stack, &b)
      case rule
      when String, RegexLexer
        get_lexer(rule).step(stream, stack, &b)
      when Rule
        rule.consume(stream) do |match|
          debug { "    got #{match[0].inspect}" }

          rule.callback.call(*match) do |tok, res|
            if tok.is_a? String
              tok = Token[tok]
            end

            b.call(tok, res)
          end

          if rule.next_lexer == :pop!
            stack.pop
          elsif rule.next_lexer
            stack.push get_lexer(rule.next_lexer)
          end
        end
      end
    end

  end
end
