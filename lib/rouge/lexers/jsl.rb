# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class JSL < RegexLexer
      title "JSL"
      desc "The JMP Scripting Language (JSL) (jmp.com)"

      tag 'jsl'
      filenames '*.jsl'

      state :root do
        rule %r/\s+/m, Text::Whitespace

        # messages
        rule %r/(<<)(.*?)(\(|;)/ do |m|
          groups Operator, Name::Function, Operator
        end

        # covers built-in and custom functions
        rule %r/([a-z][a-z._\s]*)(\()/i do |m|
          groups Keyword, Operator
        end

        rule %r(//.*?$), Comment::Single
        rule %r(/\*.*?\*/)m, Comment::Multiline

        rule %r/(")(\\\[)(.*?)(\]\\)(")/m do
          groups Str::Double, Str::Escape, Str::Double, Str::Escape, Str::Double  # escaped string
        end
        rule %r/"/, Str::Double, :dq

        rule %r/[*!%&\[\](){}<>\|+=:\/-]/, Operator
        rule %r/\b[+-]?(?:[0-9]+(?:\.[0-9]+)?|\.[0-9]+|\.)(?:e[+-]?[0-9]+)?i?\b/i, Num
        
        rule %r/./, Text
      end

      state :dq do
        rule %r/\\![btrnNf0\\"]/, Str::Escape
        rule %r/\\/, Str::Double
        rule %r/"/, Str::Double, :pop!
        rule %r/[^\\"]*/m, Str::Double
      end
    end
  end
end
