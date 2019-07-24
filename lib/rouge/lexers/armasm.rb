# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class ArmAsm < RegexLexer
      title "ArmAsm"
      desc "Arm assembly syntax"
      tag 'armasm'
      filenames '*.s'

      def self.preproc_keyword
        @preproc_keyword ||= %w(
          define elif else endif error if ifdef ifndef include line pragma undef warning
        )
      end

      def self.file_directive
        @file_directive ||= %w(
          BIN GET INCBIN INCLUDE LNK
        )
      end

      def self.general_directive
        @general_directive ||= %w(
          ALIAS ALIGN AOF AOUT AREA ARM ASSERT ATTR CN CODE16 CODE32 COMMON CP
          DATA DCB DCD DCDO DCDU DCFD DCFDU DCFH DCFHU DCFS DCFSU DCI DCI.N DCI.W
          DCQ DCQU DCW DCWU DN ELIF ELSE END ENDFUNC ENDIF ENDP ENTRY EQU EXPORT
          EXPORTAS EXTERN FIELD FILL FN FRAME FUNCTION GBLA GBLL GBLS GLOBAL IF
          IMPORT INFO KEEP LCLA LCLL LCLS LEADR LEAF LTORG MACRO MAP MEND MEXIT
          NOFP OPT ORG PRESERVE8 PROC QN RELOC REQUIRE REQUIRE8 RLIST RN ROUT
          SETA SETL SETS SN SPACE STRONG SUBT THUMB THUMBX TTL WEND WHILE
          \[ \] [|!#*=%&^]
        )
      end

      def self.shift_or_condition
        @shift_or_condition ||= %w(
          ASR LSL LSR ROR RRX AL CC CS EQ GE GT HI HS LE LO LS LT MI NE PL VC VS
          asr lsl lsr ror rrx al cc cs eq ge gt hi hs le lo ls lt mi ne pl vc vs
        )
      end

      def self.builtin
        @builtin ||= %w(
          ARCHITECTURE AREANAME ARMASM_VERSION CODESIZE COMMANDLINE CONFIG CPU
          ENDIAN FALSE FPIC FPU INPUTFILE INTER LINENUM LINENUMUP LINENUMUPPER
          OBJASM_VERSION OPT PC PCSTOREOFFSET REENTRANT ROPI RWPI TRUE VAR
        )
      end

      def self.operator
        @operator ||= %w(
          AND BASE CC CC_ENCODING CHR DEF EOR FATTR FEXEC FLOAD FSIZE INDEX LAND
          LEFT LEN LEOR LNOT LOR LOWERCASE MOD NOT OR RCONST REVERSE_CC RIGHT ROL
          ROR SHL SHR STR TARGET_ARCH_[0-9A-Z_]+ TARGET_FEATURE_[0-9A-Z_]+
          TARGET_FPU_[A-Z_] TARGET_PROFILE_[ARM] UAL UPPERCASE
        )
      end

      state :root do
        rule %r/\n/, Text
        rule %r/^[ \t]*#[ \t]*((#{ArmAsm.preproc_keyword.join('|')})[ \t].*)?\n/, Comment::Preproc
        rule %r/[ \t]+/, Text, :command
        rule %r/;.*\n/, Comment
        rule %r/\$[A-Za-z_][0-9A-Za-z_]*\.?/, Name::Namespace, :afterlabel # variable substitution or macro argument
        rule %r/([0-9A-Za-z_][0-9A-Za-z_]*|\|[^|\n]+\|)/, Name::Label, :afterlabel
      end

      state :afterlabel do
        rule %r/\n/,  Text, :pop!
        rule %r/[ \t]+/ do |m|
          token Text
          goto :command
        end
        rule %r/;.*\n/, Comment, :pop!
      end

      state :command do
        rule %r/\n/, Text, :pop!
        rule %r/[ \t]+/ do |m|
          token Text
          goto :args
        end
        rule %r/;.*\n/, Comment, :pop!
        rule %r/(#{ArmAsm.file_directive.join('|')})(?=[ \t])/ do |m|
          token Keyword
          goto :filespec
        end
        rule %r/(#{ArmAsm.general_directive.join('|')})(?=[; \t\n])/, Keyword
        rule %r/([A-Z][0-9A-Z]*|[a-z][0-9a-z]*)(\.[NWnw])?(\.[DFIPSUdfipsu]?(8|16|32|64)?){,3}(?=[^0-9A-Za-z_])/, Name::Builtin # rather than attempt to list all opcodes, rely on all-uppercase or all-lowercase rule
        rule %r/([A-Za-z_][0-9A-Za-z_]*|\|[^|\n]+\|)/, Name::Function # probably a macro name
        rule %r/\$[A-Za-z][0-9A-Za-z_]*\.?/, Name::Namespace
      end

      state :args do
        rule %r/\n/, Text, :pop!
        rule %r/[ \t]+/, Text
        rule %r/;.*\n/, Comment, :pop!
        rule %r/(?<![0-9A-Za-z_])(#{ArmAsm.shift_or_condition.join('|')})(?![0-9A-Za-z_])/, Name::Builtin
        rule %r/([A-Za-z_][0-9A-Za-z_]*|\|[^|\n]+\|)/, Name::Variable # various types of symbol
        rule %r/%[BFbf]?[ATat]?[0-9]+([A-Za-z_][0-9A-Za-z_]*)?/, Name::Label
        rule %r/(&|0[Xx])[0-9A-Fa-f]+(?![0-9A-FPa-fp])/, Literal::Number::Hex
        rule %r/(&|0[Xx])[.0-9A-Fa-f]+([Pp][-+]?[0-9]+)?/, Literal::Number::Float
        rule %r/(0[Ff]_[0-9A-Fa-f]{8}|0[Dd]_[0-9A-Fa-f]{16})/, Literal::Number::Float
        rule %r/(2_[01]+|3_[0-2]+|4_[0-3]+|5_[0-4]+|6_[0-5]+|7_[0-6]+|8_[0-7]+|9_[0-8]+|[0-9]+)(?![0-9Ee])/, Literal::Number::Integer
        rule %r/(2_[.01]+|3_[.0-2]+|4_[.0-3]+|5_[.0-4]+|6_[.0-5]+|7_[.0-6]+|8_[.0-7]+|9_[.0-8]+|[.0-9]+)([Ee][-+]?[0-9]+)?/, Literal::Number::Float
        rule %r/[@:](?=[ \t]*(8|16|32|64|128|256)[^0-9])/, Operator
        rule %r/[.@]|\{(#{ArmAsm.builtin.join('|')})\}/, Name::Constant
        rule %r/([-!#%&()*+,\/<=>?^{|}]|\[|\]|!=|&&|\/=|<<|<=|<>|==|><|>=|>>|\|\||:(#{ArmAsm.operator.join('|')}):)/, Operator
        rule %r/\$[A-Za-z][0-9A-Za-z_]*\.?/, Name::Namespace
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
        rule %r/\$[A-Za-z][0-9A-Za-z_]*\.?/, Name::Namespace
        rule %r/'/ do |m|
          token Literal::String::Char
          goto :args
        end
        rule %r/[^$'\n]+/, Literal::String::Char
      end

      state :doublequoted do
        rule %r/\n/, Text, :pop!
        rule %r/\$\$/, Literal::String::Double
        rule %r/\$[A-Za-z][0-9A-Za-z_]*\.?/, Name::Namespace
        rule %r/"/ do |m|
          token Literal::String::Double
          goto :args
        end
        rule %r/[^$"\n]+/, Literal::String::Double
      end

      state :filespec do
        rule %r/\n/, Text, :pop!
        rule %r/\$\$/, Literal::String::Other
        rule %r/\$[A-Za-z][0-9A-Za-z_]*\.?/, Name::Namespace
        rule %r/[^$\n]+/, Literal::String::Other
      end
    end
  end
end
