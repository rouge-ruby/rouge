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
        rule %r/"\\\[.*?\]\\"/m, Str::Double  # escaped string
        rule %r/"(?:\\!"|[^"])*"/m, Str::Double
        rule %r/[*!%&\[\](){}<>\|+=:\/-]/, Operator
        rule %r/\b[+-]?(?:[0-9]+(?:\.[0-9]+)?|\.[0-9]+|\.)(?:e[+-]?[0-9]+)?i?\b/i, Num
        rule %r/\n/, Text
        rule %r/./, Text
      end
    end
  end
end
