# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class ANTLR < RegexLexer
      title "ANTLR"
      desc "ANother Tool for Language Recognition"
      tag 'antlr'
      filenames '*.g4'
      word = /[a-z][a-zA-Z0-9_]*/
      WORD = /[A-Z][a-zA-Z0-9_]*/
      def self.keywords
        @keywords ||= Set.new %w(
          import fragment lexer parser grammar protected public private returns
          locals throws catch finally mode options tokens channels channel type
          popMode pushMode skip more
        )
      end
      state :string do
        rule %r/'/, Str, :pop!
        rule %r/\\./, Str::Escape
        rule %r/[^\\'\n]+/, Str
      end
      state :charset do
        rule %r/\]/, Name::Variable, :pop!
        rule %r/\\./, Str::Escape
        rule %r/[^\\\[\]\n]+/, Name::Variable
      end
      state :label do
        rule %r/[a-zA-Z0-9_]+/, Name::Label, :pop!
        rule %r/\s+/, Text
      end
      state :block do
        rule %r/}/, Punctuation, :pop!
        rule %r/\\./, Str::Escape
        rule %r/[^\\{}\s]+/, Name::Builtin
        rule %r/\s+/, Text
      end
      state :root do
        rule %r/\s+/, Text
        rule %r(//.*?$), Comment::Single
        rule %r(/\*.*?\*/)m, Comment::Multiline
        rule %r/'/, Str, :string
        rule %r/\[/, Name::Variable, :charset
        rule %r/#/, Name::Label, :label
        rule %r/{/, Punctuation, :block
        rule %r/0|[1-9][0-9]*/, Num::Integer
        rule %r/[-?@*+<=>~$.]/, Operator
        rule %r/[;:()|]/, Punctuation
        rule %r/\\./, Str::Escape
        rule WORD, Name::Class
        rule word do |m|
          if self.class.keywords.include? m[0]
            token Keyword
          else
            token Name::Function
          end
        end
      end
    end
  end
end
