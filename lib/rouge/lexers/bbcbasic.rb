# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class BBCBASIC < RegexLexer
      title "BBCBASIC"
      desc "BBC BASIC syntax"
      tag 'bbcbasic'
      filenames '*,fd1'

      def self.punctuation
        @punctuation ||= %w(
          [:,;'~] SPC TAB
        )
      end

      def self.function
        @function ||= %w(
          ABS ACS ADVAL ASC ASN ATN BEATS BEAT BGET# CHR\$ COS COUNT DEG EOF#
          ERL ERR ERROR EVAL EXP EXT# GET GET\$ GET\$# HIMEM INKEY INKEY\$
          INSTR INT LEFT\$ LEN LN LOG LOMEM MID\$ OPENIN OPENOUT OPENUP PAGE
          POS PTR# RAD REPORT\$ RIGHT\$ RND SGN SIN SQR STR\$ STRING\$ SUM
          SUMLEN TAN TEMPO TIME TIME\$ TOP USR VAL VPOS
        )
      end

      def self.control
        @control ||= %w(
          CASE CHAIN ELSE ENDCASE ENDIF ENDPROC ENDWHILE END FN FOR GOSUB GOTO
          IF INSTALL LIBRARY NEXT OF OTHERWISE OVERLAY PROC REPEAT RETURN STEP
          STOP THEN TO UNTIL WHEN WHILE
        )
      end

      def self.statement
        @statement ||= %w(
          BEATS BPUT# CALL CLEAR CLG CLOSE# CLS COLOR COLOUR DATA DIM ENVELOPE
          GCOL LET MODE OFF ON ORIGIN OSCI PLOT PRINT PRINT# QUIT READ REPORT
          SOUND STEREO SWAP SYS TINT VDU VOICE VOICES WAIT WIDTH
        )
      end

      def self.operator
        @operator ||= %w(
          << <= <> < >= >>> >> > [-!\$()*+\/=?^|] AND DIV EOR MOD NOT OR
        )
      end

      def self.constant
        @constant ||= %w(
          FALSE TRUE
        )
      end

      state :root do
        rule %r/[ \n]+/, Text
        rule %r/[\[]/, Keyword, :assembly1
        rule %r/(\*)(.*)/ do
          groups Generic::Prompt, Text # CLI command
        end
        rule %r/REM *>.*/, Comment::Special
        rule %r/REM.*/, Comment
        rule %r/#{BBCBASIC.punctuation.join('|')}/, Punctuation
        rule %r/#{BBCBASIC.function.join('|')}/, Name::Builtin # function or pseudo-variable
        rule %r/(?:DIM|POINT)(?=\()/, Name::Builtin # function sharing keyword with statement, distinguished by ()
        rule %r/(?:#{BBCBASIC.function.join('|')}|DEF *(?:FN|PROC)|ERROR(?: *EXT)?|ON(?: *ERROR *OFF| *ERROR *LOCAL| *ERROR))/, Keyword # control flow statement
        rule %r/(?:#{BBCBASIC.statement.join('|')}|CIRCLE(?: *FILL)?|DRAW(?: *BY)?|ELLIPSE(?: *FILL)?|FILL(?: *BY)?|INPUT(?:#| *LINE)?|LINE(?: *INPUT)?|LOCAL(?: *DATA| *ERROR)?|MOUSE(?: *COLOUR| *OFF| *ON| *RECTANGLE| *STEP| *TO)?|MOVE(?: *BY)?|POINT(?: *BY)?|RECTANGE(?: *FILL)?|RESTORE(?: *DATA| *ERROR)?|TRACE(?: *CLOSE| *ENDPROC| *OFF| *STEP(?: *FN| *ON| *PROC)?| *TO)?)/, Keyword # other statement
        rule %r/#{BBCBASIC.operator.join('|')}/, Operator
        rule %r/#{BBCBASIC.constant.join('|')}/, Name::Constant
        rule %r/"[^"]*"/, Literal::String
        rule %r/[a-z_`][\w`]*[\$%]?/i, Name::Variable
        rule %r/@%/, Name::Variable
        rule %r/[\d.]+/, Literal::Number
        rule %r/%[01]+/, Literal::Number # binary
        rule %r/&[\h]+/, Literal::Number::Hex
      end

      # Assembly statements are parsed as
      # {label} {directive|opcode |']' {expressions}} {comment}
      # Technically, you don't need whitespace between opcodes and arguments,
      # but this is rare in uncrunched source and trying to enumerate all
      # possible opcodes here is impractical so we colour it as though
      # the whitespace is required. Opcodes and directives can only easily be
      # distinguished from the symbols that make up expressions by looking at
      # their position within the statement. Similarly, ']' is treated as a
      # keyword at the start of a statement or as punctuation elsewhere. This
      # requires a two-state state machine.

      state :assembly1 do
        rule %r/ +/, Text
        rule %r/]/, Keyword, :pop!
        rule %r/[:\n]/, Punctuation
        rule %r/\.[a-z_`][\w`]*%? */i, Name::Label
        rule %r/(?:REM|;)[^:\n]*/, Comment
        rule %r/[^ :\n]+/, Keyword, :assembly2
      end

      state :assembly2 do
        rule %r/ +/, Text
        rule %r/[:\n]/, Punctuation, :pop!
        rule %r/(?:REM|;)[^:\n]*/, Comment, :pop!
        rule %r/#{BBCBASIC.function.join('|')}/, Name::Builtin # function or pseudo-variable
        rule %r/(?:DIM|POINT)(?=\()/, Name::Builtin # function sharing keyword with statement, distinguished by ()
        rule %r/#{BBCBASIC.operator.join('|')}/, Operator
        rule %r/#{BBCBASIC.constant.join('|')}/, Name::Constant
        rule %r/"[^"]*"/, Literal::String
        rule %r/[a-z_`][\w`]*[\$%]?/i, Name::Variable
        rule %r/@%/, Name::Variable
        rule %r/[\d.]+/, Literal::Number
        rule %r/%[01]+/, Literal::Number # binary
        rule %r/&[\h]+/, Literal::Number::Hex
        rule %r/[!#,@\[\]^{}]/, Punctuation
      end
    end
  end
end
