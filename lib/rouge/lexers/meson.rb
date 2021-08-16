# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Meson < RegexLexer
      title "Meson"
      desc "Meson's specification language"
      tag 'meson'
      filenames 'meson.build'

      def self.keywords
        @keywords ||= %w(
          continue break elif else endif
          if true false foreach endforeach
        )
      end

      def self.reserved
        @reserved ||= %w(
          import meson
        )
      end

      identifier =        /[[:alpha:]_][[:alnum:]_]*/
      dotted_identifier = /[[:alpha:]_.][[:alnum:]_.]*/

      def current_string
        @string_register ||= StringRegister.new
      end

      state :root do
        rule %r/\n+/m, Text

        rule %r/[^\S\n]+/, Text
        rule %r(#(.*)?\n?), Comment::Single
        rule %r/[\[\]{}:(),;.]/, Punctuation
        rule %r/\\\n/, Text
        rule %r/\\/, Text

        rule %r/(in|and|or|not)\b/, Operator::Word
        rule %r/[-+\/*%=<>]=?|!=/, Operator

        rule %r/([f]?)('''|['])/i do |m|
          groups Str::Affix, Str
          current_string.register type: m[1].downcase, delim: m[2]
          push :generic_string
        end

        rule %r/(?<!\.)#{identifier}/ do |m|
          if self.class.reserved.include? m[0]
            token Keyword::Reserved
          elsif self.class.keywords.include? m[0]
            token Keyword
          else
            token Name
          end
        end

        rule identifier, Name

        digits = /[0-9](_?[0-9])*/
        decimal = /((#{digits})?\.#{digits}|#{digits}\.)/

        rule %r/0b(_?[0-1])+/i, Num::Bin
        rule %r/0o(_?[0-7])+/i, Num::Oct
        rule %r/0x(_?[a-f0-9])+/i, Num::Hex
        rule %r/([1-9](_?[0-9])*|0(_?0)*)/, Num::Integer
      end

      state :generic_string do
        rule %r/[^'\\\@]+/, Str

        rule %r/'''|[']/ do |m|
          token Str
          if current_string.delim? m[0]
            current_string.remove
            pop!
          end
        end

        rule %r/(?=\\)/, Str, :generic_escape

        rule %r/\@/ do |m|
          if current_string.type? "f"
            token Str::Interpol
            push :generic_interpol
          else
            token Str
          end
        end
      end

      state :generic_escape do
        rule %r(\\
          ( [\\abfnrtv']
          | N{[a-zA-Z][a-zA-Z ]+[a-zA-Z]}
          | u[a-fA-F0-9]{4}
          | U[a-fA-F0-9]{8}
          | x[a-fA-F0-9]{2}
          | [0-7]{1,3}
          )
        )x do
          token(Str::Escape)
          pop!
        end

        rule %r/\\./, Str, :pop!
      end

      state :generic_interpol do
        rule %r/[^\@]+/ do |m|
          recurse m[0]
        end
        rule %r/\@/, Str::Interpol, :pop!
      end

      class StringRegister < Array
        def delim?(delim)
          self.last[1] == delim
        end

        def register(type: "u", delim: "'")
          self.push [type, delim]
        end

        def remove
          self.pop
        end

        def type?(type)
          self.last[0].include? type
        end
      end

      private_constant :StringRegister
    end
  end
end
