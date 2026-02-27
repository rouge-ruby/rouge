
# -*- coding: utf-8 -*- #
# frozen_string_literal: true
#
# Author: Luis Ariel Vega Soliz (vluisariel@aol.com)

module Rouge
  module Lexers
    class I4GL < RegexLexer
      title "4GL"
      desc "Informix-4GL is a 4GL programming language developed by Informix during the mid-1980s."
      tag '4gl'
      filenames '*.4gl'
      mimetypes 'text/plain'

      def self.keywords
        @keywords ||= Set.new %w(
          ABORT ABSOLUTE ACCEPT ACCESS ADA AFTER ALLOCATE ANSI APPEND ASCENDING ASCII
          AT ATTACH ATTRIBUTES AUDIT AUTHORIZATION AUTO AUTONEXT AVERAGE
          BEFORE BORDER BOTH BOTTOM BREAK BUFFERED CASCADE CATCH
          CIRCUIT CLASS_ORIGIN CLEAR CLIPPED CLOSE CLUSTER COBOL COLOR COLUMNS
          COMMENT COMMENTS COMMIT COMMITTED COMPOSITES COMPRESS CONCURRENT CONNECT
          CONNECTION CONNECTION_ALIAS CONSTANT CONSTRAINED CONSTRAINTS CONSTRUCT CONTINUE
          CURRENT CURSOR DATA DATASKIP DAY DBA DBSERVERNAME DEALLOCATE DEBUG
          DECLARE DEFAULTS DEFERRED DELIMITER DELIMITERS DESCENDING DESCRIBE
          DESCRIPTOR DETACH DIAGNOSTICS DIALOG DIRTY DISABLED DISCONNECT
          DISTRIBUTIONS DORMANT DOWN DOWNSHIFT DYNAMIC ENABLED ENTRY EVERY EXCEPTION
          EXCLUSIVE EXECUTE EXP EXPLAIN EXPRESSION EXTEND EXTENT EXTERN EXTERNAL
          FGL FIELD FIELD_TOUCHED FILE FILLFACTOR FILTERING FINISH FIRST FLUSH FORM
          FORMAT FORMONLY FORTRAN FOUND FRACTION FRAGMENT FREE GLOBAL GO GOTO GRANT
          HEADER HELP HIDE HIGH HOLD HOUR IDATA ILENGTH IMMEDIATE IMPORT INCLUDE
          INDEXES INDICATOR INFIELD INIT INITIALIZE INPUT INSTRUCTIONS
          ISAM ISOLATION ITYPE LABEL LANGUAGE LEADING LET LINE LINENO LINES LOAD
          LOCATE LOCK LONG LOW MARGIN MATCHES MEDIUM MEMORY MESSAGE MESSAGE_LENGTH
          MESSAGE_TEXT MINUTE MODE MODIFY MODULE MONTH MORE NAME NEED NEW NEXT NEXTPAGE
          NO NOCR NOENTRY NONE OF OFF OLD ON ONLY OPEN OPTIMIZATION OPTION
          OPTIONS OUTPUT PAGE PAGENO PASCAL PAUSE PDQPRIORITY PICTURE PIPE PLI PRECISION
          PREPARE PREVIOUS PREVPAGE PRINT PRINTER PRIOR PRIVATE PRIVILEGES PROGRAM
          PUBLIC PUT QUIT_FLAG RAISE RANGE READ READONLY RECOVER RED REFERENCES
          REFERENCING REGISTER RELATIVE REMAINDER REMOVE RENAME REOPTIMIZATION REPEATABLE
          REPORT REQUIRED RESOLUTION RESOURCE RESTRICT RESUME RETURNS RETURNED_SQLSTATE
          REVOKE ROBIN ROLLFORWARD ROW ROWID ROWIDS ROWS ROW_COUNT RUN SCALE
          SCHEMA SCREEN SCROLL SCR_LINE SECOND SECTION SERIALIZABLE SERVER_NAME SESSION
          SET_COUNT SHARE SHORT SHOW SITENAME SIZE SIZEOF SKIP SOME SPACE SPACES
          SQL STABILITY START STATIC STATISTICS STDEV STEP STOP STRING STRUCT SUBCLASS_ORIGIN
          SWITCH SYNONYM SYSTEM SYSBLOBS SYSCHECKS SYSCOLAUTH SYSCOLDEPEND SYSCOLUMNS
          SYSCONSTRAINTS SYSDEFAULTS SYSDEPEND SYSDISTRIB SYSFRAGAUTH SYSFRAGMENTS
          SYSINDEXES SYSOBJSTATE SYSOPCLSTR SYSPROCAUTH SYSPROCBODY SYSPROCPLAN SYSPROCEDURES
          SYSREFERENCES SYSROLEAUTH SYSSYNTABLE SYSSYNONYMS SYSTABAUTH SYSTABLES SYSTRIGBODY
          SYSTRIGGERS SYSUSERS SYSVIEWS SYSVIOLATIONS TAB TABLES TEMP THROUGH THRU
          TODAY TOTAL TRACE TRAILER TRAILING TRANSACTION TRIGGER TRIGGERS
          TRY TYPE TYPEDEF UNCOMMITTED UNCONSTRAINED UNITS UNLOAD UNLOCK
          UNSIGNED UP UPSHIFT USER USING VALIDATE VALUE VARIABLES VARIANCE VARYING
          VERIFY VIOLATIONS WAIT WAITING WARNING WEEKDAY WINDOW WITH
          WITHOUT WORDWRAP WRITE YEAR ZEROFILL
          BY DELETE KEY INSERT
        )
      end

      def self.keywords_sql
        @keywords_sql ||= Set.new %w(
          ADD ALTER ALL AND ANY AS ASC BACKUP BEGIN BETWEEN CASE CHECK COLUMN CONSTRAINT
          CREATE DATABASE DEFAULT DESC DISTINCT DROP EXEC EXISTS FOREIGN
          FROM FULL GROUP HAVING IN INDEX INNER INTO IS LEFT LIKE LIMIT JOIN
          NOT NULLABLE OR ORDER OUTER PRIMARY PROCEDURE REPLACE ROLE ROLLBACK
          ROWNUM RIGHT SELECT SET TABLE TOP TRUNCATE UNION UNIQUE UPDATE VALUES VIEW
          WHERE WORK
        )
      end

      def self.keywords_type
        @keywords_type ||= Set.new %w(
          ARRAY BOOLEAN BYTE CHAR CHARACTER DATE DATETIME DEC DECIMAL DOUBLE FLOAT
          INT INTEGER INTERVAL MONEY NCHAR NUMBER NUMERIC NVARCHAR REAL RECORD SERIAL
          SMALLFLOAT SMALLINT TEXT TIME VARCHAR
        )
      end

      def self.keywords_constants
        @keywords_constants ||= Set.new %w(
          BLACK BLINK BLUE BOLD CONTROL CYAN DIM ESC ESCAPE FALSE F1 F10 F11 F12
          F13 F14 F15 F16 F17 F18 F19 F2 F20 F21 F22 F23 F24 F25 F26 F27 F28 F29 F3 F30 F31
          F32 F33 F34 F35 F36 F37 F38 F39 F4 F40 F41 F42 F43 F44 F45 F46 F47 F48 F49 F5 F50
          F51 F52 F53 F54 F55 F56 F57 F58 F59 F6 F60 F61 F62 F63 F64 F7 F8 F9 GREEN
          INTERRUPT INVISIBLE NORMAL LAST MAGENTA NOTFOUND NULL QUIT REVERSE SQLERROR SQLNOTFOUND
          SQLWARNING TRUE UNDERLINE WHITE WRAP YELLOW
        )
      end

      def self.keywords_reserved
        @keywords_reserved ||= Set.new %w(
          DO EACH ELIF ELSE END EXIT FETCH FOR FOREACH FUNCTION GLOBALS
          INTO IF MAIN MENU OTHERWISE RETURN THEN WHEN WHILE
        )
      end

      def self.name_builtin
        @name_builtin ||= Set.new %w(
          ATTRIBUTE CALL COMMAND DEFER DISPLAY ERROR PROMPT RETURNING SLEEP TO WHENEVER
        )
      end

      def self.variable_global
        @variable_global ||= Set.new %w(
          INT_FLAG SQLCA SQLCODE SQLERRD SQLERRM SQLERRP SQLWARN SQLWARN0 SQLWARN1 SQLWARN2
          SQLWARN3 SQLWARN4 SQLWARN5 SQLWARN6 SQLWARN7 SQLSTATE STATUS
        )
      end

      def self.function_builtin
        @function_builtin ||= Set.new %w(
          ABS ACOS ARG_VAL ARR_COUNT ARR_CURR ASIN ATAN ATAN2 AVG CARDINALITY CEIL
          CHARACTER_LENGTH CHAR_LENGTH COS COUNT DBINFO ERRORLOG ERR_GET ERR_PRINT ERR_QUIT FGL_DRAWBOX
          FGL_DYNARR_EXTENTSIZE FGL_GETENV FGL_GETKEY FGL_KEYVAL FGL_LASTKEY
          FGL_ISDYNARR_ALLOCATED FGL_SCR_SIZE FGL_SETCURRLINE FLOOR GET_FLDBUF GETLENGTH
          GREATEST HEX LEAST LENGTH LOG LOG10 LOGN MAX MDY MIN MOD NUM_ARGS OCTET_LENGTH
          ORD PERCENT POW ROOT ROUND SQRT SHOWHELP STARTLOG SUM TAN TRIM TRUNC
        )
      end

      state :root do
        rule /\s+/m, Text
        mixin :comments
        rule /\-?\d+\.\d+/, Num::Float
        rule /\-?\d+/, Num::Integer
        rule /'.'/, Str::Char
        rule /"."/, Str::Char
        mixin :strings

        rule /DEFINE/i, Keyword::Declaration

        rule /CONTROL-[A-Z]/i, Keyword::Constant
        rule /CLEAR\s+FORM/i, Name::Builtin
        rule /(DISPLAY\s+FORM)(\s+)(\w+)/m do
          groups Name::Builtin, Text, Name
        end
        rule /WHENEVER/i, Name::Builtin, :whenever_condition
        rule /OPTIONS/i, Name::Builtin, :options
        rule /PROMPT/i, Name::Builtin, :prompt
        rule /DEFER/i, Name::Builtin, :defer
        rule /OPEN\s+FORM/i, Name::Builtin, :open_form
        rule /(OPEN\s+WINDOW)(\s+)([a-zA-Z_]\w*)(\s+)(AT)(\s+)(\d+)(\s*)(,)(\s*)(\d+)/i do |m|
          groups Name::Builtin, Text, Name, Text, Name::Builtin, Text, Num::Integer, Text, Punctuation, Text, Num::Integer
          push :open_window
        end
        rule /OPEN\s+WINDOW|EXIT\s+MENU|CLOSE\s+WINDOW|CLOSE\s+FORM|CLEAR\s+SCREEN|DISPLAY\s+BY\s+NAME/i, Name::Builtin

        rule /DELETE\s+FROM|PRIMARY\s+KEY|FOREIGN\s+KEY|INSERT\s+INTO|NOT\s+IN|GROUP\s+BY|ORDER\s+BY/i, Keyword::Pseudo

        rule /([a-zA-Z_]\w*)(\()/ do |m| #is a function or array!
          puts "matches: #{[m[0], m[1], m[2]].inspect}" if @debug
          if self.class.variable_global.include? m[1].upcase
            groups Name::Variable::Global, Punctuation
          elsif self.class.keywords.include? m[1].upcase
            groups Keyword, Punctuation
          elsif self.class.keywords_type.include? m[1].upcase
            groups Keyword::Type, Punctuation
          elsif self.class.keywords_reserved.include? m[1].upcase
            groups Keyword::Reserved, Punctuation
          elsif self.class.keywords_constants.include? m[1].upcase
            groups Keyword::Constant, Punctuation
          elsif self.class.name_builtin.include? m[1].upcase
            groups Name::Builtin, Punctuation
          elsif self.class.keywords_sql.include? m[1].upcase
            groups Keyword::Pseudo, Punctuation
          elsif self.class.function_builtin.include? m[1].upcase
            groups Name::Function, Punctuation
            push :args
          else
            groups Name::Function, Punctuation
            push :args
          end
        end
        mixin :identifier
        rule %r([+*/<>=~!@#%^&|?^-]), Operator
        rule /[;:()\[\],.]/, Punctuation
      end

      state :identifier do
        rule /\w[\w]*/ do |m|
          if self.class.variable_global.include? m[0].upcase
            token Name::Variable::Global
          elsif self.class.keywords.include? m[0].upcase
            token Keyword
          elsif self.class.keywords_type.include? m[0].upcase
            token Keyword::Type
          elsif self.class.keywords_reserved.include? m[0].upcase
            token Keyword::Reserved
          elsif self.class.keywords_constants.include? m[0].upcase
            token Keyword::Constant
          elsif self.class.name_builtin.include? m[0].upcase
            token Name::Builtin
          elsif self.class.keywords_sql.include? m[0].upcase
            token Keyword::Pseudo
          elsif self.class.function_builtin.include? m[0].upcase
            token Name::Function
          else
            token Name
          end
        end
      end

      state :strings do
        rule /'/, Str::Single, :single_string
        rule /"/, Str::Double, :double_string
      end

      state :comments do
        rule /--.*|#.*/, Comment::Single
        rule %r(\{.*?\})m, Comment::Multiline
      end

      state :args do
        rule /\s+/, Text
        rule /([a-zA-Z_]\w*)/ , Name::Variable
        rule /,/, Punctuation

        rule(//) { pop! }
      end

      state :whenever_condition do
        rule /\s+/, Text
        rule /ERROR|ANY|NOT\s+FOUND|SQLERROR|SQLWARNING|WARNING/i, Name::Builtin, :whenever_action

        rule(//) { pop! }
      end

      state :whenever_action do
        rule /\s+/, Text
        rule /CONTINUE/i, Name::Builtin, :pop!
        rule /(GOTO)(\s+)([a-zA-Z_]\w*)/i do |m|
          groups Name::Builtin, Text, Name::Label
          pop!
        end
        rule /(GO\s+TO)(\s+)([a-zA-Z_]\w*)/i do |m|
          groups Name::Builtin, Text, Name::Label
          pop!
        end
        rule /STOP/i, Name::Builtin, :pop!
        rule /(CALL)(\s+)([a-zA-Z_]\w*)/ do |m| #is a function!
        groups Name::Builtin, Text, Name::Function
        pop!
        end

        rule //, Error, :pop!
      end

      state :options do
        rule /\s+/, Text
        mixin :comments
        mixin :line_options
        mixin :key_options
        mixin :help_file_options
        mixin :display_options
        mixin :input_options
        rule /,/, Punctuation

        rule(//) { pop! }
      end

      state :line_options do
        rule /(COMMENT|ERROR|FORM|MENU|MESSAGE|PROMPT)(\s+)(LINE)(\s?)(FIRST|LAST|)(\s?)([+|-]?)(\s?)(\d*)/i do |m|
          groups Name::Builtin, Text, Name::Builtin, Text, Keyword::Constant, Text, Operator, Text, Num::Integer
        end
      end

      state :key_options do
        rule /(ACCEPT|DELETE|INSERT|NEXT|PREVIOUS|HELP)(\s+)(KEY)(\s+)(\w[\w]*)/i do |m|
          groups Name::Builtin, Text, Name::Builtin, Text, Keyword::Constant
        end
      end

      state :help_file_options do
        rule /(HELP)(\s+)(FILE)(\s+)('.*?'|".*?")/i do |m|
          groups Name::Builtin, Text, Name::Builtin, Text, Str
          push :strings
        end
      end

      state :display_options do
        rule /(DISPLAY)/, Name::Builtin, :display_attributes
      end

      state :input_options do
        rule /(INPUT)(\s+)(WRAP|NO\s+WRAP)/i do |m|
          groups Name::Builtin, Text, Keyword::Constant
        end
        rule /(INPUT)/, Name::Builtin, :display_attributes
      end

      state :display_attributes do
        rule /\s+/, Text
        rule /(ATTRIBUTE)(\s*)(\()/i do |m|
          groups Name::Builtin, Text, Punctuation
          push :display_attribute_value
        end

        rule /,/, Punctuation
        rule /(\))/, Punctuation, :pop!
      end

      state :display_attribute_value do
        mixin :colors
        rule /(BOLD|DIM|INVISIBLE|NORMAL)/i, Keyword::Constant
        rule /(FORM|WINDOW)/i, Name::Builtin
        rule /(,)(\s*)(BLINK|REVERSE|UNDERLINE)/i do |m|
          groups Punctuation, Text, Keyword::Constant
        end

        rule(//) { pop! }
      end

      state :prompt do
        rule /\s+/, Text
        mixin :strings
        rule /FOR/i, Name::Builtin, :pop!

        rule(//) { pop! }
      end

      state :defer do
        rule /\s+/, Text
        mixin :comments
        rule /INTERRUPT/i, Keyword::Constant, :pop!
        rule /QUIT/i, Keyword::Constant, :pop!

        rule //, Error, :pop!
      end

      state :open_window do
        rule /\s+/, Text
        rule /WITH/i, Name::Builtin, :open_window_with
        rule /ATTRIBUTE/i, Name::Builtin, :window_attributes
        rule(//) { pop! }
      end

      state :open_window_with do
        rule /\s+/, Text
        rule /(\d+)(\s+)(ROWS)(\s+)(,)(\s+)(\d+)(\s+)(COLUMS)/i do |m|
          groups Num::Integer, Text, Name::Builtin, Text, Punctuation, Text, Num::Integer, Text, Name::Builtin
          pop!
        end
        rule /FORM/i, Name::Builtin
        mixin :strings
        mixin :identifier

        rule(//) { pop! }
      end

      state :window_attributes do
        rule /\s+/, Text
        rule /\(/, Punctuation, :window_attribute_value

        rule /,/, Punctuation
        rule /\)/, Punctuation, :pop!
      end

      state :window_attribute_value do
        mixin :colors
        rule /(BOLD|DIM|NORMAL)/i, Keyword::Constant
        rule /(BORDER|REVERSE)/i, Keyword::Constant
        mixin :line_options
        rule /,/, Punctuation, :window_attribute_value

        rule(//) { pop! }
      end

      state :colors do
        rule /(BLACK|BLUE|CYAN|GREEN|MAGENTA|RED|WHITE|YELLOW)/i, Keyword::Constant
      end

      state :open_form do
        rule /\s+/, Text
        rule /([a-zA-Z_][\w]*)(\s+)(FROM)/i do |m|
          groups Name, Text, Name::Builtin
        end
        mixin :strings
        rule(//) { pop! }
      end

      state :single_string do
        rule /\\./, Str::Escape
        rule /''/, Str::Escape
        rule /'/, Str::Single, :pop!
        rule /[^\\']+/, Str::Single
      end

      state :double_string do
        rule /\\./, Str::Escape
        rule /""/, Str::Escape
        rule /"/, Str::Double, :pop!
        rule /[^\\"]+/, Str::Double
      end
    end
  end
end
