# -*- coding: utf-8 -*- #
# frozen_string_literal: true

require_relative 'c'

module Rouge
  module Lexers
    class GLSL < RegexLexer
      tag 'glsl'
      filenames '*.glsl', '*.frag', '*.vert', '*.geom', '*.vs', '*.gs', '*.shader'
      mimetypes 'x-shader/x-vertex', 'x-shader/x-fragment', 'x-shader/x-geometry'

      title "GLSL"
      desc "The GLSL shader language"

      lazy { require_relative "glsl/builtins" }

      state :root do
        rule %r/\s+/, Text
        rule %r(/[*].*?[*]/)m, Comment::Multiline
        rule %r(//.*$), Comment

        rule %r/^#(?:[^\n]|\\\r?\n)*/, Comment::Preproc
        rule %r/defined\b/, Comment::Preproc
        rule %r/__(?:LINE|FILE|VERSION)__\b/, Keyword::Constant
        rule %r/(?:true|false)\b/, Keyword::Pseudo

        rule %r/0x\h+u?/i, Num::Hex
        rule %r/(?:\d+[.]\d*|[.]\d+)(?:e[+-]?\d+)?(?:l?f)?/i, Num::Float
        rule %r/\d+(?:e[+-]?\d+)(?:l?f)?/i, Num::Float
        rule %r/[1-9]\d*u?/i, Num::Integer
        rule %r/0[0-7]+/, Num::Oct
        rule %r/0/, Num::Integer
        rule %r([-.+/*%<>\[\](){}^|&~=!:;,?]), Punctuation

        keywords %r/\w+/ do
          rule KEYWORDS, Keyword
          rule TYPES, Keyword::Type
        end

        keywords %r/\w+(?=\s*[(])/ do
          rule BUILTINS, Name::Builtin
          default Name::Function
        end

        keywords %r/\w+/ do
          rule GL_VARS, Name::Constant
          rule BUILTINS, Name::Builtin
          default Name
        end
      end
    end

    # backcompat
    Glsl = GLSL
  end
end
