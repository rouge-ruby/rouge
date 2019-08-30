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
          token Operator, m[1]
          token Name::Function, m[2]
          token Operator, m[3]
        end

        # covers built-in and custom functions
        rule %r/([a-z][a-z._\s]*)(\()/i do |m|
          token Keyword, m[1]
          token Operator, m[2]
        end

        rule %r(//.*?$), Comment::Single
        rule %r(/\*.*?\*/)m, Comment::Multiline
        rule %r/"\\\[.*?\]\\"/m, Str              # escaped string
        rule %r/"(\\!"|[^"])*"/m, Str
        rule %r/[*!%&\[\](){}<>\|+=:\/-]/, Operator
        rule %r/\b[+-]?([0-9]+(\.[0-9]+)?|\.[0-9]+|\.)(e[+-]?[0-9]+)?i?\b/i, Num
        rule %r/\n/, Text
        rule %r/./, Text
      end
    end
  end
end
