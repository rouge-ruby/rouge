# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class ABAP < RegexLexer
      title "ABAP"
      desc "SAP - Advanced Business Application Programming"
      tag 'abap'
      filenames '*.abap'
      mimetypes 'text/x-abap'

      lazy { require_relative 'abap/builtins' }

      TYPES = Set.new %w(
        b c d decfloat16 decfloat34 f i int8 n p s t x
        clike csequence decfloat string xstring
      )

      NEW_KEYWORDS = Set.new %w(DATA FIELD-SYMBOL)

      state :root do
        rule %r/\s+/m, Text

        rule %r/"[^\r\n]*/, Comment::Single
        rule %r/^\*[^\r\n]*/, Comment::Single
        rule %r/\d+/, Num::Integer

        # String templates |...|
        rule %r/\|/, Str::Interpol, :string_template

        rule %r/('|`)/, Str::Single, :single_string

        # CDS annotations: @KEYWORD.field
        rule %r/(@)([A-Z][A-Za-z0-9_]*)(\.)([A-Za-z][A-Za-z0-9_]*)/ do |m|
          token Operator, m[1]
          if KEYWORDS.include? m[2].upcase
            token Keyword, m[2]
          else
            token Name, m[2]
          end
          token Punctuation, m[3]
          token Name, m[4]
        end

        # structure field access with dot (table.field should not highlight field as keyword)
        # This must come before the general punctuation rule
        # In dot-access patterns, treat both parts as names (even if they match keywords)
        rule %r/([A-Za-z][A-Za-z0-9_]*)(\.)([A-Za-z][A-Za-z0-9_]*)/ do |m|
          token Name, m[1]
          token Punctuation, m[2]
          token Name, m[3]
        end
        # Parameter names in function/method interfaces (word before =)
        # Matches word followed by optional whitespace and =
        # This handles EXPORTING/IMPORTING/CHANGING/TABLES/USING parameter names
        rule %r/([A-Za-z][A-Za-z0-9_]*)(?=\s*=)/ do |m|
          token Name, m[1]
        end
        rule %r/[\[\]\(\)\{\}\.,:]/, Punctuation

        # builtins / new ABAP 7.40 keywords (@DATA(), ...)
        rule %r/(->|=>)?([A-Za-z][A-Za-z0-9_\-]*)(\()/ do |m|
          token Operator, m[1]

          word = m[2]

          if (NEW_KEYWORDS.include? word.upcase) && m[1].nil?
            token Keyword, m[2]
          elsif (BUILTINS.include? word.downcase) && m[1].nil?
            token Name::Builtin, m[2]
          else
            token Name, m[2]
          end

          token Punctuation, m[3]
        end

        # hyphenated keywords (like NON-UNIQUE)
        rule %r/[A-Za-z][A-Za-z0-9_]*(-[A-Za-z][A-Za-z0-9_]*)+/ do |m|
          if KEYWORDS.include? m[0].upcase
            token Keyword
          else
            token Name
          end
        end

        # structure component access (variable-component should not be highlighted as keyword)
        # this rule matches: word-word where the second part is lowercase or starts lowercase
        rule %r/[A-Za-z][A-Za-z0-9_]*-[a-z][A-Za-z0-9_]*/, Name

        # variable names starting with $ (like $session)
        rule %r/\$[A-Za-z][A-Za-z0-9_]*/, Name

        # keywords, types and normal text
        rule %r/\w\w*/ do |m|
          if KEYWORDS.include? m[0].upcase
            token Keyword
          elsif TYPES.include? m[0].downcase
            token Keyword::Type
          else
            token Name
          end
        end

        # operators
        rule %r((->|->>|=>)), Operator
        rule %r([-\*\+%/~=&\?<>!#\@\^]+), Operator

      end

      state :operators do
        rule %r((->|->>|=>)), Operator
        rule %r([-\*\+%/~=&\?<>!#\@\^]+), Operator
      end

      state :single_string do
        rule %r/\\./, Str::Escape
        rule %r/(''|``)/, Str::Escape
        rule %r/['`]/, Str::Single, :pop!
        rule %r/[^\\'`]+/, Str::Single
      end

      state :string_template do
        rule %r/\{[^}]*\}/, Str::Interpol  # embedded expressions
        rule %r/\|/, Str::Interpol, :pop!
        rule %r/[^|{]+/, Str::Interpol
      end

    end
  end
end
