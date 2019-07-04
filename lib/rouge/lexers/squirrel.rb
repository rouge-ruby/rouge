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
        @id ||= /@?[_a-z]\w*/i
      end

      state :root do
        rule /\s+/m, Text

        # comments
        rule %r((#|//).*?$), Comment::Single
        rule %r(/[*].*?[*]/)m, Comment::Multiline

        # strings
        rule /@"(""|[^"])*"/m, Str
        rule /"(\\.|.)*?["\n]/, Str
        rule /'(\\.|.)'/, Str::Char

        # keywords
        rule /(?:#{Squirrel.keywords.join('|')})\b/, Keyword
        rule /(?:#{Squirrel.declarations.join('|')})\b/, Keyword::Declaration
        rule /(?:true|false|null)\b/, Keyword::Constant
        rule /(?:class)\b/, Keyword::Declaration, :class

        # operators and punctuation
        rule /[~!%^&*()+=|\[\]{}:;,.<>\/?-]/, Punctuation

        rule /[0-9]+(([.]([0-9]+)?)(e[-]?[0-9]+)?)/, Num::Float
        rule /0x[0-9a-fA-F]+|0[0-7]+|[0-9]+/, Num::Integer
        rule Squirrel.id, Name
      end

      state :class do
        rule /\s+/m, Text
        rule Squirrel.id, Name::Class, :pop!
      end

    end
  end
end
