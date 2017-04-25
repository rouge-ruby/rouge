# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class ConsoleLexer < Lexer
      tag 'console'
      aliases 'terminal', 'shell_session'
      filenames '*.cap'

      def initialize(options={})
        @prompt = options.delete(:prompt)
        @lang = options.delete(:parent)
        @output = options.delete(:output)
        @root = options.delete(:root)

        super(options)
      end

      def prompt_regex
        @prompt_regex ||= begin
          end_chars = case @prompt
          when Array
            @prompt
          when String
            @prompt = @prompt.split(',')
          else
            %w($ # >)
          end.map { |c| Regexp.escape(c) }

          prefix = case @root
          when 0, '0', false, nil
            /^.+?/
          else
            /^.*?/
          end

          /^#{prefix}(?:#{end_chars.join('|')})/.tap { |x| p :prompt_regex => x }
        end
      end

      def lang_lexer
        case @lang
        when Lexer
          @lang
        when nil
          @lang = Shell.new(@options)
        when Class
          @lang.new(@options)
        when String
          @lang = Lexer.find(@lang).new(@options)
        end
      end

      def output_lexer
        case @output
        when nil
          @output = PlainText.new(token: Generic::Output)
        when Lexer, Class
          @output
        when String
          @output = Lexer.find(@output).new(@options)
        end
      end

      def stream_tokens(input, &b)
        input = StringScanner.new(input)
        lang_lexer.reset!
        output_lexer.reset!

        while !input.eos? and input.scan /(\\.|[^\\])*?(\n|$)/
          if prompt_regex =~ input[0]
            puts "console: matched prompt #{input[0].inspect}" if @debug
            output_lexer.reset!

            yield Generic::Prompt, $&

            # make sure to take care of initial whitespace
            # before we pass to the lang lexer so it can determine where
            # the "real" beginning of the line is
            $' =~ /\A\s*/
            yield Text, $&

            lang_lexer.lex $', continue: true do |tok, val|
              yield tok, val
            end
          elsif input[0].start_with?('#') || /\A(?:[<][.]+[>]|[.]+)\z/ =~ input[0].chomp
            puts "console: matched comment #{input[0].inspect}" if @debug
            output_lexer.reset!
            lang_lexer.reset!

            yield Comment, input[0]
          else
            puts "console: matched output #{input[0].inspect}" if @debug
            lang_lexer.reset!

            output_lexer.lex(input[0], continue: true) do |tok, val|
              yield tok, val
            end
          end
        end
      end
    end
  end
end
