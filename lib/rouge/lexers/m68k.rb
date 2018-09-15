# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class M68k < RegexLexer
      tag 'm68k'

      title "M68k"
      desc "Motorola 68k Assembler"
      filenames '*.s','*.i','*.68k','*.m68k'

      includes = /\p{Blank}*(include|incdir|incbin|image)\p{Blank}*/
      strings =  /".*"|'.*'|`.*`/
      word_specialchars_range = %q{[\w\(\)\-#\/\\\\%$\.\|'\"`\*!\+~<]}
 
      def self.detect?(text)
        return true if text =~ /\A.*?\p{Blank}(move(.[bwl])?)\p{Blank}.*/
        return true if text =~ /\A.*?\p{Blank}(d0).*/
      end
      
      opcode = %w(
          abcd add adda addi addq addx and andi asl asr

          bcc bcs beq bge bgt bhi ble bls blt bmi bne bpl bvc bvs bhs blo
          bchg bclr bfchg bfclr bfests bfextu bfffo bfins bfset bftst bkpt bra bse bsr btst

          callm cas cas2 chk chk2 clr cmp cmpa cmpi cmpm cmp2

          dbcc dbcs dbeq dbge dbgt dbhi dble dbls dblt dbmi dbne dbpl dbvc dbvs dbhs dblo
          dbra dbf dbt divs divsl divu divul

          eor eori exg ext extb

          illegal jmp jsr lea link lsl lsr

          move movea move16 movem movep moveq muls mulu

          nbcd neg negx nop not or ori

          pack pea rol ror roxl roxr rtd rtm rtr rts

          sbcd

          seq sne spl smi svc svs st sf sge sgt sle slt scc shi sls scs shs slo
          sub suba subi subq subx swap

          tas trap trapcc TODO trapv tst

          unlk unpk eori
        )


      data_def =
       %w(
          blk 
          bss bss_p bss_c bss_f
          code code_p code_c code_f
          dc ds dcb dr
          data data_p data_c data_f 
          text
        )
      
      def self.registers
        @registers ||=Set.new %w(
          d0 d1 d2 d3 d4 d5 d6 d7
          a0 a1 a2 a3 a4 a5 a6 a7
          pc usp ssp ccr sp
          sfc dfc vbr cacr char
          msp isp crp srp tc tt0 tt1
          mmusr itt0 itt1 dtt0 dtt1
          drp pcsr ac cal val scc psr
          bad0 bad1 bad2 bad3 bad4 bad5 bad6 bad7
          bac0 bac1 bac2 bac3 bac4 bac5 bac6 bac7
          fp0 fp1 fp2 fp3 fp4 fp5 fp6 fp7
          fpcr fpsr fpiar
        )
      end

      def reset_stack
        stack.clear
        stack.push get_state(:root)
      end

      state :root do # the basic flow is label->opcode->operand->comment with a few specialcases 
        rule /^(\p{Blank}+)?\n/, Name #empty line
        rule /^\p{Blank}*(;|\*|`).*\n/, Comment::Single #comment line 
        rule /^(([\.\w]+\$?:?(\p{Blank}*))|(\p{Blank}+))(?=.*\n)/, Name::Label, :opcode #label
      end

      state :opcode do
        
        rule includes, Keyword, :includes
        rule /rts|even|rsreset|endc%\w+(?=\p{Blank}+.*\n|\n)/, Keyword, :comment #special case, opcodes with no operands might have freestyle comments
        rule /\p{Blank}*\n/, Keyword, :pop! #0 or more spaces, ending in newline
        rule /\=\p{Blank}*(?=.*\n)/, Operator, :operand # found a = instead of opcode   
        rule /(?=((#{opcode.join('|')})|(#{data_def.join('|')})|(\w+))(\.[bswl])?(\p{Blank}+)?(?=.*\n))/i, Keyword, :opcodedetail #opcode ie movem, move.l and friends
        rule /\p{Blank}*(?=(;|\*).*\n)/, Keyword, :operand  #no opcode found but comments found

      end

      state :includes do
        rule /.*(?=\n)/, Name::Namespace, :comment
      end


      state :opcodedetail do

        rule /(\w+)(\.[bwsl])?(\p{Blank}+)?(?=.*)/i do
          groups Keyword, Keyword::Type, Keyword
          pop!
          push :operand
        end

      end

      
      state :operand do
        rule /(?=\*-\w+.*)/, Keyword, :operanddetail #*-operand"
        rule /(?=(;|\*).*\n)/, Keyword, :comment #end of line comments
        rule /(?=#{word_specialchars_range}+(,\p{Blank}*#{word_specialchars_range}+)*)/, Keyword::Constant, :operanddetail #the operands field
        rule /(?=\n)/, Keyword, :comment #nothing to see, go to comments
      end

      state :operanddetail do #the tokens in the operands field 

        rule strings do |m|
          thestring = m[0]
          if thestring =~ /\\([\\abfnrtv"']|x[a-fA-F0-9]{2,4}|[0-7]{1,3})/
            token Str::Escape
          else
            token Str
          end
        end

        rule /[#%]/, Name::Decorator
        rule /\$[0-9a-f]+/i, Num::Hex
        rule /@[0-8]+/i, Num::Oct
        rule /%[01]+/i, Num::Bin
        rule /\d+/i, Num::Integer
        rule /[\*~&+=\|?!:<>\/\-]/, Operator
        rule /\\./, Comment::Preproc
        rule /[(){},.]/, Punctuation
        rule /\[[a-zA-Z0-9]*\]/, Punctuation

        rule /\.?[a-zA-Z0-9_]+:?/ do |m| 
         name=m[0] 
          if self.class.registers.include? name.downcase
            token Name::Builtin
          else
            token Name::Label
          end
        
        end

        rule // do 
          push :comment
        end

      end

      state :comment do
        rule /.*\n/ do |m| #everything not consumed before newline is a comment, consume it and restart the flow from :root
          
          token Comment::Single
          reset_stack
        
        end
      end

    end
  end
end
