# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class SQL < RegexLexer
      title "SQL"
      desc "Structured Query Language, for relational databases"
      tag 'sql'
      filenames '*.sql'
      mimetypes 'text/x-sql'

      lazy { require_relative 'sql/keywords' }

      state :root do
        rule %r/\s+/m, Text
        rule %r/--.*/, Comment::Single
        rule %r(/\*), Comment::Multiline, :multiline_comments
        rule %r/\d+/, Num::Integer
        rule %r/'/, Str::Single, :single_string
        # A double-quoted string refers to a database object in our default SQL
        # dialect, which is apropriate for e.g. MS SQL and PostgreSQL.
        rule %r/"/, Name::Variable, :double_string
        rule %r/`/, Name::Variable, :backtick

        keywords %r/\w+/ do
          transform(&:upcase)

          rule :keywords_type, Name::Builtin
          rule :keywords, Keyword
          default Name
        end

        rule %r([+*/<>=~!@#%&|?^-]), Operator
        rule %r/[;:()\[\]\{\},.]/, Punctuation
      end

      state :multiline_comments do
        rule %r(/[*]), Comment::Multiline, :multiline_comments
        rule %r([*]/), Comment::Multiline, :pop!
        rule %r([^/*]+), Comment::Multiline
        rule %r([/*]), Comment::Multiline
      end

      state :backtick do
        rule %r/\\./, Str::Escape
        rule %r/``/, Str::Escape
        rule %r/`/, Name::Variable, :pop!
        rule %r/[^\\`]+/, Name::Variable
      end

      state :single_string do
        rule %r/\\./, Str::Escape
        rule %r/''/, Str::Escape
        rule %r/'/, Str::Single, :pop!
        rule %r/[^\\']+/, Str::Single
      end

      state :double_string do
        rule %r/\\./, Str::Escape
        rule %r/""/, Str::Escape
        rule %r/"/, Name::Variable, :pop!
        rule %r/[^\\"]+/, Name::Variable
      end
    end
  end
end
