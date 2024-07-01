# -*- coding: utf-8 -*- #
# frozen_string_literal: true

# Adapted from Rouge lib/rouge/lexers/PostScript.rb
module Rouge
  module Lexers
    class Pdf < RegexLexer
      title "PDF"
      desc "PDF - Portable Document Format (ISO 32000)"
      tag "pdf"
      aliases "fdf", "cos"
      filenames "*.pdf", "*.fdf"
      mimetypes "application/pdf", "application/fdf" # IANA registered media types

      # PDF and FDF files must start with "%PDF-x.y" or "%FDF-x.y"
      # where x is the emajor version (1-9) and y is the minor version (0-9)
      # Supports invalid PDF versions.
      def self.detect?(text)
        return true if /^%[PF]DF-[1-9]\.\d/ =~ text
      end

      # PDF Delimiters (ISO 32000-2:2020, Table 2) including Ruby whitespace 
      delimiter = %s"()<>\[\]/%\s"

      delimiter_end = Regexp.new("(?=[#{delimiter}])")
      valid_name_chars = Regexp.new("[^#{delimiter}]")

      state :root do
        # PDF only has single-line comments: from "%"" to EOL
        rule %r'%.*?$', Comment::Single

        # PDF Boolean object
        rule %r'(false|true)#{delimiter_end}', Keyword::Constant

        # PDF Null object
        rule %r'(null)#{delimiter_end}', Keyword::Constant

        # PDF Hex string - can contain whitespace and span multiple lines
        rule %r/<[0-9A-Fa-f\s]+>/m, String::Other

        # PDF Dictionary
        rule %r/<</, Variable::Instance
        rule %r/>>/, Variable::Instance

        # PDF Arrays
        rule %r/\[/, Variable::Instance
        rule %r/\]/, Variable::Instance

        # PDF literal strings are complex (multi-line, escapes, etc.); enter separate state.
        rule %r'\(', String, :stringliteral

        # PDF Name objects - can be empty (nothing after "/")
        # No special processing needed for 2-digit hex codes starting with "#"
        rule %r'/\/#{valid_name_chars}*#{delimiter_end}', Name::Variable

        # PDF objects and stream (no checking of object number)
        rule %r/\d+\s\d+obj#{delimiter_end}/, Keyword::Declaration
        rule %r/stream/, Keyword::Declaration
        rule %r/endstream/, Keyword::Declaration
        rule %r/endobj/, Keyword::Declaration

        # PDF file layout
        rule %r/xref/, Keyword::Constant
        rule %r/trailer/, Keyword::Constant
        rule %r/startxref/, Keyword::Constant

        # PDF cross reference section entries (supposedly 20 bytes including EOL)
        rule %r/^\d{10} \d{5} [nf]\s?/, Keyword::Namespace

        # PDF Indirect reference (lax, allows zero as the object number)
        rule %r/\d+\s\d+R#{delimiter_end}/. Keyword::Pseudo

        # PDF Real object
        rule %r/(\-|\+)?([0-9]+\.?|[0-9]*\.[0-9]+|[0-9]+\.[0-9]*)#{delimiter_end}/, Number::Float

        # PDF Integer object
        rule %r/(\-|\+)?[0-9]+#{delimiter_end}/, Number::Integer

        # most likely PDF content stream operators
        rule valid_name_chars, Operator::Word
      end

      # PDF literal string - see ISO 32000-2:2020 clause 7.3.4.2 and Table 3
      state :stringliteral do
        rule %r/\(/, String, :stringliteral     # recursive for internal balanced literal strings
        rule %r/\)/, String, :pop!
        rule %r/\\([0-7]{3}|n|r|t|b|f|\\)/, String::Escape
        rule %r/[^\(\)\\]+/, String
      end
    end
  end
end
