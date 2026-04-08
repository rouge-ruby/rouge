# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class COBOL < RegexLexer
      title 'COBOL'
      desc 'COBOL (Common Business-Oriented Language) programming language'
      tag 'cobol'
      filenames '*.cob', '*.cbl', '*.cpy', '*.cpb'
      mimetypes 'text/x-cobol'

      lazy { require_relative 'cobol/keywords' }

      identifier = /\p{Alpha}[\p{Alnum}-]*/

      DIVISIONS = Set.new %w(
        IDENTIFICATION ENVIRONMENT DATA PROCEDURE DIVISION
      )

      SECTIONS = Set.new %w(
        CONFIGURATION INPUT-OUTPUT FILE WORKING-STORAGE LOCAL-STORAGE LINKAGE SECTION
      )

      state :root do
        # First detect the comments
        rule %r/^(      \*).*|^(^Debug \*).*/, Comment::Special

        # Strings
        rule %r/"/, Str::Double, :string_double
        rule %r/'/, Str::Single, :string_single

        # Keywords and divisions
        keywords %r/(?<![\w-])#{identifier}(?![\w-])/i do
          transform(&:upcase)
          rule DIVISIONS, Keyword::Declaration
          rule SECTIONS, Keyword::Namespace
          rule KEYWORDS, Keyword
          default Name
        end

        # Numbers
        rule %r/[-+]?\b\d+(\.\d+)?\b/, Num

        # Punctuation
        rule %r/[.,;:()]/, Punctuation

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
        rule %r/\n/, Error # Flag an error if a string goes to the next line
      end

      # Handle strings where ' opens a string and must be closed by '
      state :string_single do
        # Ensure strings can't span multiple lines
        rule %r/[^'\\\n]+/, Str
        rule %r/\\./, Str::Escape
        rule %r/'/, Str::Single, :pop!
        rule %r/\n/, Error # Flag an error if a string goes to the next line
      end
    end
  end
end
