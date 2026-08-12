# -*- coding: utf-8 -*- #
# frozen_string_literal: true

require_relative 'cpp'

module Rouge
  module Lexers
    class FreeFEM < Cpp
      title "FreeFEM"
      desc "The FreeFEM programming language (freefem.org)"

      tag 'freefem'
      aliases 'ff'
      filenames '*.edp', '*.idp'
      mimetypes 'text/x-ffhdr', 'text/x-ffsrc'

      lazy { require_relative 'freefem/keywords' }

      id = /[a-z_]\w*/i

      state :expr_bol do
        mixin :inline_whitespace

        rule %r/include/, Comment::Preproc, :macro
        rule %r/load/, Comment::Preproc, :macro
        rule %r/ENDIFMACRO/, Comment::Preproc, :macro
        rule %r/IFMACRO/, Comment::Preproc, :macro

        rule(//) { pop! }
      end

      state :statements do
        mixin :whitespace
        rule %r/(u8|u|U|L)?"/, Str, :string
        rule %r((u8|u|U|L)?'(\\.|\\[0-7]{1,3}|\\x[a-f0-9]{1,2}|[^\\'\n])')i, Str::Char
        rule %r((\d+[.]\d*|[.]?\d+)e[+-]?\d+[lu]*)i, Num::Float
        rule %r(\d+e[+-]?\d+[lu]*)i, Num::Float
        rule %r/0x[0-9a-f]+[lu]*/i, Num::Hex
        rule %r/0[0-7]+[lu]*/i, Num::Oct
        rule %r/\d+[lu]*/i, Num::Integer
        rule %r(\*/), Error
        rule %r([~!%^&*+=\|?:<>/-]), Operator
        rule %r/'/, Operator
        rule %r/[()\[\],.;]/, Punctuation
        rule %r/\bcase\b/, Keyword, :case
        rule %r/(?:true|false|NaN)\b/, Name::Builtin

        keywords id do
          rule :keywords, Keyword
          rule :keywords_type, Keyword::Type
          rule :reserved, Keyword::Reserved
          rule :builtins, Name::Builtin
          rule :attributes, Name::Attribute
          default Name
        end
      end
    end
  end
end
