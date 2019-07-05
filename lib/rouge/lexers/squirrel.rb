# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Squirrel < RegexLexer
      tag "squirrel"
      filenames "*.nut"
      mimetypes "text/x-squirrel"

      title "Squirrel"
      desc "The Squirrel programming language (squirrel-lang.org)"

      def self.keywords
        @keywords ||= %w(
          base break case catch clone
          continue default delete else enum
          for foreach function if in
          local resume return switch this
          throw try typeof while yield constructor
          instanceof
        )
      end

      def self.declarations
        @declarations ||= %w(
          class const extends static local
        )
      end

      def self.id
        @id ||= %r(@?[_a-z]\w*)i
      end

      state :root do
        rule %r(\s+)m, Text

        # comments
        rule %r((#|//).*?$), Comment::Single
        rule %r(/[*].*?[*]/)m, Comment::Multiline

        # strings
        rule %r(@"(""|[^"])*")m, Str
        rule %r("(\\.|.)*?["\n]), Str
        rule %r('(\\.|.)'), Str::Char

        # keywords
        rule %r((?:#{Squirrel.keywords.join('|')})\b), Keyword
        rule %r((?:#{Squirrel.declarations.join('|')})\b), Keyword::Declaration
        rule %r((?:true|false|null)\b), Keyword::Constant
        rule %r((?:class)\b), Keyword::Declaration, :class

        # operators and punctuation
        rule %r([~!%^&*()+=|\[\]{}:;,.<>\/?-]), Punctuation

        rule %r([0-9]+(([.]([0-9]+)?)(e[-]?[0-9]+)?)), Num::Float
        rule %r(0x[0-9a-fA-F]+|0[0-7]+|[0-9]+), Num::Integer
        rule Squirrel.id, Name
      end

      state :class do
        rule %r(\s+)m, Text
        rule Squirrel.id, Name::Class, :pop!
      end

    end
  end
end
