# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers

    # Find the reference for the KickAssembler syntax at
    # https://www.theweb.dk/KickAssembler/KickAssembler.pdf
    class KickAssembler < RegexLexer
      title 'KickAssembler'
      desc 'Kick assembler NMOS 65xx syntax'
      tag 'kick_assembler'
      aliases 'kickass'
      filenames '*.asm'
      mimetypes 'text/x-asm', 'text/x-assembly'

      def self.mnemonics
        @mnemonics ||= Set.new %w(
          lda ldx ldy sta stx sty tax tay txa tya tsx txs pha php pla plp
          and eor ora bit adc sbc cmp cpx cpy inc inx iny dec dex dey asl
          lsr rol ror jmp jsr rts rti bcc bcs beq bmi bne bpl bvc bvs
          clc cld cli clv sec sed sei brk nop
          phx plx phy ply
          stz trb tsb bra
          neg asr dea ina
          ahx alr anc anc2 arr axs dcp isc las lax rla rra sax shx shy slo sre tas xaa
        )
      end

      def self.type_directives
        @type_directives ||= Set.new %w(
          .align .assert .asserterror .break .by .byte .cpu
          .disk .dword .dw .encoding .enum .error .errorif .eval
          .file .fill .fillword .for .function .import .importonce
          .label .lohifill .macro .memblock .modify .namespace
          .pc .print .printnow .pseudocommand .pseudopc .return
          .segment .segmentdef .struct .text .var .word .while .zp
        )
      end

      def self.preprocessor_directives
        @preprocessor_directives ||= Set.new %w(
          define undef import importonce importif
          if endif else elif
          print printnow error asserterror
        )
      end

      state :root do
        rule %r(//.*?$), Comment::Single

        rule %r/"(?:[^"\\]|\\.)*"/, Literal::String
        rule %r/'.'/, Literal::String::Char

        rule %r/\#?\%[0-1]+/, Literal::Number # Binary
        rule %r/\#?\$[0-9a-fA-F]+/, Literal::Number # Hexa
        rule %r/\#?\d+/, Literal::Number # Decimal

        rule %r/[+\-*\/=<>!]/, Operator

        rule %r/#\w+/i do |m|
          directive = m[0][1..-1].downcase
          if self.class.preprocessor_directives.include?(directive)
            token Keyword
          else
            token Punctuation
          end
        end

        rule %r/#/, Punctuation
        rule %r/[(){},]/, Punctuation

        rule %r/[a-z$._?][\w$.?#@~]*:/i, Name::Label

        rule %r/\.\w+/i do |m|
          if m[0] == '.const'
            token Keyword::Constant
          elsif m[0] =~ /^\.(for|while|macro|function|pseudopc|pseudocommand)$/io
            token Keyword::Reserved
          elsif self.class.type_directives.include?(m[0].downcase)
            token Keyword::Declaration
          else
            token Keyword
          end
        end

        rule %r/\b\w+\b/i do |m|
          word = m[0].downcase
          if self.class.mnemonics.include?(word)
            token Keyword
          else
            token Name
          end
        end

        rule %r/[ \t\r\n]+/, Text
      end
    end
  end
end
