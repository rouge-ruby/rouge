# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class NesAsm < RegexLexer
      title "NesAsm"
      desc "Nesasm3 assembly (6502 asm)"
      tag 'NesAsm'
      aliases 'nesasm', 'nes'
      filenames '*.nesasm'

      keywords = %w(
        ADC AND ASL BIT  BRK CMP CPX CPY 
        DEC EOR INC JMP JSR LDA LDX LDY LSR NOP ORA
        ROL ROR RTI RTS SBC STA STX STY 
        TAX TXA DEX INX TAY TYA DEY INY 
        BPL BMI BVC BVS BCC BCS BNE BEQ 
        CLC SEC CLI SEI CLV CLD SED
        TXS TSX PHA PLA PHP PLP
      )

      keywords_type = %w(
          DB DW BYTE WORD 
      )

      keywords_reserved = %w(
        INCBIN INCLUDE ORG BANK RSSET RS
        MACRO ENDM DS PROC ENDP PROCGROUP ENDPROCGROUP
        INCCHR DEFCHR ZP BSS CODE DATA IF IFDEF IFNDEF 
        ELSE ENDIF FAIL INESPRG INESCHR INESMAP INESMIR
      )
      
      state :root do
        rule %r/\s+/m, Text
        rule %r(;.*?$), Comment::Single

        rule %r/\w*\:/, Name::Function #label:
        rule %r/[\(\)\,\.\[\]]/, Punctuation 
        rule %r/\#*\%[0-1]+/, Num::Bin # #%00110011 %00110011
        rule %r/\$\h+/, Num::Hex  # $1f
        rule %r/\#\$\h+/, Num::Hex  #$1f
        rule %r/\#*[0-9]+/, Num # 10 #10
        rule %r([~&*+=\|?:<>/-]), Operator

        rule %r/\b(?:#{keywords.join('|')})\b/i, Keyword
        rule %r/\b(?:#{keywords_type.join('|')})\b/i, Keyword::Type
        rule %r/\b(?:#{keywords_reserved.join('|')})\b/i, Keyword::Reserved
        rule %r/(?:#*LOW|#*HIGH)\(.*\)/i, Keyword::Reserved # LOW() #HIGH()
        
        rule %r/\#\w+/, Name::Function # #LABEL
        rule %r/\#\(/, Punctuation # #()

        rule %r/".*"/, Str # ""
        rule %r/\w*/, Name::Function # other labels/variables/names etc
      end
      
    end
  end
end
