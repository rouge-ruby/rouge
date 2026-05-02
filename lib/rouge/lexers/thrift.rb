# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Thrift < RegexLexer
      title "Thrift"
      desc "Apache Thrift interface definition language"
      tag 'thrift'
      aliases 'apache-thrift'
      filenames '*.thrift'
      mimetypes 'text/x-thrift', 'application/x-thrift'

      def self.declarations
        @declarations ||= Set.new %w(
          include cpp_include namespace const typedef enum struct union
          exception service
        )
      end

      def self.keywords
        @keywords ||= Set.new %w(
          async cpp_type extends oneway optional required throws
          xsd_all xsd_attrs xsd_nillable xsd_optional
        )
      end

      def self.types
        @types ||= Set.new %w(
          binary bool byte double i8 i16 i32 i64 list map set string uuid void
        )
      end

      def self.constants
        @constants ||= Set.new %w(false true)
      end

      id = /[a-zA-Z_][a-zA-Z0-9_]*(?:\.[a-zA-Z0-9_]+)*/
      namespace_name = /[a-zA-Z_][a-zA-Z0-9_.-]*/
      double = /[+-]?(?:(?:\d+\.\d+|\.\d+)(?:[eE][+-]?\d+)?|\d+[eE][+-]?\d+)/

      state :comments_and_whitespace do
        rule %r/\s+/, Text
        rule %r/#.*$/, Comment::Single
        rule %r{//.*$}, Comment::Single
        rule %r{/\*}, Comment::Multiline, :comment
      end

      state :comment do
        rule %r/[^*]+/, Comment::Multiline
        rule %r/\*+\//, Comment::Multiline, :pop!
        rule %r/\*+/, Comment::Multiline
      end

      state :namespace_scope do
        mixin :comments_and_whitespace

        rule %r/\*/ do
          token Punctuation
          goto :namespace_name
        end

        rule id do
          token Keyword::Namespace
          goto :namespace_name
        end

        rule(//) { pop! }
      end

      state :namespace_name do
        mixin :comments_and_whitespace

        rule namespace_name do
          token Name::Namespace
          pop!
        end

        rule(//) { pop! }
      end

      state :root do
        mixin :comments_and_whitespace

        rule %r/(namespace)(\s+)/ do
          groups Keyword::Declaration, Text
          push :namespace_scope
        end

        rule %r/((?:enum|exception|service|struct|union))(\s+)(#{id})/ do
          groups Keyword::Declaration, Text, Name::Class
        end

        rule %r/"(?:\\.|[^"\\\n])*"/, Str::Double
        rule %r/'(?:\\.|[^'\\\n])*'/, Str::Single

        rule %r/[+-]?0x[0-9a-f]+/i, Num::Hex
        rule double, Num::Float
        rule %r/[+-]?\d+/, Num::Integer

        rule id do |m|
          if self.class.declarations.include?(m[0])
            token Keyword::Declaration
          elsif self.class.keywords.include?(m[0])
            token Keyword
          elsif self.class.types.include?(m[0])
            token Keyword::Type
          elsif self.class.constants.include?(m[0])
            token Keyword::Constant
          else
            token Name
          end
        end

        rule %r/[&=+\-]/, Operator
        rule %r/[:;,{}\(\)<>\[\]]/, Punctuation
      end
    end
  end
end
