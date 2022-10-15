# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Forth < RegexLexer
      title "Forth"
      desc "The Forth programming language"
      tag 'forth'
      aliases 'fs'
      filenames '*.fs', '*.fth', '*.4th'
      mimetypes 'text/x-forth'

      def self.detect?(text)
        return true if text.shebang? 'gforth'
      end

      def self.keywords
        @keywords ||= Set.new %w(
          :NONAME ; DOES> [ ] ]L IMMEDIATE
          DO ?DO LOOP +LOOP
          BEGIN UNTIL AGAIN REPEAT WHILE
          IF ELSE THEN
          CASE ENDCASE OF ENDOF
          LITERAL RECURSE
          ['] [COMPILE] POSTPONE
          TO IS
          ' CHAR
        )
      end

      state :root do
        rule %r/\s+/m, Text::Whitespace

        # comments
        rule %r/\\\s+.*$/, Comment::Single
        rule %r/#!\s+.*$/, Comment::Hashbang
        rule %r/\(\s+/, Comment::Multiline, :comment_paren

        # strings
        rule %r/(s"|c"|."|abort")/i, Str::Double, :string_quote
        rule %r/(\.\()/i, Str::Double, :string_paren

        # single character
        rule %r/(\[char\])(\s+)(\S)/i do
          groups Keyword, Text, Str::Char
        end

        # numbers
        rule %r/\-?\$\h+(?=\s)/, Num::Hex
        rule %r/\-?%[01]+(?=\s)/, Num::Bin
        rule %r/\-?#?\d+(?=\s)/, Num

        # constants
        rule %r/(true|false|bl|cell)(?=\s)/i, Keyword::Constant

        # includes
        rule %r/(require|include)(\s+)(\S+)/i do
          groups Keyword::Namespace, Text::Whitespace, Str
        end

        # definitions
        rule %r/(:|create|variable|constant|value|defer)(\s+)(\S+)/i do
          groups Keyword::Declaration, Text::Whitespace, Name::Function
        end

        # keywords
        rule %r/\S+/ do |m|
          if self.class.keywords.include?(m[0].upcase)
            token Keyword
          else
            token Name
          end
        end
      end

      state :comment_paren do
        rule %r([^\)]+), Comment::Multiline
        rule %r(\)), Comment::Multiline, :pop!
      end

      state :string_quote do
        rule %r/[^\"]+/, Str::Double
        rule %r/"/, Str::Double, :pop!
      end

      state :string_paren do
        rule %r/[^\)]+/, Str::Double
        rule %r/\)/, Str::Double, :pop!
      end
    end
  end
end
