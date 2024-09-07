# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class COBOL < RegexLexer
      title 'COBOL'
      desc 'COBOL (Common Business-Oriented Language) programming language'
      tag 'cobol'
      filenames '*.cob', '*.cbl', '*.cobol', '*.cpy'
      mimetypes 'text/x-cobol'

      # List of COBOL keywords
      # TODO expand with all keywords listed here: https://www.ibm.com/docs/en/cobol-zos/6.3?topic=appendixes-reserved-words
      # TODO but move some that are more operator than keyword to the operators list lower in the file
      KEYWORDS = %w[
        ACCEPT ADD ALTER APPLY CALL CANCEL CLOSE COMPUTE CONTINUE
        DECLARE DELETE DISPLAY DIVIDE ELSE END-ADD END-CALL END-COMPUTE
        END-DELETE END-DISPLAY END-DIVIDE END-EVALUATE END-IF END-MULTIPLY
        END-OF-PAGE END-PERFORM END-READ END-RETURN END-REWRITE END-SEARCH
        END-START END-STRING END-SUBTRACT END-UNSTRING END-WRITE EVALUATE
        EXIT GOBACK IF INITIALIZE INSPECT MERGE MOVE MULTIPLY NEXT
        OPEN PERFORM READ RECEIVE RETURN REWRITE SEARCH SEND SET SORT
        START STOP STRING SUBTRACT UNSTRING WRITE
      ]

      # COBOL divisions and sections
      DIVISIONS = %w[
        IDENTIFICATION ENVIRONMENT DATA PROCEDURE DIVISION
      ]

      SECTIONS = %w[
        CONFIGURATION INPUT-OUTPUT FILE WORKING-STORAGE LOCAL-STORAGE LINKAGE SECTION
      ]

      # Define tokens for the lexer
      state :whitespace do
        rule %r/\s+/m, Text::Whitespace
      end

      state :root do
        mixin :whitespace

        # Comments
        rule %r{(\*)[^\n]*}, Comment::Single

        # Strings
        rule %r/"/, Str::Double, :string
        rule %r/'/, Str::Single, :string

        # Keywords and divisions
        rule %r/\b(#{DIVISIONS.join('|')})\b/i, Keyword::Declaration
        rule %r/\b(#{SECTIONS.join('|')})\b/i, Keyword::Namespace
        rule %r/\b(#{KEYWORDS.join('|')})\b/i, Keyword

        # Numbers
        rule %r/\b\d+(\.\d+)?\b/, Num

        # Identifiers
        rule %r/[a-zA-Z0-9_-]+/, Name

        # Punctuation and operators
        rule %r/[.,;:()]/, Punctuation
        rule %r/[+-\/\*=&><]/, Operator
      end

      # TODO double check string escaping in COBOL
      state :string do
        rule %r/[^'"\\]+/, Str
        rule %r/\\./, Str::Escape
        rule %r/["']/, Str, :pop!
      end
    end
  end
end
