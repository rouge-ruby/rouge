# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class YARA < RegexLexer
      title 'YARA'
      desc 'YARA malware pattern-matching rule language'
      tag 'yara'
      aliases 'yar'
      filenames '*.yar', '*.yara'
      mimetypes 'text/x-yara'

      def self.detect?(text)
        return true if text =~ /\A\s*(?:rule|import|include)\b/
      end

      def self.keywords
        @keywords ||= Set.new %w(
          all and any at condition contains defined endswith
          entrypoint filesize for global icontains iendswith
          iequals in istartswith matches meta none not of
          or private startswith strings them
        )
      end

      def self.keywords_declaration
        @keywords_declaration ||= Set.new %w(
          rule import include
        )
      end

      def self.keywords_pseudo
        @keywords_pseudo ||= Set.new %w(
          ascii base64 base64wide fullword nocase wide xor
        )
      end

      def self.builtins
        @builtins ||= Set.new %w(
          int8 int16 int32 uint8 uint16 uint32
          int8be int16be int32be uint8be uint16be uint32be
        )
      end

      state :root do
        rule %r/\s+/, Text::Whitespace
        rule %r(//.*$), Comment::Single
        rule %r(/\*), Comment::Multiline, :multiline_comment

        # section labels: meta: strings: condition:
        rule %r/(meta|strings|condition)(\s*)(:)/ do
          groups Name::Label, Text::Whitespace, Punctuation
        end

        # hex string entry: = { hex_content }
        rule %r/(=)(\s*)(\{)/m do
          groups Operator, Text::Whitespace, Str::Other
          push :hex_string
        end

        # double-quoted strings
        rule %r/"/, Str::Double, :string

        # regex literals
        rule %r(/) do
          token Str::Regex
          push :regex
        end

        # variables: $ident, #ident, @ident, !ident, bare $
        rule %r/[#@!]\w+/, Name::Variable
        rule %r/\$\w*/, Name::Variable

        # hex numbers
        rule %r/0x[0-9a-fA-F]+/, Num::Hex
        # decimal numbers with optional size suffix
        rule %r/\d+(?:KB|MB)?/, Num::Integer

        # range operator
        rule %r/\.\./, Operator

        # multi-character operators
        rule %r/==|!=|<=|>=|<<|>>/, Operator
        # single-character operators
        rule %r/[+\-*\\%&|^~<>=]/, Operator

        # punctuation
        rule %r/[{}()\[\]:.,]/, Punctuation

        # word classification
        rule %r/\w+/ do |m|
          if self.class.keywords_declaration.include?(m[0])
            token Keyword::Declaration
          elsif self.class.keywords_pseudo.include?(m[0])
            token Keyword::Pseudo
          elsif m[0] == 'true' || m[0] == 'false'
            token Keyword::Constant
          elsif self.class.builtins.include?(m[0])
            token Name::Builtin
          elsif self.class.keywords.include?(m[0])
            token Keyword
          else
            token Name
          end
        end
      end

      state :multiline_comment do
        rule %r([*]/), Comment::Multiline, :pop!
        rule %r([^*]+), Comment::Multiline
        rule %r([*]), Comment::Multiline
      end

      state :string do
        rule %r/\\./, Str::Escape
        rule %r/"/, Str::Double, :pop!
        rule %r/[^\\"]+/, Str::Double
      end

      state :hex_string do
        rule %r/\s+/, Text::Whitespace
        rule %r/\}/, Str::Other, :pop!
        rule %r(//.*$), Comment::Single
        rule %r(/\*), Comment::Multiline, :multiline_comment
        rule %r/[0-9a-fA-F?]{2}/, Str::Other
        rule %r/~/, Operator
        rule %r/\[[\d\-]*\]/, Str::Other
        rule %r/[|()]/, Punctuation
      end

      state :regex do
        rule %r/\\./, Str::Regex
        rule %r(/[is]*), Str::Regex, :pop!
        rule %r([^\\/]+), Str::Regex
      end
    end
  end
end
