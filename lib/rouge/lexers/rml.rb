# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class RML < RegexLexer
      title "RML"
      desc "A system agnostic domain-specific language for runtime monitoring and verification (https://rmlatdibris.github.io/)"
      tag 'rml'
      filenames '*.rml'

      KEYWORDS = Set.new %w(
        matches not with empty
        all if else true false
      )

      ARITHMETIC_KEYWORDS = Set.new %w(
        abs sin cos tan min max
      )

      id_char = /[a-zA-Z0-9_]/
      uppercase_id = /[A-Z]#{id_char}*/
      lowercase_id = /[a-z]#{id_char}*/

      ellipsis = /(\.){3}/
      int = /[0-9]+/
      float = /#{int}\.#{int}/
      string = /'(\\'|[ a-zA-Z0-9_.])*'/

      whitespace = /[ \t\r\n]+/
      comment = /\/\/[^\r\n]*/

      state :common_rules do
        rule whitespace, Text
        rule comment, Comment::Single
        rule string, Literal::String
        rule float, Num::Float
        rule int, Num::Integer
      end

      state :root do
        mixin :common_rules
        rule %r/(#{lowercase_id})(\()/ do
          groups Name::Function, Operator
          push :event_type_params
        end

        keywords lowercase_id do
          rule Set['with'], Keyword, :data_expression_with
          rule KEYWORDS, Keyword
          default Name
        end

        rule %r/\(|\{|\[/, Operator, :event_type_params
        rule %r/[_\|]/, Operator
        rule uppercase_id, Name::Class, :equation_block_expression
        rule %r/;/, Operator
      end

      state :event_type_params do
        mixin :common_rules
        rule %r/\(|\{|\[/, Operator, :push
        rule %r/\)|\}|\]/, Operator, :pop!
        rule %r/#{lowercase_id}(?=:)/, Name::Attribute
        keywords lowercase_id do
          rule KEYWORDS, Keyword
          default Name
        end
        rule ellipsis, Str::Symbol
        rule %r/[_\|;,:]/, Operator
      end

      state :equation_block_expression do
        mixin :common_rules
        rule %r/[<,>]/, Operator
        rule lowercase_id, Str::Regex
        rule %r/=/ do
          token Operator
          goto :exp
        end
        rule %r/;/, Operator, :pop!
      end

      state :exp do
        mixin :common_rules
        rule %r/(if)(\()/ do
          groups Keyword, Operator
          push :data_expression
        end
        rule %r/let|var/, Keyword, :equation_block_expression
        rule %r/(#{lowercase_id})(\()/ do
          groups Name::Function, Operator
          push :event_type_params
        end

        keywords lowercase_id do
          rule KEYWORDS, Keyword
          default Name
        end

        rule %r/#{uppercase_id}(?=<)/, Name::Class, :data_expression
        rule uppercase_id, Name::Class
        rule %r/[=(){}*+\/\\\|!>?]/, Operator
        rule %r/;/, Operator, :pop!
      end

      state :data_expression do
        mixin :common_rules
        keywords lowercase_id do
          rule ARITHMETIC_KEYWORDS, Keyword
          rule KEYWORDS, Keyword
          default Name
        end

        rule %r/\(/, Operator, :push
        rule %r/\)/, Operator, :pop!
        rule %r/(>)(?=[^A-Z;]+[A-Z;>])/, Operator, :pop!
        rule %r/[*^?!%&\[\]<>\|+=:,.\/\\_-]/, Operator
        rule %r/;/, Operator, :pop!
      end

      state :data_expression_with do
        mixin :common_rules
        rule %r/>/, Operator
        mixin :data_expression
      end
    end
  end
end
