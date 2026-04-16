# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class HLSL < RegexLexer
      title "HLSL"
      desc "HLSL, the High Level Shading Language for DirectX (docs.microsoft.com/en-us/windows/win32/direct3dhlsl/dx-graphics-hlsl)"
      tag 'hlsl'
      filenames '*.hlsl', '*.hlsli'
      mimetypes 'text/x-hlsl'

      lazy { require_relative 'hlsl/keywords' }

      id = /[a-zA-Z_][a-zA-Z0-9_]*/

      start { push :newline }

      state :inline_whitespace do
        rule %r/[ \t]+/m, Text
        rule %r/\\\n/, Str::Escape
      end

      state :whitespace do
        mixin :inline_whitespace
        rule %r(//.*\n), Comment, :newline
        rule %r(/[*].*?[*]/)m, Comment::Multiline
        rule %r/\n\s*/, Text, :newline
      end

      state :newline do
        mixin :inline_whitespace
        rule %r/#/ do
          token Comment::Preproc
          goto :preproc
        end

        rule(//) { pop! }
      end

      state :preproc do
        mixin :inline_whitespace
        rule %r/\n/, Comment::Preproc, :pop!
        rule %r/[^\n]/, Comment::Preproc
      end

      # ref: https://microsoft.github.io/hlsl-specs/specs/hlsl.pdf
      state :root do
        mixin :whitespace

        exp = %r/e[+-]?\d+/i

        rule %r/[;:(){}\[\]=,]/, Punctuation
        rule %r([-+/*]), Operator
        rule %r([<>]=?), Operator

        # the language doesn't actually have quoted strings but annotations do
        # e.g. [domain("quad")]
        rule %r(".*?"), Str::Double

        # handles: 5.
        rule %r/\d+[.]\d*#{exp}?[hfl]?/i, Num::Float

        # handles: .5
        rule %r/[.]\d+#{exp}?[hfl]?/i, Num::Float

        # handles: 5f
        rule %r/\d+#{exp}?[hfl]/i, Num::Float

        # handles: 5e4
        rule %r/\d+#{exp}[hfl]?/i, Num::Float

        rule %r/0[0-7]+[ul]?/, Num::Oct
        rule %r/0x\h+[ul]?/, Num::Hex
        rule %r/\d+[ul]?\b/i, Num::Integer

        keywords id do
          rule KEYWORDS, Keyword
          rule KEYWORDS_TYPE, Keyword::Type
          rule RESERVED, Keyword::Reserved
          rule BUILTINS, Name::Builtin
        end

        rule %r/#{id}(?=[ \t]*[(])/, Name::Function
        rule id, Name

        rule %r/[.]/, Punctuation, :post_dot
      end

      state :post_dot do
        mixin :whitespace

        rule id, Name, :pop!

        rule(//) { pop! }
      end
    end
  end
end
