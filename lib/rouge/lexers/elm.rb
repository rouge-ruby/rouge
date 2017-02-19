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

        state :multi do
          rule /\{-.*/, Comment::Multiline
        end

      state :root do
        rule /\n|\s/, Text
        rule /\-\-.+/, Comment::Single

        rule /\{\-.*?\-\}/m, Comment::Multiline

        rule /".*?"/m, Literal::String
        rule /\d/, Literal::Number
        rule /\s/, Text::Whitespace

        rule /\\\(/, Punctuation
        rule /\(/, Punctuation
        rule /\)/, Punctuation
        rule /\{/, Punctuation
        rule /\}/, Punctuation
        rule /\[/, Punctuation
        rule /\]/, Punctuation
        rule /\./, Punctuation
        rule /,/, Punctuation
        rule /\\\\/, Punctuation
        rule /\\/, Punctuation
        rule /'/, Punctuation # Not sure how single quotes should be handled for now

        rule /#{Regexp.escape('++')}/, Operator
        rule /#{Regexp.escape('->')}/, Operator
        rule /#{Regexp.escape('<|')}/, Operator
        rule /#{Regexp.escape('|>')}/, Operator
        rule /#{Regexp.escape('|')}/, Operator
        rule /#{Regexp.escape('+')}/, Operator
        rule /#{Regexp.escape('-')}/, Operator
        rule /#{Regexp.escape('*')}/, Operator
        rule /#{Regexp.escape('^')}/, Operator
        rule /:/, Operator
        rule /&&/, Operator
        rule /#{Regexp.escape('||')}/, Operator
        rule /#{Regexp.escape('=')}/, Operator

        rule /\.\./, Keyword::Declaration

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
