module Rouge
  class RegexLexer < Lexer
    class Rule
      attr_reader :callback
      attr_reader :next_state
      attr_reader :re
      def initialize(re, callback, next_state)
        @re = re
        @callback = callback
        @next_state = next_state
      end

      def inspect
        "#<Rule #{@re.inspect}>"
      end
    end

    class State
      attr_reader :name
      def initialize(lexer_class, name, &defn)
        @lexer_class = lexer_class
        @name = name
        @defn = defn
      end

      def relative_state(state_name=nil, &b)
        if state_name
          @lexer_class.get_state(state_name)
        else
          State.new(@lexer_class, b.inspect, &b).load!
        end
      end

      def rules
        @rules ||= []
      end

      def load!
        return self if @loaded
        @loaded = true
        StateDSL.new(rules).instance_eval(&@defn)
        self
      end
    end

    class StateDSL
      attr_reader :rules
      def initialize(rules)
        @rules = rules
      end

      def rule(re, tok=nil, next_state=nil, &callback)
        if block_given?
          next_state = tok
        else
          tok = Token[tok]

          callback = proc do
            token tok
            case next_state
            when :pop!
              pop!
            when Symbol
              push next_state
            end # else pass
          end
        end

        rules << Rule.new(re, callback, next_state)
      end

      def mixin(lexer_name)
        rules << lexer_name.to_s
      end
    end

    def self.states
      @states ||= {}
    end

    @start_procs = []
    def self.start_procs
      @start_procs ||= InheritableList.new(superclass.start_procs)
    end

    # Specify an action to be run every fresh lex.
    #
    # @example
    #   start { puts "I'm lexing a new string!" }
    def self.start(&b)
      start_procs << b
    end

    def self.postprocess(toktype, &b)
      postprocesses << [Token[toktype], b]
    end

    @postprocesses = []
    def self.postprocesses
      @postprocesses ||= InheritableList.new(superclass.postprocesses)
    end

    def self.state(name, &b)
      name = name.to_s
      states[name] = State.new(self, name, &b)
    end

    def self.get_state(name)
      return name if name.is_a? State

      state = states[name.to_s]
      raise "unknown state: #{name}" unless state
      state.load!
    end

    def self.[](name)
      get_state(name)
    end

    def get_state(name)
      self.class.get_state(name)
    end

    def stack
      @stack ||= [get_state(:root)]
    end

    def state
      stack.last or raise 'empty stack!'
    end

    def reset!
      @scan_state = nil

      self.class.start_procs.each do |pr|
        instance_eval(&pr)
      end
    end

    def stream_tokens(stream, &b)
      stream_without_postprocessing(stream) do |tok, val|
        _, processor = self.class.postprocesses.find { |t, _| t == tok }

        if processor
          # TODO: DRY this up with run_callback
          Enumerator.new do |y|
            @output_stream = y
            instance_exec(tok, val, &processor)
          end.each do |newtok, newval|
            yield Token[newtok], newval
          end
        else
          yield tok, val
        end
      end
    end

    # @private
    def stream_without_postprocessing(stream, &b)
      until stream.eos?
        debug { "lexer: #{self.class.tag}" }
        debug { "stack: #{stack.map(&:name).inspect}" }
        debug { "stream: #{stream.peek(20).inspect}" }
        success = step(get_state(state), stream, &b)

        if !success
          debug { "    no match, yielding Error" }
          b.call(Token['Error'], stream.getch)
        end
      end
    end

    def step(state, stream, &b)
      state.rules.each do |rule|
        return true if run_rule(rule, stream, &b)
      end

      false
    end

    def run_rule(rule, stream, &b)
      case rule
      when String
        debug { "  entering mixin #{rule}" }
        res = step(get_state(rule), stream, &b)
        debug { "  exiting  mixin #{rule}" }
        res
      when Rule
        debug { "  trying #{rule.inspect}" }
        scan(stream, rule.re) do
          debug { "    got #{stream[0].inspect}" }

          run_callback(stream, &rule.callback).each do |tok, res|
            debug { "    yielding #{tok.to_s.inspect}, #{res.inspect}" }
            b.call(Token[tok], res)
          end
        end
      end
    end

    def run_callback(stream, &callback)
      Enumerator.new do |y|
        @output_stream = y
        @group_count = 0
        @last_match = stream
        instance_exec(stream, &callback)
        @last_match = nil
        @output_stream = nil
      end
    end

    MAX_NULL_STEPS = 5
    def scan(scanner, re, &b)
      # XXX HACK XXX
      # StringScanner's implementation of ^ is b0rken.
      # TODO: this doesn't cover cases like /(a|^b)/, but it's
      # the most common, for now...
      return false if re.source[0] == ?^ && !scanner.beginning_of_line?

      @null_steps ||= 0

      if @null_steps >= MAX_NULL_STEPS
        debug { "    too many scans without consuming the string!" }
        return false
      end

      scanner.scan(re)

      if scanner.matched?
        if scanner.matched_size == 0
          @null_steps += 1
        else
          @null_steps = 0
        end

        yield self
        return true
      end

      return false
    end

    def token(tok, val=:__absent__)
      val = @last_match[0] if val == :__absent__
      val ||= ''

      raise 'no output stream' unless @output_stream

      @output_stream << [Token[tok], val] unless val.empty?
    end

    def group(tok)
      token(tok, @last_match[@group_count += 1])
    end

    def delegate(lexer, text=nil)
      debug { "    delegating to #{lexer.inspect}" }
      text ||= @last_match[0]

      lexer.lex(text, :continue => true) do |tok, val|
        debug { "    delegated token: #{tok.inspect}, #{val.inspect}" }
        token(tok, val)
      end
    end

    def push(state_name=nil, &b)
      # use the top of the stack by default
      if state_name || b
        push_state = state.relative_state(state_name, &b)
      else
        push_state = self.state
      end

      debug { "    pushing #{push_state.name}" }
      stack.push(push_state)
    end

    def pop!(times=1)
      raise 'empty stack!' if stack.empty?

      debug { "    popping stack: #{times}" }
      times.times { stack.pop }
    end

    def reset_stack
      debug { '    resetting stack' }
      stack.clear
      stack.push get_state(:root)
    end

    def in_state?(state_name)
      stack.map(&:name).include? state_name.to_s
    end

    def state?(state_name)
      state_name.to_s == state.name
    end

  end
end
