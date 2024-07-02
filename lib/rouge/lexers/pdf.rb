# -*- coding: utf-8 -*- #
# frozen_string_literal: true

# PDF = Portable Document Format page description language
# As defined by ISO 32000-2:2020 including resolved errata from https://pdf-issues.pdfa.org/
#
# The PDF syntax is also know as "COS" and can also be used with FDF (Forms Data Field) files. 
#
# This is a token-based parser ONLY! It is intended to syntax highlight full or partial fragments 
# of nicely written hand-writteen PDF syntax in documentation such as ISO specifications. It is NOT
# intended to cope with real-world PDFs that will contain arbitrary binary data (that form invalid
# UTF-8 sequences and generate "ArgumentError: invalid byte sequence in UTF-8" Ruby errors) and 
# other types of malformation/syntax errors. 
#
# Author: Peter Wyatt, CTO, PDF Association. 2024
#
module Rouge
  module Lexers
    class Pdf < RegexLexer
      title "PDF"
      desc "PDF - Portable Document Format (ISO 32000)"
      tag "Pdf"
      aliases "fdf", "cos"
      filenames "*.pdf", "*.fdf"
      mimetypes "application/pdf", "application/fdf" # IANA registered media types

      # PDF and FDF files must start with "%PDF-x.y" or "%FDF-x.y"
      # where x is the single digit major version and y is the single digit minor version.
      def self.detect?(text)
        return true if /^%(P|F)DF-\d.\d/ =~ text
      end

      # PDF Delimiters (ISO 32000-2:2020, Table 1 and Table 2).
      # Ruby whitespace "\s" is /[ \t\r\n\f\v]/ which does not include NUL (ISO 32000-2:2020, Table 1).
      # PDF also support 2 character EOL sequences.
      delimiter = %r/\(\)<>\[\]\/%\s/

      state :root do
        # Start-of-file header comment is special (comment is up to EOL)
        rule %r/^%(P|F)DF-\d\.\d.*$/, Comment::Special

        # End-of-file marker comment is special (comment is up to EOL)
        rule %r/^%%EOF.*$/, Comment::Special

        # PDF only has single-line comments: from "%" to EOL
        rule %r/%.*$/, Comment::Single

        # PDF Boolean and null object keywords
        rule %r/(false|true|null)/, Keyword::Constant

        # PDF Dictionary and array object start and end tokens
        rule %r/(<<|>>|\[|\])/, Punctuation

        # PDF Hex string - can contain whitespace and span multiple lines.
        # This rule must be after "<<"/">>"
        rule %r/<[0-9A-Fa-f\s]*>/m, Str::Other

        # PDF literal strings are complex (multi-line, escapes, etc.). Use separate state machine.
        rule %r/\(/, Str, :stringliteral

        # PDF Name objects - can be empty (i.e., nothing after "/").
        # No special processing required for 2-digit hex codes that start with "#".
        rule %r/\/[^\(\)<>\[\]\/%\s]*/, Name::Entity

        # PDF objects and stream (no checking of object ID)
        # Note that object number and generation numbers do not have sign.
        rule %r/\d+\s\d+\sobj/, Keyword::Declaration
        rule %r/(endstream|endobj|stream)/, Keyword::Declaration

        # PDF conventional file layout keywords
        rule %r/(startxref|trailer|xref)/, Keyword::Constant

        # PDF cross reference section entries (20 bytes including EOL).
        # Explicit single SPACE separators.
        rule %r/^\d{10} \d{5} (n|f)\s*$/, Keyword::Namespace

        # PDF Indirect reference (lax, allows zero as the object number).
        # Requires terminating delimiter lookahead to disambiguate from "RG" operator
        rule %r/\d+\s\d+\sR(?=[\(\)<>\[\]\/%\s])/, Keyword::Variable

        # PDF Real object
        rule %r/(\-|\+)?([0-9]+\.?|[0-9]*\.[0-9]+|[0-9]+\.[0-9]*)/, Num::Float

        # PDF Integer object
        rule %r/(\-|\+)?[0-9]+/, Num::Integer

        # A run of non-delimiters is most likely a PDF content stream 
        # operator (ISO 32000-2:2020, Annex A).
        rule %r/[^\(\)<>\[\]\/%\s]+/, Operator::Word

        # Whitespace (except inside strings and comments) is ignored = /[ \t\r\n\f\v]/.
        # Ruby doesn't include NUL as whitespace (vs ISO 32000-2:2020 Table 1)
        rule %r/\s+/, Text::Whitespace
      end

      # PDF literal string. See ISO 32000-2:2020 clause 7.3.4.2 and Table 3
      state :stringliteral do
        rule %r/\(/, Str, :stringliteral     # recursive for internal balanced(!) literal strings
        rule %r/\)/, Str, :pop!
        rule %r/\\([0-7]{3}|n|r|t|b|f|\\)/, Str::Escape
        rule %r/[^\(\)\\]+/, Str
      end
    end
  end
end
