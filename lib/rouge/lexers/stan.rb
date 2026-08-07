# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Stan < RegexLexer
      title "Stan"
      desc 'Stan Modeling Language (mc-stan.org)'
      tag 'stan'
      filenames '*.stan', '*.stanfunctions'

      lazy { require_relative 'stan/keywords' }

      # optional comment or whitespace
      WS = %r((?:\s|//.*?\n|/[*].*?[*]/)+)
      ID = /[a-zA-Z_][a-zA-Z0-9_]*/
      RT = /(?:(?:[a-z_]\s*(?:\[[0-9, ]\])?)\s+)*/
      OP = %r(
        # Assigment operators
        =

        # Comparison operators
        | < | <= | > | >= | == | !=

        # Boolean operators
        | ! | [&][&] | [|][|]

        # Real-valued arithmetic operators
        | [-+*/^]

        # Transposition operator
        | [']

        # Elementwise functions
        | [.][-+*/^]

        # Matrix division operators
        | \\

        # Compound assigment operators
        | (?:[-+*/] | [.][*/])=

        # Sampling
        | [~]

        # Conditional operator
        | [?:]
      )x

      state :root do
        mixin :whitespace
        rule %r/#include/, Comment::Preproc, :include
        rule %r/#.*$/, Generic::Deleted
        rule %r(
          functions
          |(?:transformed\s+)?data
          |(?:transformed\s+)?parameters
          |model
          |generated\s+quantities
        )x, Name::Namespace
        rule %r(\{), Punctuation, :bracket_scope
        mixin :scope
      end

      state :include do
        rule %r((\s+)(\S+)(\s*)) do |m|
          token Text, m[1]
          token Comment::PreprocFile, m[2]
          token Text, m[3]
          pop!
        end
      end

      state :whitespace do
        rule %r(\n+)m, Text
        rule %r(//(\\.|.)*?$), Comment::Single
        mixin :inline_whitespace
      end

      state :inline_whitespace do
        rule %r([ \t\r]+), Text
        rule %r(/(\\\n)?[*].*?[*](\\\n)?/)m, Comment::Multiline
      end

      state :statements do
        mixin :whitespace
        rule %r/#include/, Comment::Preproc, :include
        rule %r/#.*$/, Generic::Deleted
        rule %r("), Str, :string
        rule %r(
          (
            ((\d+[.]\d*|[.]?\d+)e[+-]?\d+|\d*[.]\d+|\d+)
            (#{WS})[+-](#{WS})
            ((\d+[.]\d*|[.]?\d+)e[+-]?\d+|\d*[.]\d+|\d+)i
          )
          |((\d+[.]\d*|[.]?\d+)e[+-]?\d+|\d*[.]\d+|\d+)i
          |((\d+[.]\d*|[.]?\d+)e[+-]?\d+|\d*[.]\d+)
        )mx, Num::Float
        rule %r/\d+/, Num::Integer
        rule %r(\*/), Error
        rule OP, Operator
        rule %r([\[\],.;]), Punctuation
        rule %r([|](?![|])), Punctuation
        rule %r(T\b), Keyword::Reserved
        rule %r((lower|upper)\b), Name::Attribute
        keywords ID do
          rule KEYWORDS, Keyword
          rule TYPES, Keyword::Type
          rule RESERVED, Keyword::Reserved
          default Name
        end
      end

      state :scope do
        mixin :whitespace
        rule %r(
          (#{RT})         # Return type
          (#{ID})         # Function name
          (?=\([^;]*?\))  # Signature or arguments
        )mx do |m|
          recurse m[1]

          name = m[2]
          if BUILTIN_FUNCTIONS.include? name
            token Name::Builtin, name
          elsif DISTRIBUTIONS.include? name
            token Name::Builtin, name
          elsif CONSTANTS.include? name
            token Keyword::Constant
          else
            token Name::Function, name
          end
        end
        rule %r(\{), Punctuation, :bracket_scope
        rule %r(\(), Punctuation, :parens_scope
        mixin :statements
      end

      state :bracket_scope do
        mixin :scope
        rule %r(\}), Punctuation, :pop!
      end

      state :parens_scope do
        mixin :scope
        rule %r(\)), Punctuation, :pop!
      end
    end
  end
end
