# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class CSVS < RegexLexer
      tag 'csvs'
      title "csvs"
      desc 'The CSV Schema Language (digital-preservation.github.io)'
      filenames '*.csvs'

      state :root do
        rule %r/\s+/m, Text
        rule %r(//.*), Comment::Single
        rule %r(#.*), Comment::Single
        rule %r(/(\\\n)?[*].*?[*](\\\n)?/)m, Comment::Multiline
        rule %r(/[+]), Comment::Multiline, :nested_comment

        rule %r/"[^"]*"/, Str::Double
        rule %r/'[^\r\n\f']'/, Str::Char

        rule %r(:?:=), Keyword
        rule %r/[()]/, Punctuation

        rule %r([-=;,*+><!/|^.%&\[\]{}]), Operator

        rule %r/[A-Z]\w*/, Name::Class

        rule %r/[a-z_]\w*/, Name

        rule %r((\d+[.]?\d*|\d*[.]\d+)(e[+-]?[0-9]+)?)i, Num::Float
        rule %r/\d+/, Num::Integer

        rule %r/@@?|\'|\:/, Keyword
      end

      state :nested_comment do
        rule %r([^/+]+)m, Comment::Multiline
        rule %r(/[+]), Comment::Multiline, :nested_comment
        rule %r([+]/), Comment::Multiline, :pop!
      end
    end
  end
end
