# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    preload 'console'

    class IRBLexer < ConsoleLexer
      tag 'irb'
      aliases 'pry'

      desc 'Shell sessions in IRB or Pry'

      # unlike the superclass, we do not accept any options
      @option_docs = {}

      def output_lexer
        @output_lexer ||= IRBOutputLexer.new(@options)
      end

      def lang_lexer
        @lang_lexer ||= Ruby.new(@options)
      end

      def prompt_regex
        /^.*?(irb|pry).*?[>"*]/
      end

      def allow_comments?
        true
      end
    end
  end
end
