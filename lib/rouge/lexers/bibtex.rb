# -*- coding: utf-8 -*- #
# frozen_string_literal: true

# regex based on https://github.com/SaswatPadhi/prismjs-bibtex

module Rouge
  module Lexers
    class BibTeX < RegexLexer
      title 'BibTeX'
      desc "BibTeX"
      tag 'bibtex'
      filenames '*.bib'

      state :root do
        rule %r/%.*/, Comment
        rule %r/\s+/, Text::Whitespace
        rule %r/(^\s*)@(?:(?:preamble|string(?=\s*[({]))|comment(?=\s*[{]))/, Name::Namespace
        rule %r/(^\s*)@[^,={}'"\s]+(?=\s*{)/, Name::Class
        rule %r/[^,={}'"\s]+(?=\s*[,}])/, Keyword
        rule %r/([,{(]\s*)[^,={}'"\s]+(?=\s*=)/, Name::Attribute
        rule %r/(=\s*)[0-9]+(?=\s*[,}])/, Literal::Number
        rule %r/([=#]\s*){(?:[^{}]*|{(?:[^{}]*|{(?:[^{}]*|{[^}]*})*})*})*}/, Literal::String
        rule %r/([=#]\s*)[^,={}'"\s]+(?=\s*[#,}])/, Literal::String
        rule %r/("|')(?:(?!\1)[^\\]|\\(?:\r\n|[\s\S]))*\1/, Literal::String::Char
        rule %r/#/, Literal::String::Symbol
        rule %r/[=,{}]/, Text
      end
    end
  end
end
