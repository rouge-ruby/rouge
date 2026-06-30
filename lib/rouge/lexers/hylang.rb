# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class HyLang < RegexLexer
      title "HyLang"
      desc "The HyLang programming language (hylang.org)"

      lazy { require_relative 'hylang/builtins' }

      tag 'hylang'
      aliases 'hy'

      filenames '*.hy'

      mimetypes 'text/x-hy', 'application/x-hy'

      identifier = %r([\w!$%*+,<=>?/.-]+)
      keyword = %r([\w!\#$%*+,<=>?/.-]+)

      def name_token(name)
        return Keyword if self.class.keywords.include?(name)
        return Name::Builtin if self.class.builtins.include?(name)
        nil
      end

      state :whitespace do
        rule %r/;.*?$/, Comment::Single
        rule %r/\s+/m, Text::Whitespace
      end

      state :root do
        mixin :whitespace

        rule %r/-?\d+\.\d+/, Num::Float
        rule %r/-?\d+/, Num::Integer
        rule %r/0x-?[0-9a-fA-F]+/, Num::Hex

        rule %r/"(\\.|[^"])*"/, Str
        rule %r/'#{keyword}/, Str::Symbol
        rule %r/::?#{keyword}/, Name::Constant
        rule %r/\\(.|[a-z]+)/i, Str::Char


        rule %r/~@|[`\'#^~&@]/, Operator

        rule %r/[(]/, Punctuation, :form_start

        keywords identifier do
          rule KEYWORDS, Keyword
          rule BUILTINS, Name::Builtin
          default Name
        end

        rule identifier do |m|
          token name_token(m[0]) || Name
        end

        # vectors
        rule %r/[\[\]]/, Punctuation

        # maps
        rule %r/[{}]/, Punctuation

        # parentheses
        rule %r/[()]/, Punctuation
      end

      state :form_start do
        mixin :whitespace

        keywords identifier do
          rule KEYWORDS, Keyword, :pop!
          rule BUILTINS, Name::Builtin, :pop!
          default Name::Function, :pop!
        end

        rule(//) { pop! }
      end
    end
  end
end
