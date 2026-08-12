# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Apex < RegexLexer
      title "Apex"
      desc "The Apex programming language (provided by salesforce)"

      tag 'apex'
      filenames '*.cls'
      mimetypes 'text/x-apex'

      def self.keywords
        @keywords ||= Set.new %w(
          assert break case catch continue default do else finally for if goto
          instanceof new return switch this throw try while insert update
          delete
        )
      end

      def self.declarations
        @declarations ||= Set.new %w(
          abstract const enum extends final implements native private protected
          public static super synchronized throws transient volatile with
          sharing without inherited virtual global testmethod
        )
      end

      def self.soql
        @soql ||= Set.new %w(
          select from where update like typeof end using scope with data
          category group by rollup cube having order asc desc nulls first
          last limit offset for view reference tracking viewstat or and
        )
      end

      def self.types
        @types ||= Set.new %w(
          string boolean byte char double float int long short var void
        )
      end

      def self.constants
        @constants ||= Set.new %w(true false null)
      end

      id = /[a-z_][a-z0-9_]*/i

      state :root do
        rule %r/\s+/m, Text

        rule %r(//.*?$), Comment::Single
        rule %r(/\*.*?\*/)m, Comment::Multiline

        rule %r/(?:class|interface)\b/, Keyword::Declaration, :class
        rule %r/import\b/, Keyword::Namespace, :import

        keywords id do
          transform(&:downcase)

          rule :keywords, Keyword
          rule :soql, Keyword
          rule :declarations, Keyword::Declaration
          rule :types, Keyword::Type
          rule :constants, Keyword::Constant
          rule Set['package'], Keyword::Namespace

          default Name
        end

        rule %r/([@$.]?)(#{id})([:(]?)/io do |m|
          if m[1] == "@"
            token Name::Decorator
          elsif m[3] == ":"
            groups Operator, Name::Label, Punctuation
          elsif m[3] == "("
            groups Operator, Name::Function, Punctuation
          elsif m[1] == "."
            groups Operator, Name::Property, Punctuation
          else
            token Name
          end
        end

        rule %r/"/, Str::Double, :dq
        rule %r/'/, Str::Single, :sq

        digit = /[0-9]_+[0-9]|[0-9]/
        rule %r/#{digit}+\.#{digit}+([eE]#{digit}+)?[fd]?/, Num::Float
        rule %r/0b(?:[01]_+[01]|[01])+/i, Num::Bin
        rule %r/0x(?:\h_+\h|\h)+/i, Num::Hex
        rule %r/0(?:[0-7]_+[0-7]|[0-7])+/, Num::Oct
        rule %r/#{digit}+L?/, Num::Integer

        rule %r/[-+\/*~^!%&<>|=.?]/, Operator
        rule %r/[\[\](){},:;]/, Punctuation;
      end

      state :class do
        rule %r/\s+/m, Text
        rule id, Name::Class, :pop!
      end

      state :import do
        rule %r/\s+/m, Text
        rule %r/[a-z0-9_.]+\*?/i, Name::Namespace, :pop!
      end

      state :escape do
        rule %r/\\[btnfr\\"']/, Str::Escape
      end

      state :dq do
        mixin :escape
        rule %r/[^\\"]+/, Str::Double
        rule %r/"/, Str::Double, :pop!
      end

      state :sq do
        mixin :escape
        rule %r/[^\\']+/, Str::Double
        rule %r/'/, Str::Double, :pop!
      end
    end
  end
end
