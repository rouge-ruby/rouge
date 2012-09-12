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

      def lex(stream, opts={}, &b)
        new(opts).lex(stream, &b)
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

      def guess(info={})
        by_mimetype = guess_by_mimetype(info[:mimetype]) if info[:mimetype]
        return by_mimetype if by_mimetype

        by_filename = guess_by_filename(info[:filename]) if info[:filename]
        return by_filename if by_filename

        by_source = guess_by_source(info[:source]) if info[:source]
        return by_source if by_source

        # guessing failed, just parse it as text
        return Lexers::Text
      end

      def guess_by_mimetype(mt)
        registry.values.detect do |lexer|
          lexer.mimetypes.include? mt
        end
      end

      def guess_by_filename(fname)
        fname = File.basename(fname)
        registry.values.detect do |lexer|
          lexer.filenames.any? do |pattern|
            File.fnmatch?(pattern, fname)
          end
        end
      end

      def guess_by_source(source)
        source = TextAnalyzer.new(source)

        best_result = 0
        best_match = nil
        registry.values.each do |lexer|
          result = lexer.analyze_text(source) || 0
          return lexer if result == 1

          if result > best_result
            best_match = lexer
            best_result = result
          end
        end

        best_match
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

      def filenames(*fnames)
        (@filenames ||= []).concat(fnames)
      end

      def mimetypes(*mts)
        (@mimetypes ||= []).concat(mts)
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

      last_token = nil
      last_val = nil
      stream_tokens(StringScanner.new(string)) do |tok, val|
        next if val.empty?

        if tok == last_token
          last_val << val
          next
        end

        b.call(last_token, last_val) if last_token
        last_token = tok
        last_val = val
      end

      b.call(last_token, last_val) if last_token
    end

    def stream_tokens(stream, &b)
      raise 'abstract'
    end

    # return a number between 0 and 1 indicating the
    # likelihood that the text given should be lexed
    # with this lexer.
    def self.analyze_text(text)
      0
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

    class ScanState
      def self.delegate(m, target)
        define_method(m) do |*a, &b|
          send(target).send(m, *a, &b)
        end
      end

      attr_accessor :scanner
      attr_accessor :stack
      attr_accessor :lexer
      def initialize(lexer, scanner, stack=nil)
        @lexer = lexer
        @scanner = scanner
        @stack = stack || [lexer.get_state(:root)]
      end

      def pop!
        raise 'empty stack!' if stack.empty?

        debug { "    popping stack" }
        stack.pop
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

      def in_state?(state_name)
        stack.map(&:name).include? state_name.to_s
      end

      def state?(state_name)
        state_name.to_s == state.name
      end

      delegate :debug, :lexer

      delegate :[], :scanner
      delegate :captures, :scanner
      delegate :peek, :scanner
      delegate :eos?, :scanner

      def run_callback(&callback)
        Enumerator.new do |y|
          @output_stream = y
          @group_count = 0
          instance_exec(self, &callback)
          @output_stream = nil
        end
      end

      def token(tok, val=:__absent__)
        val = scanner[0] if val == :__absent__
        val ||= ''

        raise 'no output stream' unless @output_stream

        @output_stream << [Token[tok], val]
      end

      def group(tok)
        token(tok, scanner[@group_count += 1])
      end

      def delegate(lexer, text=nil)
        debug { "    delegating to #{lexer.name}" }
        text ||= scanner[0]

        lexer.lex(text) do |tok, val|
          debug { "    delegated token: #{tok.inspect}, #{val.inspect}" }
          token(tok, val)
        end
      end

      def state
        raise 'empty stack!' if stack.empty?
        stack.last
      end

      MAX_NULL_STEPS = 5
      def scan(re, &b)
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

          callback = proc do |ss|
            token tok, ss[0]
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

    def self.start_procs
      @start_procs ||= []
    end

    def self.start(&b)
      start_procs << b
    end

    def self.state(name, &b)
      name = name.to_s
      states[name] = State.new(self, name, &b)
    end

    def initialize(parent=nil, opts={}, &defn)
      if parent.is_a? Hash
        opts = parent
        parent = nil
      end

      @parent = parent
      super(opts, &defn)
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

    def stream_tokens(stream, &b)
      scan_state = ScanState.new(self, stream)

      self.class.start_procs.each do |pr|
        scan_state.instance_eval(&pr)
      end

      stream_with_state(scan_state, &b)
    end

    def stream_with_state(scan_state, &b)
      until scan_state.eos?
        debug { "stack: #{scan_state.stack.map(&:name).inspect}" }
        debug { "stream: #{scan_state.scanner.peek(20).inspect}" }
        success = step(get_state(scan_state.state), scan_state, &b)

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
        res = step(get_state(rule), scan_state, &b)
        debug { "  exiting  mixin #{rule}" }
        res
      when Rule
        debug { "  trying #{rule.inspect}" }
        scan_state.scan(rule.re) do |match|
          debug { "    got #{match[0].inspect}" }

          scan_state.run_callback(&rule.callback).each do |tok, res|
            debug { "    yielding #{tok.to_s.inspect}, #{res.inspect}" }
            b.call(Token[tok], res)
          end
        end
      end
    end

  end
end
