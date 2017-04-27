# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class ConsoleLexer < Lexer
      tag 'console'
      aliases 'terminal', 'shell_session', 'shell-session'
      filenames '*.cap'
      desc 'A generic lexer for shell sessions. Accepts ?lang and ?output lexer options, a ?prompt option, and ?comments to enable # comments.'

      option :lang, 'the shell language to lex (default: shell)'
      option :output, 'the output language (default: plaintext?token=Generic.Output)'
      option :prompt, 'comma-separated list of strings that indicate the end of a prompt. (default: $,#,>,;)'
      option :comments, 'enable hash-comments at the start of a line - otherwise interpreted as a prompt. (default: false, implied by ?prompt not containing `#`)'

      def initialize(options={})
        @prompt = options.delete(:prompt)
        @lang = options.delete(:lang)
        @output = options.delete(:output)
        @comments = options.delete(:comments)

        super(options)
      end

      def prompt_regex
        @prompt_regex ||= begin
          /^#{prompt_prefix_regex}(?:#{end_chars.map(&Regexp.method(:escape)).join('|')})/
        end
      end

      def end_chars
        @end_chars ||= case @prompt
        when Array
          @prompt
        when String
          out = @prompt.split(',')
          out.empty? ? %w($ # >) : out
        else
          %w($ # > ;)
        end.reject { |c| c.empty? }
      end

      # whether to allow comments. if manually specifying a prompt that isn't
      # simply "#", we flag this to on
      def allow_comments?
        return true if @prompt && !@prompt.empty? && !end_chars.include?('#')

        case @comments
        when false, nil, 0, '0'
          false
        else
          true
        end
      end

      def prompt_prefix_regex
        if allow_comments?
          /^[^<]+?/
        else
          /^[^<]*?/
        end
      end

      def lang_lexer
        @lang_lexer ||= case @lang
        when Lexer
          @lang
        when nil
          Shell.new(options)
        when Class
          @lang.new(options)
        when String
          Lexer.find(@lang).new(options)
        end
      end

      def output_lexer
        @output_lexer ||= case @output
        when nil
          PlainText.new(token: Generic::Output)
        when Lexer
          @output
        when Class
          @output.new(options)
        when String
          Lexer.find(@output).new(options)
        end
      end

      def line_regex
        /(\\.|[^\\])*?(\n|$)/m
      end

      def comment_regex
        /\A(?:#.*|[<][.]+[>]|[.]+)\z/
      end

      def stream_tokens(input, &output)
        input = StringScanner.new(input)
        lang_lexer.reset!
        output_lexer.reset!

        process_line(input, &output) while !input.eos?
      end

      def process_line(input, &output)
        input.scan(line_regex)

        if prompt_regex =~ input[0]
          puts "console: matched prompt #{input[0].inspect}" if @debug
          output_lexer.reset!

          yield Generic::Prompt, $&

          # make sure to take care of initial whitespace
          # before we pass to the lang lexer so it can determine where
          # the "real" beginning of the line is
          $' =~ /\A\s*/
          yield Text, $& unless $&.empty?

          lang_lexer.lex($', continue: true, &output)
        elsif comment_regex =~ input[0].strip
          puts "console: matched comment #{input[0].inspect}" if @debug
          output_lexer.reset!
          lang_lexer.reset!

          yield Comment, input[0]
        else
          puts "console: matched output #{input[0].inspect}" if @debug
          lang_lexer.reset!

          output_lexer.lex(input[0], continue: true, &output)
        end
      end
    end
  end
end
