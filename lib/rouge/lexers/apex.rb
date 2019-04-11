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

      keywords = %w(
        assert break case catch continue default do else finally for
        if goto instanceof new return switch this throw try while insert
        update delete
      )

      declarations = %w(
        abstract const enum extends final implements native private protected
        public static super synchronized throws transient volatile with
        sharing without inherited virtual global testmethod
      )

      soql = %w(
        SELECT FROM WHERE  UPDATE LIKE TYPEOF END USING  SCOPE WITH DATA
        CATEGORY GROUP BY ROLLUP CUBE HAVING  ORDER BY ASC DESC NULLS FIRST LAST
        LIMIT OFFSET FOR VIEW REFERENCE UPDATE TRACKING VIEWSTAT OR AND
      )

      types = %w(String boolean byte char double float int long short var void)

      id = /[a-zA-Z_][a-zA-Z0-9_]*/

      state :root do
        rule /[^\S\n]+/, Text
        rule %r(//.*?$), Comment::Single
        rule %r(/\*.*?\*/)m, Comment::Multiline
        rule /(?:#{keywords.join('|')})\b/, Keyword
        rule /(?:#{soql.join('|')})\b/, Keyword

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

        rule /@#{id}/, Name::Decorator
        rule /(?:#{declarations.join('|')})\b/, Keyword::Declaration
        rule /(?:#{types.join('|')})\b/, Keyword::Type
        rule /package\b/, Keyword::Namespace
        rule /(?:true|false|null)\b/, Keyword::Constant
        rule /(?:class|interface)\b/, Keyword::Declaration, :class
        rule /import\b/, Keyword::Namespace, :import
        rule /"(\\\\|\\"|[^"])*"/, Str
        rule /'(\\\\|\\'|[^'])*'/, Str
        rule /(\.)(#{id})/ do
          groups Operator, Name::Attribute
        end

        rule /#{id}:/, Name::Label
        rule /\$?#{id}/, Name
        rule /[~^*!%&\[\](){}<>\|+=:;,.\/?-]/, Operator

        digit = /[0-9]_+[0-9]|[0-9]/
        bin_digit = /[01]_+[01]|[01]/
        oct_digit = /[0-7]_+[0-7]|[0-7]/
        hex_digit = /[0-9a-f]_+[0-9a-f]|[0-9a-f]/i
        rule /#{digit}+\.#{digit}+([eE]#{digit}+)?[fd]?/, Num::Float
        rule /0b#{bin_digit}+/i, Num::Bin
        rule /0x#{hex_digit}+/i, Num::Hex
        rule /0#{oct_digit}+/, Num::Oct
        rule /#{digit}+L?/, Num::Integer
        rule /\n/, Text
      end

      state :class do
        rule /\s+/m, Text
        rule id, Name::Class, :pop!
      end

      state :import do
        rule /\s+/m, Text
        rule /[a-z0-9_.]+\*?/i, Name::Namespace, :pop!
      end
    end
  end
end
