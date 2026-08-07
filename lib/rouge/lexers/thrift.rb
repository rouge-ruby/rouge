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

      DECLARATIONS = Set.new %w(
        include cpp_include namespace const typedef enum struct union
        exception service
      )

      KEYWORDS = Set.new %w(
        async cpp_type extends oneway optional required throws
        xsd_all xsd_attrs xsd_nillable xsd_optional
      )

      TYPES = Set.new %w(
        binary bool byte double i8 i16 i32 i64 list map set string uuid void
      )

      CONSTANTS = Set.new %w(false true)

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

        keywords id do
          rule DECLARATIONS, Keyword::Declaration
          rule KEYWORDS, Keyword
          rule TYPES, Keyword::Type
          rule CONSTANTS, Keyword::Constant
          default Name
        end

        rule %r/[&=+\-]/, Operator
        rule %r/[:;,{}\(\)<>\[\]]/, Punctuation
      end
    end
  end
end
