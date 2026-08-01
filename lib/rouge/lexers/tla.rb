# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class TLA < RegexLexer
      title "TLA+"
      desc "The TLA+ modeling language for systems and programs"
      tag 'tla'
      aliases 'tlaplus'
      filenames '*.tla'

      # FIXME pretty sure this is too restrictive, but it'll do for now
      id = /[a-zA-Z_][a-zA-Z0-9_]*/

      keywords = %w/
        MODULE EXTENDS CONSTANT CONSTANTS VARIABLE VARIABLES
        ASSUME THEOREM
        LOCAL INSTANCE WITH
        IF THEN ELSE TRUE FALSE CASE OTHER
        LET IN
        ENABLED UNCHANGED
        DOMAIN EXCEPT ASSERT
        CHOOSE
        SUBSET UNION MOD
      /

      state :root do
        rule %r/\s+/m, Text

        rule %r/(\[\]\[)([^\]]+)(\]_)/ do |m|
          token Operator, m[1]
          token Name, m[2]
          token Operator, m[3]
        end

        rule %r/\-\-.*/, Comment::Single
        rule %r/\(\*.*\*\)/m, Comment::Multiline
        rule %r/^===+/, Comment::Single

        rule %r/(?:#{keywords.join('|')})\b/, Keyword
        rule %r/\\[a-z]+/, Name
        rule %r/"(\\\\|\\"|[^"])*"/, Str
        rule %r/#{id}'?/, Name
        rule %r/[0-9]+\.[0-9]*/, Num::Float
        rule %r/[0-9]+/, Num::Integer

        rule %r/[\\~#!%^&*+\|:.,<>=\[\]\(\)\{\}\/_@-]/, Operator
      end
    end
  end
end
