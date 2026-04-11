# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class ArmAsm < RegexLexer
      title "ArmAsm"
      desc "Arm assembly syntax"
      tag 'armasm'
      filenames '*.s'

      def self.file_directive
        @file_directive ||= Set.new %w(
          bin get incbin include lnk
        )
      end

      def self.general_directive
        @general_directive ||= Set.new %w(
          alias align aof aout area arm assert attr cn code16 code32 common cp
          data dcb dcd dcdo dcdu dcfd dcfdu dcfh dcfhu dcfs dcfsu dci dci.n dci.w
          dcq dcqu dcw dcwu dn elif else end endfunc endif endp entry equ export
          exportas extern field fill fn frame function gbla gbll gbls global if
          import info keep lcla lcll lcls leadr leaf ltorg macro map mend mexit
          nofp opt org preserve8 proc qn reloc require require8 rlist rn rout
          seta setl sets sn space strong subt thumb thumbx ttl wend while
        )
      end

      def self.shift_or_condition
        @shift_or_condition ||= Set.new %w(
          ASR LSL LSR ROR RRX AL CC CS EQ GE GT HI HS LE LO LS LT MI NE PL VC VS
          asr lsl lsr ror rrx al cc cs eq ge gt hi hs le lo ls lt mi ne pl vc vs
        )
      end

      def self.builtin
        @builtin ||= Set.new %w(
          ARCHITECTURE AREANAME ARMASM_VERSION CODESIZE COMMANDLINE CONFIG CPU
          ENDIAN FALSE FPIC FPU INPUTFILE INTER LINENUM LINENUMUP LINENUMUPPER
          OBJASM_VERSION OPT PC PCSTOREOFFSET REENTRANT ROPI RWPI TRUE VAR
        )
      end

      def self.operator
        @operator ||= Set.new %w(
          AND BASE CC CC_ENCODING CHR DEF EOR FATTR FEXEC FLOAD FSIZE INDEX LAND
          LEFT LEN LEOR LNOT LOR LOWERCASE MOD NOT OR RCONST REVERSE_CC RIGHT ROL
          ROR SHL SHR STR UAL UPPERCASE
        )
      end

      state :root do
        rule %r/\n/, Text
        rule %r/^([ \t]*)(#[ \t]*(?:\w+(?:[ \t].*)?)?)(\n)/ do
          groups Text, Comment::Preproc, Text
        end
        rule %r/[ \t]+/, Text, :command
        rule %r/;.*/, Comment
        rule %r/\$[a-z_]\w*\.?/i, Name::Namespace # variable substitution or macro argument
        rule %r/\w+|\|[^|\n]+\|/, Name::Label
      end

      state :command do
        rule %r/\n/, Text, :pop!
        rule %r/[ \t]+/ do |m|
          token Text
          goto :args
        end
        rule %r/;.*/, Comment, :pop!

        rule %r/[\[\]|!#*=%&^](?=[; \t\n])/, Keyword

        keywords %r/\w+/ do
          transform(&:downcase)
          rule(:file_directive) { token Keyword; goto :filespec }
          rule :general_directive, Keyword
        end

        rule %r/(?:[A-Z][\dA-Z]*|[a-z][\da-z]*)(?:\.[NWnw])?(?:\.[DFIPSUdfipsu]?(?:8|16|32|64)?){,3}\b/, Name::Builtin # rather than attempt to list all opcodes, rely on all-uppercase or all-lowercase rule
        rule %r/[a-z_]\w*|\|[^|\n]+\|/i, Name::Function # probably a macro name
        rule %r/\$[a-z]\w*\.?/i, Name::Namespace
      end

      state :args do
        rule %r/\n/, Text, :pop!
        rule %r/[ \t]+/, Text
        rule %r/;.*/, Comment, :pop!

        keywords %r/\w+/ do
          rule :shift_or_condition, Name::Builtin
        end

        rule %r/[a-z_]\w*|\|[^|\n]+\|/i, Name::Variable # various types of symbol
        rule %r/%[bf]?[at]?\d+(?:[a-z_]\w*)?/i, Name::Label
        rule %r/(?:&|0x)\h+(?!p)/i, Literal::Number::Hex
        rule %r/(?:&|0x)[.\h]+(?:p[-+]?\d+)?/i, Literal::Number::Float
        rule %r/0f_\h{8}|0d_\h{16}/i, Literal::Number::Float
        rule %r/(?:2_[01]+|3_[0-2]+|4_[0-3]+|5_[0-4]+|6_[0-5]+|7_[0-6]+|8_[0-7]+|9_[0-8]+|\d+)(?!e)/i, Literal::Number::Integer
        rule %r/(?:2_[.01]+|3_[.0-2]+|4_[.0-3]+|5_[.0-4]+|6_[.0-5]+|7_[.0-6]+|8_[.0-7]+|9_[.0-8]+|[.\d]+)(?:e[-+]?\d+)?/i, Literal::Number::Float
        rule %r/[@:](?=[ \t]*(?:8|16|32|64|128|256)[^\d])/, Operator
        rule %r/[.@]/, Name::Constant

        keywords %r/[{]([A-Z_]+)[}]/ do
          group 1
          rule :builtin, Name::Constant
        end

        rule %r/[-!#%&()*+,\/<=>?^{|}]|\[|\]|!=|&&|\/=|<<|<=|<>|==|><|>=|>>|\|\|/, Operator

        rule %r/:TARGET_(?:ARCH|FEATURE)_[0-9A-Z_]+:/, Operator
        rule %r/:TARGET_FPU_[A-Z_]:/, Operator
        rule %r/:TARGET_PROFILE_[ARM]:/, Operator

        keywords %r/:([A-Z_]+):/ do
          group 1
          rule :operator, Operator
        end

        rule %r/\$[a-z]\w*\.?/i, Name::Namespace

        rule %r/'/ do |m|
          token Literal::String::Char
          goto :singlequoted
        end

        rule %r/"/ do |m|
          token Literal::String::Double
          goto :doublequoted
        end
      end

      state :singlequoted do
        rule %r/\n/, Text, :pop!
        rule %r/\$\$/, Literal::String::Char
        rule %r/\$[a-z]\w*\.?/i, Name::Namespace
        rule %r/'/ do |m|
          token Literal::String::Char
          goto :args
        end
        rule %r/[^$'\n]+/, Literal::String::Char
      end

      state :doublequoted do
        rule %r/\n/, Text, :pop!
        rule %r/\$\$/, Literal::String::Double
        rule %r/\$[a-z]\w*\.?/i, Name::Namespace
        rule %r/"/ do |m|
          token Literal::String::Double
          goto :args
        end
        rule %r/[^$"\n]+/, Literal::String::Double
      end

      state :filespec do
        rule %r/\n/, Text, :pop!
        rule %r/\$\$/, Literal::String::Other
        rule %r/\$[a-z]\w*\.?/i, Name::Namespace
        rule %r/[^$\n]+/, Literal::String::Other
      end
    end
  end
end
