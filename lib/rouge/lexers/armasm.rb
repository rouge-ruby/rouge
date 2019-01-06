# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class ArmAsm < RegexLexer
      title "ArmAsm"
      desc "Arm assembly syntax"
      tag 'armasm'
      filenames '*.s'

      state :root do
        rule /\n/, Text
        rule /[ \t]+/, Text, :command
        rule /;.*\n/, Comment
        rule /\$[A-Za-z_][0-9A-Za-z_]*\.?/, Name::Namespace # variable substitution or macro argument
        rule /([0-9A-Za-z_][0-9A-Za-z_]*|\|[^|\n]+\|)/, Name::Label
        end

      state :command do
        rule /\n/, Text, :root
        rule /[ \t]+/, Text, :args
        rule /;.*\n/, Comment, :root
        rule /(ALIAS|ALIGN|AOF|AOUT|AREA|ARM|ASSERT|ATTR|BIN|CN|CODE16|CODE32|COMMON|CP|DATA|DCB|DCD|DCDO|DCDU|DCFD|DCFDU|DCFH|DCFHU|DCFS|DCFSU|DCI(\.[NW])?|DCQ|DCQU|DCW|DCWU|DN|ELIF|ELSE|END|ENDFUNC|ENDIF|ENDP|ENTRY|EQU|EXPORT|EXPORTAS|EXTERN|FIELD|FILL|FN|FRAME|FUNCTION|GBL[ALS]|GET|GLOBAL|IF|IMPORT|INCBIN|INCLUDE|INFO|KEEP|LCL[ALS]|LEADR|LEAF|LNK|LTORG|MACRO|MAP|MEND|MEXIT|NOFP|OPT|ORG|PRESERVE8|PROC|QN|RELOC|REQUIRE8?|RLIST|RN|ROUT|SET[ALS]|SN|SPACE|STRONG|SUBT|THUMBX?|TTL|WEND|WHILE|\[|\]|[|!#*=%&^])(?=[; \t\n])/, Keyword
        rule /([A-Z][0-9A-Z]*|[a-z][0-9a-z]*)(\.[NWnw])?(\.[DFIPSUdfipsu]?(8|16|32|64)?){,3}(?=[^0-9A-Za-z_])/, Name::Builtin # rather than attempt to list all opcodes, rely on all-uppercase or all-lowercase rule
        rule /([A-Za-z_][0-9A-Za-z_]*|\|[^|\n]+\|)/, Name::Function # probably a macro name
        rule /\$[A-Za-z][0-9A-Za-z_]*\.?/, Name::Namespace
      end

      state :args do
        rule /\n/, Text, :root
        rule /[ \t]+/, Text
        rule /;.*\n/, Comment, :root
        rule /([A-Za-z_][0-9A-Za-z_]*|\|[^|\n]+\|)/, Name::Variable # various types of symbol
        rule /%[BFbf]?[ATat]?[0-9]+([A-Za-z_][0-9A-Za-z_]*)?/, Name::Label
        rule /(&|0[Xx])[0-9A-Fa-f]+(?![0-9A-FPa-fp])/, Literal::Number::Hex
        rule /(&|0[Xx])[.0-9A-Fa-f]+([Pp][-+]?[0-9]+)?/, Literal::Number::Float
        rule /(0[Ff]_[0-9A-Fa-f]{8}|0[Dd]_[0-9A-Fa-f]{16})/, Literal::Number::Float
        rule /(2_[01]+|3_[0-2]+|4_[0-3]+|5_[0-4]+|6_[0-5]+|7_[0-6]+|8_[0-7]+|9_[0-8]+|[0-9]+)(?![0-9Ee])/, Literal::Number::Integer
        rule /(2_[.01]+|3_[.0-2]+|4_[.0-3]+|5_[.0-4]+|6_[.0-5]+|7_[.0-6]+|8_[.0-7]+|9_[.0-8]+|[.0-9]+)([Ee][-+]?[0-9]+)?/, Literal::Number::Float
        rule /[@:](?=[ \t]*(8|16|32|64|128|256)[^0-9])/, Operator
        rule /[.@]|\{(ARCHITECTURE|AREANAME|ARMASM_VERSION|CODESIZE|COMMANDLINE|CONFIG|CPU|ENDIAN|FALSE|FPIC|FPU|INPUTFILE|INTER|LINENUM(UP(PER)?)?|OBJASM_VERSION|OPT|PC|PCSTOREOFFSET|REENTRANT|ROPI|RWPI|TRUE|VAR)\}/, Name::Constant
        rule /([-!#%&()*+,\/<=>?^{|}]|\[|\]|!=|&&|\/=|<<|<=|<>|==|><|>=|>>|\|\||:(AND|BASE|CC|CC_ENCODING|CHR|DEF|EOR|FATTR|FEXEC|FLOAD|FSIZE|INDEX|LAND|LEFT|LEN|LEOR|LNOT|LOR|LOWERCASE|MOD|NOT|OR|RCONST|REVERSE_CC|RIGHT|ROL|ROR|SHL|SHR|STR|TARGET_ARCH_[A-Z_]+|TARGET_FEATURE_[A-Z_]+|TARGET_FPU_[A-Z_]+|TARGET_PROFILE_[ARM]|UAL|UPPERCASE):)/, Operator
        rule /\$[A-Za-z][0-9A-Za-z_]*\.?/, Name::Namespace
        rule /'/, Literal::String::Char, :singlequoted
        rule /"/, Literal::String::Double, :doublequoted
      end

      state :singlequoted do
        rule /\n/, Text, :root
        rule /\$\$/, Literal::String::Char
        rule /\$[A-Za-z][0-9A-Za-z_]*\.?/, Name::Namespace
        rule /'/, Literal::String::Char, :args
        rule /[^$'\n]+/, Literal::String::Char
      end

      state :doublequoted do
        rule /\n/, Text, :root
        rule /\$\$/, Literal::String::Double
        rule /\$[A-Za-z][0-9A-Za-z_]*\.?/, Name::Namespace
        rule /"/, Literal::String::Double, :args
        rule /[^$"\n]+/, Literal::String::Double
      end
    end
  end
end
