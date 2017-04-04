# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Pony < RegexLexer
      tag 'pony'
      filenames '*.pony'

      keywords = %w(
        actor addressof and as
        be break
        class compiler_intrinsic consume continue
        do
        else elseif embed end error
        for fun
        if ifdef in interface is isnt
        lambda let
        match
        new not
        object
        primitive
        recover repeat return
        struct
        then this trait try type
        until use
        var
        where while with
      )

      capabilities = %w(
        box iso ref tag trn val
      )

      types = %w(
        Number Signed Unsigned Float
        I8 I16 I32 I64 I128 U8 U32 U64 U128 F32 F64
        EventID Align IntFormat NumberPrefix FloatFormat
        Type
      )

      state :whitespace do
        rule /[\s\t\r\n]+/m, Text
      end

      state :root do
        mixin :whitespace
        rule /"""/, Str::Doc, :docstring
        rule /"/, Str, :string
        rule %r(//(.*?)\n), Comment::Single
        rule %r(/(\\\n)?[*](.|\n)*?[*](\\\n)?/), Comment::Multiline
        rule /#{capabilities.join('|')}\b/, Keyword::Declaration
        rule /#{keywords.join('|')}\b/, Keyword::Reserved
        rule /#{types.join('|')}\b/, Keyword::Type
        rule %r([~!%^&*+=\|?:<>/-]), Operator
        rule /(true|false|NULL)\b/, Name::Constant
        rule %r{(?:[A-Z_][a-zA-Z0-9_]*)}, Name::Class
        rule /[()\[\],.';]/, Punctuation
        rule /0[xX]([0-9a-fA-F_]*\.[0-9a-fA-F_]+|[0-9a-fA-F_]+)[pP][+\-]?[0-9_]+[fFL]?[i]?/, Num::Float
        rule /[0-9_]+(\.[0-9_]+[eE][+\-]?[0-9_]+|\.[0-9_]*|[eE][+\-]?[0-9_]+)[fFL]?[i]?/, Num::Float
        rule /\.(0|[1-9][0-9_]*)([eE][+\-]?[0-9_]+)?[fFL]?[i]?/, Num::Float
        rule /0[xX][0-9a-fA-F_]+/, Num::Hex
        rule /(0|[1-9][0-9_]*)([LUu]|Lu|LU|uL|UL)?/, Num::Integer
        rule /[a-zA-Z_]\w*/, Name
      end

      state :string do
        rule /"/, Str, :pop!
        rule /\\([\\abfnrtv"']|x[a-fA-F0-9]{2,4}|[0-7]{1,3})/, Str::Escape
        rule /[^\\"\n]+/, Str
        rule /\\\n/, Str
        rule /\\/, Str # stray backslash
      end

      state :docstring do
        rule /"""/, Str::Doc, :pop!
        rule /\n/, Str::Doc
        rule /./, Str::Doc
      end
    end
  end
end
