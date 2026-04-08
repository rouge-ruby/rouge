# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers

    class Cfscript < RegexLexer
      title "CFScript"
      desc 'CFScript, the CFML scripting language'
      tag 'cfscript'
      aliases 'cfc'
      filenames '*.cfc'

      def self.keywords
        @keywords ||= Set.new %w(
          if else var xml default break switch do try catch throw in continue for return while required
        )
      end

      def self.declarations
        @declarations ||= Set.new %w(
          component property function remote public package private
        )
      end

      def self.types
        @types ||= Set.new %w(
          any array binary boolean component date guid numeric query string struct uuid void xml
        )
      end

      CONSTANTS = Set.new %w(
        application session client cookie super this variables arguments cgi
      )


      dotted_id = /[$a-zA-Z_][a-zA-Z0-9_.]*/

      state :root do
        mixin :comments_and_whitespace

        rule %r(
            [+][+] | -- | [|][|] | <= | >= | == | !=
          | [<>?]
          | (?:
             mod | eq | gte? | lte? | not | is | and | x?or | eqv | imp | equal
             | contains
             | does\s+not\s+contain
             | (?:greater|less)\s+than(?:\s+or\s+equal\s+to)?
          )\b
        )x, Operator, :expr_start

        rule %r([-<>+*%&|\^/!=]=?), Operator, :expr_start

        rule %r/[(\[,]/, Punctuation, :expr_start
        rule %r/;/, Punctuation, :statement
        rule %r/[)\].]/, Punctuation

        rule %r/[?]/ do
          token Punctuation
          push :ternary
          push :expr_start
        end

        rule %r/[{}]/, Punctuation, :statement

        keywords %r/\w+/ do
          rule CONSTANTS, Name::Constant
        end

        rule %r/(?:true|false|null)\b/, Keyword::Constant
        rule %r/import\b/, Keyword::Namespace, :import
        rule %r/(#{dotted_id})(\s*)(:)(\s*)/ do
          groups Name, Text, Punctuation, Text
          push :expr_start
        end

        keywords %r/([a-z_$][\w.]*)(\s*)(\()/i do |m|
          group 1

          rule :keywords do |m|
            groups Keyword, Text, Punctuation
          end

          default do |m|
            groups Name::Function, Text, Punctuation
          end
        end

        keywords dotted_id do
          rule :declarations, Keyword::Declaration, :expr_start
          rule :keywords, Keyword, :expr_start
          rule :types, Keyword::Type, :expr_start
          default Name::Other
        end

        rule %r/[0-9][0-9]*\.[0-9]+([eE][0-9]+)?[fd]?/, Num::Float
        rule %r/0x[0-9a-fA-F]+/, Num::Hex
        rule %r/[0-9]+/, Num::Integer
        rule %r/"(\\\\|\\"|[^"])*"/, Str::Double
        rule %r/'(\\\\|\\'|[^'])*'/, Str::Single
      end

      # same as java, broken out
      state :comments_and_whitespace do
        rule %r/\s+/, Text
        rule %r(//.*?$), Comment::Single
        rule %r(/\*.*?\*/)m, Comment::Multiline
      end

      state :expr_start do
        mixin :comments_and_whitespace

        rule %r/[{]/, Punctuation, :object

        rule %r//, Text, :pop!
      end

      state :statement do

        rule %r/[{}]/, Punctuation

        mixin :expr_start
      end

      # object literals
      state :object do
        mixin :comments_and_whitespace
        rule %r/[}]/ do
          token Punctuation
          push :expr_start
        end

        rule %r/(#{dotted_id})(\s*)(:)/ do
          groups Name::Other, Text, Punctuation
          push :expr_start
        end

        rule %r/:/, Punctuation
        mixin :root
      end

      # ternary expressions, where <dotted_id>: is not a label!
      state :ternary do
        rule %r/:/ do
          token Punctuation
          goto :expr_start
        end

        mixin :root
      end

      state :import do
        rule %r/\s+/m, Text
        rule %r/[a-z0-9_.]+\*?/i, Name::Namespace, :pop!
      end

    end
  end
end
