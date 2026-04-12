# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Datastudio < RegexLexer
      tag 'datastudio'
      filenames '*.job'
      mimetypes 'text/x-datastudio'

      title "Datastudio"
      desc 'Datastudio scripting language'

      lazy { require_relative 'datastudio/keywords' }

      id = /@?[_a-z]\w*/i

      state :whitespace do
        rule %r/\s+/m, Text
        rule %r(//.*?$), Comment::Single
        rule %r(/[*].*?[*]/)m, Comment::Multiline
      end

      state :string do
        rule %r/%(\\.|.)+?%/, Str::Escape
        rule %r/\\"/, Str::Double
        rule %r/"/, Str::Double, :pop!
        rule %r/./m, Str::Double
      end

      state :string_s do
        rule %r/%(\\.|.)+?%/, Str::Escape
        rule %r/\\'/, Str::Single
        rule %r/'/, Str::Single, :pop!
        rule %r/./m, Str::Single
      end

      state :root do
        mixin :whitespace

        rule %r/^:#{id}/, Name::Label
        rule %r/@#{id}(\.#{id})?/m, Name::Entity
        rule %r/%(\\.|.)+?%/, Name::Variable
        rule %r/[~!%^&*()+=|\[\]{}:;,.<>\/?-]/, Punctuation
        rule %r/"/, Str::Double, :string
        rule %r/'/, Str::Single, :string_s
        rule %r/\d(\.\d*)?/i, Num
        rule %r/#{id}(?=\s*[(])/, Name::Function

        keywords id do
          transform(&:upcase)

          rule SQL_KEYWORDS, Keyword
          default Name
        end
      end
    end
  end
end
