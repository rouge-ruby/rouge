# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Xojo < RegexLexer
      title "Xojo"
      desc "Xojo"
      tag 'xojo'
      aliases 'realbasic'
      filenames '*.xojo_code', '*.xojo_window', '*.xojo_toolbar', '*.xojo_menu'

      keywords = %w(
          addhandler aggregates array asc assigns attributes begin break
          byref byval call case catch class const continue char ctype declare
          delegate dim do downto each else elseif end enum event exception
          exit extends false finally for function global goto if
          implements inherits interface lib loop mod module
          new next nil object of optional paramarray
          private property protected public raise raiseevent rect redim
          removehandler return select shared soft static step sub super
          then to true try until using uend uhile
        )

      keywords_type = %w(
          boolean cfstringref cgfloat cstring curency date double int8 int16
          int32 int64 integer ostype pstring ptr short single
          single string structure variant uinteger uint8 uint16 uint32 uint64
          ushort windowptr wstring
        )

      operator_words = %w(
          addressof and as in is isa mod not or xor
        )

      state :root do
        rule /\s+/, Text::Whitespace

        rule /rem\b.*?$/i, Comment::Single
        rule /\/\/.*$/, Comment::Single
        rule /\#tag Note.*\#tag EndNote/m, Comment::Preproc
        rule /\s*[#].*$/x, Comment::Preproc

        rule /".*?"/, Literal::String::Double
        rule /[(){}!#,:]/, Punctuation

        rule /\b(?:#{keywords.join('|')})\b/i, Keyword
        rule /\b(?:#{keywords_type.join('|')})\b/i, Keyword::Declaration

        rule /\b(?:#{operator_words.join('|')})\b/i, Operator
        rule /[+-]?(\d+\.\d*|\d*\.\d+)/i, Literal::Number::Float
        rule /[+-]?\d+/, Literal::Number::Integer
        rule /&[CH][0-9a-f]+/i, Literal::Number::Hex
        rule /&O[0-7]+/i, Literal::Number::Oct

        rule /\b[\w\.]+\b/i, Text
        rule(%r(<=|>=|<>|[=><\+\-\*\/\\]), Operator)
      end
    end
  end
end
