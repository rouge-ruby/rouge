# stdlib
require 'strscan'

module Rouge
  # @abstract
  # A lexer transforms text into a stream of `[token, chunk]` pairs.
  class Lexer
    class << self
      # Lexes `stream` with the given options.  The lex is delegated to a
      # new instance.
      #
      # @see #lex
      def lex(stream, opts={}, &b)
        new(opts).lex(stream, &b)
      end

      def default_options(o={})
        @default_options ||= {}
        @default_options.merge!(o)
        @default_options
      end

      # Given a string, return the correct lexer class.
      def find(name)
        registry[name.to_s]
      end

      # Find a lexer, with fancy shiny features.
      #
      # * The string you pass can include CGI-style options
      #
      #     Lexer.find_fancy('erb?parent=tex')
      #
      # * You can pass the special name 'guess' so we guess for you,
      #   and you can pass a second argument of the code to guess by
      #
      #     Lexer.find_fancy('guess', "#!/bin/bash\necho Hello, world")
      #
      # This is used in the Redcarpet plugin as well as Rouge's own
      # markdown lexer for highlighting internal code blocks.
      #
      def find_fancy(str, code=nil)
        name, opts = str ? str.split('?', 2) : [nil, '']

        # parse the options hash from a cgi-style string
        opts = CGI.parse(opts || '').map do |k, vals|
          [ k.to_sym, vals.empty? ? true : vals[0] ]
        end

        opts = Hash[opts]

        lexer_class = case name
        when 'guess', nil
          self.guess(:source => code, :mimetype => opts[:mimetype])
        when String
          self.find(name)
        end

        lexer_class && lexer_class.new(opts)
      end

      # Specify or get this lexer's description.
      def desc(arg=:absent)
        if arg == :absent
          @desc
        else
          @desc = arg
        end
      end

      # @return a list of all lexers.
      def all
        registry.values.uniq
      end

      # Guess which lexer to use based on a hash of info.
      #
      # @option info :mimetype
      #   A mimetype to guess by
      # @option info :filename
      #   A filename to guess by
      # @option info :source
      #   The source itself, which, if guessing by mimetype or filename
      #   fails, will be searched for shebangs, <!DOCTYPE ...> tags, and
      #   other hints.
      #
      # @see Lexer.analyze_text
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
            File.fnmatch?(pattern, fname, File::FNM_DOTMATCH)
          end
        end
      end

      def guess_by_source(source)
        assert_utf8!(source)

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

      # @private
      def register(name, lexer)
        registry[name.to_s] = lexer
      end

      # Used to specify or get the canonical name of this lexer class.
      #
      # @example
      #   class MyLexer < Lexer
      #     tag 'foo'
      #   end
      #
      #   MyLexer.tag # => 'foo'
      #
      #   Lexer.find('foo') # => MyLexer
      def tag(t=nil)
        return @tag if t.nil?

        @tag = t.to_s
        Lexer.register(@tag, self)
      end

      # Used to specify alternate names this lexer class may be found by.
      #
      # @example
      #   class Erb < Lexer
      #     tag 'erb'
      #     aliases 'eruby', 'rhtml'
      #   end
      #
      #   Lexer.find('eruby') # => Erb
      def aliases(*args)
        args.map!(&:to_s)
        args.each { |arg| Lexer.register(arg, self) }
        (@aliases ||= []).concat(args)
      end

      # Specify a list of filename globs associated with this lexer.
      #
      # @example
      #   class Ruby < Lexer
      #     filenames '*.rb', '*.ruby', 'Gemfile', 'Rakefile'
      #   end
      def filenames(*fnames)
        (@filenames ||= []).concat(fnames)
      end

      # Specify a list of mimetypes associated with this lexer.
      #
      # @example
      #   class Html < Lexer
      #     mimetypes 'text/html', 'application/xhtml+xml'
      #   end
      def mimetypes(*mts)
        (@mimetypes ||= []).concat(mts)
      end

      # @private
      def assert_utf8!(str)
        return if %w(US-ASCII UTF-8).include? str.encoding.name
        raise EncodingError.new(
          "Bad encoding: #{str.encoding.names.join(',')}. " +
          "Please convert your string to UTF-8."
        )
      end

    private
      def registry
        @registry ||= {}
      end
    end

    # -*- instance methods -*- #

    # Create a new lexer with the given options.  Individual lexers may
    # specify extra options.  The only current globally accepted option
    # is `:debug`.
    #
    # @option opts :debug
    #   Prints debug information to stdout.  The particular info depends
    #   on the lexer in question.  In regex lexers, this will log the
    #   state stack at the beginning of each step, along with each regex
    #   tried and each stream consumed.  Try it, it's pretty useful.
    def initialize(opts={})
      options(opts)
    end

    # get and/or specify the options for this lexer.
    def options(o={})
      (@options ||= {}).merge!(o)

      self.class.default_options.merge(@options)
    end

    # get or specify one option for this lexer
    def option(k, v=:absent)
      if v == :absent
        options[k]
      else
        options({ k => v })
      end
    end

    # Leave a debug message if the `:debug` option is set.  The message
    # is given as a block because some debug messages contain calculated
    # information that is unnecessary for lexing in the real world.
    #
    # @example
    #   debug { "hello, world!" }
    def debug(&b)
      puts(b.call) if option :debug
    end

    # @abstract
    #
    # Called after each lex is finished.  The default implementation
    # is a noop.
    def reset!
    end

    # Given a string, yield [token, chunk] pairs.  If no block is given,
    # an enumerator is returned.
    #
    # @option opts :continue
    #   Continue the lex from the previous state (i.e. don't call #reset!)
    def lex(string, opts={}, &b)
      return enum_for(:lex, string) unless block_given?

      Lexer.assert_utf8!(string)

      reset! unless opts[:continue]

      # consolidate consecutive tokens of the same type
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

    # delegated to {Lexer.tag}
    def tag
      self.class.tag
    end

    # @abstract
    #
    # Yield `[token, chunk]` pairs, given a prepared input stream.  This
    # must be implemented.
    #
    # @param [StringScanner] stream
    #   the stream
    def stream_tokens(stream, &b)
      raise 'abstract'
    end

    # @abstract
    #
    # Return a number between 0 and 1 indicating the likelihood that
    # the text given should be lexed with this lexer.  The default
    # implementation returns 0.
    #
    # @param [TextAnalyzer] text
    #   the text to be analyzed, with a couple of handy methods on it,
    #   like {TextAnalyzer#shebang?} and {TextAnalyzer#doctype?}
    def self.analyze_text(text)
      0
    end
  end
end
