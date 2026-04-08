# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Bsl < RegexLexer
      title "1C (BSL)"
      desc "The 1C:Enterprise programming language"
      tag 'bsl'
      filenames '*.bsl', '*.os'

      lazy { require_relative 'bsl/keywords' }

      state :root do
        rule %r/\n/, Text
        rule %r/[^\S\n]+/, Text
        rule %r(//.*$), Comment::Single
        rule %r/[\[\]:(),;]/, Punctuation
        rule %r/(?<=[^\wа-яё]|^)\&.*$/, Keyword::Declaration
        rule %r/[-+\/*%=<>.?&]/, Operator
        rule %r/(?<=[^\wа-яё]|^)\#.*$/, Keyword::Declaration
        keywords %r/\p{Word}+/ do
          rule KEYWORDS, Keyword
        end

        keywords %r/\p{Word}+(?=\s*[(])/ do
          rule BUILTINS, Name::Builtin
        end

        rule %r/[\wа-яё][\wа-яё]*/i, Name::Variable

        #literals
        rule %r/\b((\h{8}-(\h{4}-){3}\h{12})|\d+\.?\d*)\b/, Literal::Number
        rule %r/\'.*\'/, Literal::Date
        rule %r/".*?("|$)/, Literal::String::Single
        rule %r/(?<=[^\wа-яё]|^)\|((?!\"\").)*?(\"|$)/, Literal::String
      end
    end
  end
end
