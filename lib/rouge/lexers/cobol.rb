# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class COBOL < RegexLexer
      title 'COBOL'
      desc 'COBOL (Common Business-Oriented Language) programming language'
      tag 'cobol'
      filenames '*.cob', '*.cbl'
      mimetypes 'text/x-cobol'

      # List of COBOL keywords
      KEYWORDS = %w[
        ACCEPT ACCESS ACTIVE-CLASS ADD ADDRESS ADVANCING AFTER ALIGNED ALL ALLOCATE ALPHABET ALPHABETIC ALPHABETIC-LOWER
        ALPHABETIC-UPPER ALPHANUMERIC ALPHANUMERIC-EDITED ALSO ALTER ALTERNATE AND ANY ANYCASE APPLY ARE AREA AREAS
        ASCENDING ASSIGN AT AUTHOR B-AND B-NOT B-OR B-XOR BASED BASIS BEFORE BEGINNING BINARY BINARY-CHAR BINARY-DOUBLE
        BINARY-LONG BINARY-SHORT BIT BLANK BLOCK BOOLEAN BOTTOM BY BYTE-LENGTH CALL CANCEL CBL CD CF CH CHARACTER
        CHARACTERS CLASS CLASS-ID CLOCK-UNITS CLOSE COBOL CODE CODE-SET COL COLLATING COLS COLUMN COLUMNS COM-REG COMMA
        COMMON COMMUNICATION COMP-1 COMP-2 COMP-3 COMP-4 COMP-5 COMP COMPUTATIONAL-1 COMPUTATIONAL-2
        COMPUTATIONAL-3 COMPUTATIONAL-4 COMPUTATIONAL-5 COMPUTATIONAL COMPUTE CONDITION CONSTANT CONTAINS CONTENT
        CONTINUE CONTROL CONTROLS CONVERTING COPY CORR CORRESPONDING COUNT CRT CURRENCY CURSOR DATA-POINTER DATE
        DATE-COMPILED DATE-WRITTEN DAY DAY-OF-WEEK DBCS DE DEBUG-CONTENTS DEBUG-ITEM DEBUG-LINE DEBUG-NAME DEBUG-SUB-1
        DEBUG-SUB-2 DEBUG-SUB-3 DEBUGGING DECIMAL-POINT DECLARATIVES DEFAULT DELETE DELIMITED DELIMITER DEPENDING
        DESCENDING DESTINATION DETAIL DISABLE DISPLAY-1 DISPLAY DIVIDE DOWN DUPLICATES DYNAMIC EC EGCS EGI
        EJECT ELSE EMI ENABLE END-ACCEPT END-ADD END-CALL END-COMPUTE END-DELETE END-DISPLAY END-DIVIDE END-EVALUATE
        END-EXEC END-IF END-INVOKE END-JSON END-MULTIPLY END-OF-PAGE END-PERFORM END-READ END-RECEIVE END-RETURN
        END-REWRITE END-SEARCH END-START END-STRING END-SUBTRACT END-UNSTRING END-WRITE END-XML ENDING END ENTER ENTRY
        EO EOP EQUAL ERROR ESI EVALUATE EVERY EXCEPTION EXCEPTION-OBJECT EXEC EXECUTE EXIT EXTEND EXTERNAL
        FACTORY FALSE FD FILE-CONTROL FILLER FINAL FIRST FLOAT-EXTENDED FLOAT-LONG FLOAT-SHORT FOOTING FOR FORMAT
        FREE FROM FUNCTION FUNCTION-ID FUNCTION-POINTER GENERATE GET GIVING GLOBAL GO GOBACK GREATER GROUP GROUP-USAGE
        HEADING HIGH-VALUE HIGH-VALUES I-O-CONTROL I-O ID IF IN INDEX INDEXED INDICATE INHERITS INITIAL
        INITIALIZE INITIATE INPUT INSERT INSPECT INSTALLATION INTERFACE INTERFACE-ID INTO INVALID INVOKE
        IS JAVA JNIENVPTR JSON JSON-CODE JSON-STATUS JUST JUSTIFIED KANJI KEY LABEL LAST LEADING LEFT LENGTH LESS LIMIT
        LIMITS LINAGE-COUNTER LINAGE LINE-COUNTER LINES LINE LOCALE LOCK LOW-VALUE LOW-VALUES
        MEMORY MERGE MESSAGE METHOD METHOD-ID MINUS MODE MODULES MORE-LABELS MOVE MULTIPLE MULTIPLY NATIONAL
        NATIONAL-EDITED NATIVE NEGATIVE NESTED NEXT NO NOT NULL NULLS NUMBER NUMERIC NUMERIC-EDITED OBJECT
        OBJECT-COMPUTER OBJECT-REFERENCE OCCURS OF OFF OMITTED ON OPEN OPTIONAL OPTIONS OR ORDER ORGANIZATION
        OTHER OUTPUT OVERFLOW OVERRIDE PACKED-DECIMAL PADDING PAGE PAGE-COUNTER PASSWORD PERFORM PF PH PIC PICTURE
        PLUS POINTER- POINTER-31 POINTER-32 POINTER-64 POINTER POSITION POSITIVE PRESENT PRINTING
        PROCEDURE-POINTER PROCEDURES PROCEED PROCESSING PROGRAM-ID PROGRAM-POINTER PROGRAM PROPERTY PROTOTYPE
        PURGE QUEUE QUOTE QUOTES RAISE RAISING RANDOM RD READ READY RECEIVE RECORD RECORDING RECORDS RECURSIVE REDEFINES
        REEL REFERENCE REFERENCES RELATIVE RELEASE RELOAD REMAINDER REMOVAL RENAMES REPLACE REPLACING REPORT REPORTING
        REPORTS REPOSITORY RERUN RESERVE RESET RESUME RETRY RETURN RETURN-CODE RETURNING REVERSED REWIND REWRITE RF RH
        RIGHT ROUNDED RUN SAME SCREEN SD SEARCH SECTION SECURITY SEGMENT SEGMENT-LIMIT SELECT SELF SEND SENTENCE
        SEPARATE SEQUENCE SEQUENTIAL SERVICE SET SHARING SHIFT-IN SHIFT-OUT SIGN SIZE SKIP1 SKIP2 SKIP3
        SORT-CONTROL SORT-CORE-SIZE SORT-FILE-SIZE SORT-MERGE SORT-MESSAGE SORT-MODE-SIZE SORT-RETURN SORT
        SOURCE-COMPUTER SOURCES SOURCE SPACE SPACES SPECIAL-NAMES SQL SQLIMS STANDARD-1 STANDARD-2 STANDARD START STATUS STOP
        STRING SUB-QUEUE-1 SUB-QUEUE-2 SUB-QUEUE-3 SUBTRACT SUM SUPER SUPPRESS SYMBOLIC SYNC SYNCHRONIZED SYSTEM-DEFAULT
        TABLE TALLY TALLYING TAPE TERMINAL TERMINATE TEST TEXT THAN THEN THROUGH THRU TIME TIMES TITLE TO TOP TRACE
        TRAILING TRUE TYPE TYPEDEF UNIT UNIVERSAL UNLOCK UNSTRING UNTIL UP UPON USAGE USE USER-DEFAULT USING UTF-8
        VAL-STATUS VALID VALIDATE VALIDATE-STATUS VALUE VALUES VARYING VOLATILE WHEN WHEN-COMPILED WITH WORDS
        WRITE WRITE-ONLY XML-CODE XML-EVENT XML-INFORMATION XML-NAMESPACE XML-NAMESPACE-PREFIX
        XML-NNAMESPACE XML-NNAMESPACE-PREFIX XML-NTEXT XML-SCHEMA XML-TEXT XML ZERO ZEROES ZEROS
      ]

      # COBOL divisions and sections
      DIVISIONS = %w[
        IDENTIFICATION ENVIRONMENT DATA PROCEDURE DIVISION
      ]

      SECTIONS = %w[
        CONFIGURATION INPUT-OUTPUT FILE WORKING-STORAGE LOCAL-STORAGE LINKAGE SECTION
      ]

      state :root do
        # First detect the comments
        rule %r/^(      \*).*|^(^Debug \*).*/, Comment::Special

        # Strings
        rule %r/"/, Str::Double, :string_double
        rule %r/'/, Str::Single, :string_single

        # Keywords and divisions
        rule %r/\b(#{DIVISIONS.join('|')})\b/i, Keyword::Declaration
        rule %r/\b(#{SECTIONS.join('|')})\b/i, Keyword::Namespace
        rule %r/\b(#{KEYWORDS.join('|')})\b/i, Keyword

        # Numbers
        rule %r/[-+]?\b\d+(\.\d+)?\b/, Num

        # Identifiers
        rule %r/[a-zA-Z0-9_-]+/, Name

        # Punctuation
        rule %r/[.,;:()]/, Punctuation
        # TODO Find out what's going wrong in the "+ (2 **" line

        # Comments
        rule %r/\*>.*/, Comment::Single

        # Operators
        rule %r/[+\-*\/><=]/, Operator

        # Whitespace remaining
        rule %r/\s/, Text::Whitespace

        # Anything else remaining
        rule %r/.+/, Text
      end

      # TODO double check string escaping in COBOL
      # TODO Fix that a string opened by " can't be closed by '
      # TODO Fix that strings can't be multi-line

      # Handle strings where " opens a string and must be closed by "
      state :string_double do
        # Ensure strings can't span multiple lines
        rule %r/[^"\\\n]+/, Str
        rule %r/\\./, Str::Escape
        rule %r/"/, Str::Double, :pop!
        rule %r/\n/, Error   # Flag an error if a string goes to the next line
      end

      # Handle strings where ' opens a string and must be closed by '
      state :string_single do
        # Ensure strings can't span multiple lines
        rule %r/[^'\\\n]+/, Str
        rule %r/\\./, Str::Escape
        rule %r/'/, Str::Single, :pop!
        rule %r/\n/, Error   # Flag an error if a string goes to the next line
      end
    end
  end
end
