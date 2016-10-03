# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Elm < RegexLexer
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

        rule /".*?"/m, Literal::String::Symbol
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
          /,/
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
          /:/,
          /=/,
        ), Operator

        rule /#{Regexp.quote('..')}/, Keyword::Declaration

        rule /module|exposing|type\'?/, Keyword::Reserved

        rule /\sif|else|then|case|of|type|let|in[^\w]/, Name::Builtin # FIXME: this is obviously not the way to go.

        rule /\A\w+ :/, Name::Function
        rule /[A-Z][a-z]+/, Keyword::Type

        rule /[a-z]+[A-Z]/, Text
        rule /\w+\s?/, Text
      end

    end
  end
end
