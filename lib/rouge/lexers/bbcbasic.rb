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
          [,;'~] SPC TAB
        )
      end

      def self.function
        @function ||= %w(
          ABS ACS ADVAL ASC ASN ATN BEATS BEAT BGET# CHR\$ COS COUNT DEG DIM
          EOF# ERL ERR EVAL EXP EXT# GET\$# GET\$ GET HIMEM INKEY\$ INKEY INSTR
          INT LEFT\$ LEN LN LOG LOMEM MID\$ OPENIN OPENOUT OPENUP PAGE POINT POS
          PTR# RAD REPORT\$ RIGHT\$ RND SGN SIN SQR STR\$ STRING\$ SUM SUMLEN
          TAN TEMPO TIME\$ TIME TOP USR VAL VPOS
        )
      end

      def self.control # these must be followed by an expression, if anything
        @control ||= %w(
          CASE CHAIN ENDCASE ENDIF ENDPROC ENDWHILE END FN FOR GOSUB GOTO IF
          INSTALL LIBRARY NEXT OVERLAY PROC RETURN STOP UNTIL WHEN WHILE
        )
      end

      def self.control2 # these can be followed by further imperatives
        @control2 ||= %w(
          ELSE OTHERWISE REPEAT
        )
      end

      def self.control3 # these can come after a statement and expression,
                        # and must be followed by an expression, if anything
        @control3 ||= %w(
          GOSUB GOTO OF ON TINT TO STEP
        )
      end

      def self.control4 # these can come after a statement and expression,
                        # and can be followed by further imperatives
        @control4 ||= %w(
          ELSE THEN
        )
      end

      def self.statement
        @statement ||= %w(
          BEATS BPUT# CALL CLEAR CLG CLOSE# CLS COLOR COLOUR DATA ENVELOPE GCOL
          LET MODE OFF ON ORIGIN OSCI PLOT PRINT# PRINT QUIT READ REPORT SOUND
          STEREO SWAP SYS TINT VDU VOICE VOICES WAIT WIDTH
        )
      end

      def self.operator
        @operator ||= %w(
          << <= <> < >= >>> >> > [-!$()*+/=?^|] AND DIV EOR MOD NOT OR
        )
      end

      def self.constant
        @constant ||= %w(
          FALSE TRUE
        )
      end

      state :expression do
        rule %r/#{BBCBASIC.function.join('|')}/o do
          # function or pseudo-variable
          token Name::Builtin
          goto :no_further_imperatives
        end
        rule %r/#{BBCBASIC.operator.join('|')}/o do
          token Operator
          goto :no_further_imperatives
        end
        rule %r/#{BBCBASIC.constant.join('|')}/o do
          token Name::Constant
          goto :no_further_imperatives
        end
        rule %r/"[^"]*"/o do
          token Literal::String
          goto :no_further_imperatives
        end
        rule %r/[a-z_`][\w`]*[$%]?/io do
          token Name::Variable
          goto :no_further_imperatives
        end
        rule %r/@%/o do
          token Name::Variable
          goto :no_further_imperatives
        end
        rule %r/[\d.]+/o do
          token Literal::Number
          goto :no_further_imperatives
        end
        rule %r/%[01]+/o do
          token Literal::Number::Bin
          goto :no_further_imperatives
        end
        rule %r/&[\h]+/o do
          token Literal::Number::Hex
          goto :no_further_imperatives
        end
      end

      state :no_further_imperatives do
        rule %r/:+/o do
          token Punctuation
          goto :root
        end
        rule %r/\n+/o do
          token Text
          goto :root
        end
        rule %r/ +/o, Text
        rule %r/#{BBCBASIC.control3.join('|')}/o, Keyword
        rule %r/#{BBCBASIC.control4.join('|')}/o do
          token Keyword
          goto :root
        end
        mixin :expression
        rule %r/#{BBCBASIC.punctuation.join('|')}/o, Punctuation
      end

      state :root do
        rule %r/:+/o, Punctuation
        rule %r/[ \n]+/o, Text
        rule %r/[\[]/o, Keyword, :assembly1
        rule %r/(\*)(.*)/o do
          groups Keyword, Text # CLI command
        end
        rule %r/REM *>.*/o, Comment::Special
        rule %r/REM.*/o, Comment
        rule %r/(?:#{BBCBASIC.control.join('|')}|ERROR(?: *EXT)?|ON *ERROR *OFF)/o do
          token Keyword
          goto :no_further_imperatives
        end
        rule %r/(?:#{BBCBASIC.control2.join('|')}|DEF *(?:FN|PROC)|ON *ERROR(?: *LOCAL)?)/o, Keyword
        rule %r/(?:#{BBCBASIC.statement.join('|')}|CIRCLE(?: *FILL)?|DRAW(?: *BY)?|DIM(?!\()|ELLIPSE(?: *FILL)?|FILL(?: *BY)?|INPUT(?:#| *LINE)?|LINE(?: *INPUT)?|LOCAL(?: *DATA| *ERROR)?|MOUSE(?: *COLOUR| *OFF| *ON| *RECTANGLE| *STEP| *TO)?|MOVE(?: *BY)?|POINT(?: *BY)?(?!\()|RECTANGE(?: *FILL)?|RESTORE(?: *DATA| *ERROR)?|TRACE(?: *CLOSE| *ENDPROC| *OFF| *STEP(?: *FN| *ON| *PROC)?| *TO)?)/o do
          token Keyword
          goto :no_further_imperatives
        end
        mixin :expression
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
        rule %r/ +/o, Text
        rule %r/]/o, Keyword, :pop!
        rule %r/[:\n]/o, Punctuation
        rule %r/\.[a-z_`][\w`]*%? */io, Name::Label
        rule %r/(?:REM|;)[^:\n]*/o, Comment
        rule %r/[^ :\n]+/o, Keyword, :assembly2
      end

      state :assembly2 do
        rule %r/ +/o, Text
        rule %r/[:\n]/o, Punctuation, :pop!
        rule %r/(?:REM|;)[^:\n]*/o, Comment, :pop!
        rule %r/#{BBCBASIC.function.join('|')}/o, Name::Builtin # function or pseudo-variable
        rule %r/#{BBCBASIC.operator.join('|')}/o, Operator
        rule %r/#{BBCBASIC.constant.join('|')}/o, Name::Constant
        rule %r/"[^"]*"/o, Literal::String
        rule %r/[a-z_`][\w`]*[$%]?/io, Name::Variable
        rule %r/@%/o, Name::Variable
        rule %r/[\d.]+/o, Literal::Number
        rule %r/%[01]+/o, Literal::Number::Bin
        rule %r/&[\h]+/o, Literal::Number::Hex
        rule %r/[!#,@\[\]^{}]/o, Punctuation
      end
    end
  end
end
