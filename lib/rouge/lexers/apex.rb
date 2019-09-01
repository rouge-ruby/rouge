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
          SELECT FROM WHERE UPDATE LIKE TYPEOF END USING SCOPE WITH DATA
          CATEGORY GROUP BY ROLLUP CUBE HAVING ORDER BY ASC DESC NULLS FIRST
          LAST LIMIT OFFSET FOR VIEW REFERENCE UPDATE TRACKING VIEWSTAT OR AND
        )
      end

      def self.types
        @types ||= Set.new %w(
          String boolean byte char double float int long short var void
        )
      end

      def self.constants
        @constants ||= Set.new %w(true false null)
      end

      id = /[a-zA-Z_][a-zA-Z0-9_]*/

      state :root do
        rule %r/[^\S\n]+/, Text
        rule %r(//.*?$), Comment::Single
        rule %r(/\*.*?\*/)m, Comment::Multiline

        rule %r(
          (\s*(?:[a-zA-Z_][a-zA-Z0-9_.\[\]<>]*\s+)+?) # return arguments
          ([a-zA-Z_][a-zA-Z0-9_]*)                  # method name
          (\s*)(\()                                 # signature start
        )mx do |m|
          delegate Apex, m[1]
          token Name::Function, m[2]
          token Text, m[3]
          token Operator, m[4]
        end

        rule %r/(?:class|interface)\b/, Keyword::Declaration, :class
        rule %r/import\b/, Keyword::Namespace, :import

        rule %r/([@$.]?)(#{id})([:]?)/io do |m|
          if self.class.keywords.include? m[0].downcase
            token Keyword
          elsif self.class.soql.include? m[0].upcase
            token Keyword
          elsif self.class.declarations.include? m[0].downcase
            token Keyword::Declaration
          elsif self.class.types.include? m[0].downcase
            token Keyword::Type
          elsif self.class.constants.include? m[0].downcase
            token Keyword::Constant
          elsif 'package' == m[0].downcase
            token Keyword::Namespace
          elsif m[1] == "@"
            token Name::Decorator
          elsif m[1] == "."
            groups Operator, Name::Attribute
          elsif m[3] == ":"
            token Name::Label
          else
            token Name
          end
        end

        rule %r/[~^*!%&\[\](){}<>\|+=:;,.\/?-]/, Operator

        rule %r/"/, Str::Double, :dq
        rule %r/'/, Str::Single, :sq

        digit = /[0-9]_+[0-9]|[0-9]/
        bin_digit = /[01]_+[01]|[01]/
        oct_digit = /[0-7]_+[0-7]|[0-7]/
        hex_digit = /[0-9a-f]_+[0-9a-f]|[0-9a-f]/i
        rule %r/#{digit}+\.#{digit}+([eE]#{digit}+)?[fd]?/, Num::Float
        rule %r/0b#{bin_digit}+/i, Num::Bin
        rule %r/0x#{hex_digit}+/i, Num::Hex
        rule %r/0#{oct_digit}+/, Num::Oct
        rule %r/#{digit}+L?/, Num::Integer
        rule %r/\n/, Text
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
