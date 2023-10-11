# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class YARA < RegexLexer
      title "YARA"
      desc ""
      tag 'yara'
      filenames '*.yar', '*.yara'

      def self.keywords
        @keywords ||= Set.new %w(
          all and any ascii at condition contains entrypoint
          filesize for fullword global import in include matches
          meta not nocase of or private rule strings them wide xor
        )
      end

      state :root do
        rule /[^\S]+/, Text
        rule /\/\/.*$/, Comment::Single
        rule /\/\*/, Comment::Multiline, :block_comment

        rule /(\$[a-zA-Z0-9_]+)(\s*)(=)(\s*)({)/ do
          groups Name::Variable, Text, Text, Text, Str
          push :hex_string
        end
        rule /(\$[a-zA-Z0-9_]+)(\s*)(=)(\s*)/ do
          groups Name::Variable, Text, Text, Text
        end

        rule /"/, Str, :string
        rule /\//, Str, :regexp

        rule /(u)?int(8|16|32)(be)?/, Name::Builtin
        rule /\b(true|false)\b/, Name::Builtin::Pseudo
        rule /0x[a-fA-F0-9]+/, Num::Hex
        rule /(-|\+)?\d+(MB|KB)?/, Num::Integer
        rule /[a-z_][a-zA-Z0-9_]*/ do |m|
          if self.class.keywords.include? m[0]
            token Keyword
          else
            token Name
          end
        end

        rule /\$[a-zA-Z0-9_]*(\*)?/, Name::Variable
        rule /[@!#][a-zA-Z0-9_]+/, Name::Variable
        rule /[!=:{}()\[\].<>+*%&|^~,\\\/-]/, Text
      end

      state :string do
        rule /"/, Str, :pop!
        rule /\\([\\trnfa"]|x[a-fA-F0-9]{2})/, Str::Escape
        rule /[^\\"]+/, Str
      end

      state :block_comment do
        rule /\*\//, Comment::Multiline, :pop!
        rule /\*[^\/]/, Comment::Multiline
        rule /[^*]+/, Comment::Multiline
        rule /\n/, Comment::Multiline
        rule /./, Error
      end

      state :hex_string do
        rule /}/, Str, :pop!
        rule /[^}]+/, Str
      end

      state :regexp do
        rule /\/(si|is|s|i)?/, Str, :pop!
        rule /\\./, Str
        rule /[^\\\/]+/, Str
      end
    end
  end
end
