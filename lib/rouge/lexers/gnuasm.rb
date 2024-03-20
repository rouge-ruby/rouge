# -*- coding: utf-8 -*- #
# frozen_string_literal: true

# Derived from nasm.rb. Not perfect.
module Rouge
  module Lexers
    class GnuAsm < RegexLexer
      title "GnuAsm"
      desc "GNU Assembler"

      tag 'gnuasm'
      filenames '*.s', '*.S'
      mimetypes 'text/x-asm'

      state :root do
        mixin :whitespace

        rule %r/[a-z$._?][\w$.?#@~]*:/i, Name::Label

        rule %r/([a-z$._?][\w$.?#@~]*)(\s+)(equ)/i do
          groups Name::Constant, Keyword::Declaration, Keyword::Declaration
          push :instruction_args
        end
        rule %r/\.[a-z0-9]+/i, Keyword, :instruction_args
        rule %r/(?:res|d)[bwdqt]|times/i, Keyword::Declaration, :instruction_args
        rule %r/[a-z$._?][\w$.?#@~]*/i, Name::Function, :instruction_args

        rule %r/[\r\n]+/, Text
      end

      state :instruction_args do
        rule %r/"(\\\\"|[^"\n])*"|'(\\\\'|[^'\n])*'|`(\\\\`|[^`\n])*`/, Str
        rule %r/(?:0x[\da-f]+|$0[\da-f]*|\d+[\da-f]*h)/i, Num::Hex
        rule %r/[0-7]+q/i, Num::Oct
        rule %r/[01]+b/i, Num::Bin
        rule %r/\d+\.e?\d+/i, Num::Float
        rule %r/\d+/, Num::Integer

        rule %r/[@$][a-z$._][\w$.?#@~]*/i, Name::Constant

        mixin :punctuation

        rule %r/%[a-z0-9]+/i, Name::Builtin
        rule %r/[a-z$._][\w$.?#@~]*/i, Name::Variable
        rule %r/[\r\n]+/, Text, :pop!

        mixin :whitespace
      end

      state :whitespace do
        rule %r/\n/, Text
        rule %r/[ \t]+/, Text
        rule %r/#.*/, Comment::Single
        rule %r/\/\*(.|\n)*?\*\/*/, Comment::Multiline
      end

      state :punctuation do
        rule %r/[,():\[\]]+/, Punctuation
        rule %r/[&|^<>+*\/~=-]+/, Operator
        rule %r/\$+/, Keyword::Constant
      end
    end
  end
end
