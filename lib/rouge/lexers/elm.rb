# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Elm < RegexLexer

      BUILTIN_KEYWORDS = [
        'if',
        'else',
        'then',
        'case',
        'of',
        'type',
        'let',
        'in',
      ]

      RESERVED_KEYWORDS = [
        'module',
        'exposing',
        'type',
      ]

      KeywordRegex = lambda do |arr|
        /\b#{arr.join('\b|\b')}\b/
      end

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

        rule KeywordRegex.(RESERVED_KEYWORDS), Keyword::Reserved
        rule KeywordRegex.(BUILTIN_KEYWORDS), Name::Builtin

        rule /\A\w+ :/, Name::Function
        rule /[A-Z][a-z]+/, Keyword::Type

        rule /[a-z]+[A-Z]/, Text
        rule /\w+\s?/, Text
      end

    end
  end
end
