# stdlib
require 'strscan'

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

      def extensions(*exts)
        exts.each do |ext|
          Lexer.extension_registry[ext] = self
        end
      end

      def extension_registry
        @extension_registry ||= {}
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
        options[k]
      else
        options({ k => v })
      end
    end

    def debug(&b)
      puts(b.call) if option :debug
    end

    def get_tokens(stream)
      lex(stream).to_a
    end

    def lex(string, &b)
      return enum_for(:lex, string) unless block_given?

      stream_tokens(StringScanner.new(string), &b)
    end

    def stream_tokens(stream, &b)
      raise 'abstract'
    end
  end

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

      def consume(stream, &b)
        stream.scan(@re)

        if stream.matched?
          yield stream
          return true
        end

        false
      end
    end

    class State
      attr_reader :name
      def initialize(name, &defn)
        @name = name
        @defn = defn
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

    class ScanState
      def self.delegate(m, target)
        define_method(m) do |*a, &b|
          send(target).send(m, *a, &b)
        end
      end

      attr_accessor :scanner
      attr_accessor :stack
      def initialize(scanner, stack)
        @scanner = scanner
        @stack = stack
      end

      def pop!
        raise 'empty stack!' if stack.empty?

        stack.pop
      end

      delegate :push, :stack

      delegate :[], :scanner
      delegate :captures, :scanner
      delegate :peek, :scanner
      delegate :eos?, :scanner

      def state
        raise 'empty stack!' if stack.empty?
        stack.last
      end

      def scan(re, &b)
        scanner.scan(re)

        if scanner.matched?
          yield self
          return true
        end

        return false
      end
    end

    class StateDSL
      attr_reader :rules
      def initialize(rules)
        @rules = rules
      end

      def rule(re, token=nil, next_state=nil, &callback)
        if block_given?
          next_state = token
        else
          token = Token[token]

          callback = proc { |ss, b| b << [token, ss[0]] }
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

    def self.state(name, &b)
      name = name.to_s
      states[name] = State.new(name, &b)
    end

    def initialize(parent=nil, opts={}, &defn)
      if parent.is_a? Hash
        opts = parent
        parent = nil
      end

      @parent = parent
      super(opts, &defn)
    end

    def states
      self.class.states
    end

    def get_state(name)
      state = states[name.to_s]
      raise "unknown state: #{name}" unless state
      state.load!
    end

    def stream_tokens(stream, &b)
      scan_state = ScanState.new(stream, [self.get_state(:root)])

      stream_with_state(scan_state, &b)
    end

    def stream_with_state(scan_state, &b)
      until scan_state.eos?
        debug { "stack: #{scan_state.stack.map(&:name).inspect}" }
        debug { "stream: #{scan_state.stream.peek(20).inspect}" }
        success = step(scan_state.state, scan_state, &b)

        if !success
          debug { "    no match, yielding Error" }
          b.call(Token['Error'], scan_state.scanner.getch)
        end
      end
    end

    def step(state, scan_state, &b)
      state.rules.each do |rule|
        return true if run_rule(rule, scan_state, &b)
      end

      false
    end

  private
    def run_rule(rule, scan_state, &b)
      case rule
      when String
        debug { "  entering mixin #{rule}" }
        step(get_state(rule), scan_state, &b)
      when Rule
        debug { "  trying #{rule.inspect}" }
        scan_state.scan(rule.re) do |match|
          debug { "    got #{match[0].inspect}" }

          Enumerator.new do |y|
            scan_state.instance_exec(scan_state, y, &rule.callback)
          end.each do |tok, res|
            debug { "    yielding #{tok.to_s.inspect}, #{res.inspect}" }
            b.call(Token[tok], res)
          end

          if rule.next_state == :pop!
            debug { "    popping stack" }
            scan_state.pop!
          elsif rule.next_state
            debug { "    entering #{rule.next_state}" }
            scan_state.push get_state(rule.next_state)
          end
        end
      end
    end

  end
end
