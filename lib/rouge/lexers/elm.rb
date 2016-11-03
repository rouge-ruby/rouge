# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Elm < RegexLexer
      # For reference: one liner to debug all files in a given dir at once
      # tail -n+1 ~/code/github.com/evancz/elm-architecture-tutorial/examples/*elm | sed 's/\(==>.\+<==\)/-- \1/' | ROUGE_DEBUG=1 ./bin/rougify --lexer elm 2>/tmp/rouge_debug | less -RS

      title "Elm"
      desc "The Elm programming language (elm-lang.org)"

      tag 'elm'
      filenames '*.elm'
      mimetypes 'text/x-elm'

      def initialize(*)
        super
        @debug = ENV['ROUGE_DEBUG'] == '1'
      end

      state :root do
        rule /\-\-.*/, Comment::Single

        rule /".*?"/m, Literal::String
        rule /\d/, Literal::Number
        rule /\s/, Text::Whitespace

        rule Regexp.union(
          /#{Regexp.quote('\(')}/,
          /#{Regexp.quote('(')}/,
          /#{Regexp.quote(')')}/,
          /#{Regexp.quote('{')}/,
          /#{Regexp.quote('}')}/,
          /#{Regexp.escape('[')}/,
          /#{Regexp.escape(']')}/,
          /#{Regexp.escape('.')}/,
          /,/,
          /\\/,
          /'/, # Not sure how single quotes should be handled
        ), Punctuation

        rule Regexp.union(
          /#{Regexp.escape('++')}/,
          /#{Regexp.escape('->')}/,
          /#{Regexp.escape('<|')}/,
          /#{Regexp.escape('|>')}/,
          /#{Regexp.escape('|')}/,
          /#{Regexp.escape('+')}/,
          /#{Regexp.escape('-')}/,
          /#{Regexp.escape('*')}/,
          /#{Regexp.escape('^')}/,
          /:/,
          /=/,
        ), Operator

        rule /#{Regexp.quote('..')}/, Keyword::Declaration

        rule /\bmodule\b|\bexposing\b|\btype\b/, Keyword::Reserved

        rule /\bif\b|\belse\b|\bthen\b|\bcase\b|\bof\b|\btype\b|\blet\b|\bin\b/, Name::Builtin

        rule /\A\w+ :/, Name::Function
        rule /[A-Z][a-z]+/, Keyword::Type

        rule /[a-z]+[A-Z]/, Text
        rule /\w+\s?/, Text
      end

    end
  end
end
