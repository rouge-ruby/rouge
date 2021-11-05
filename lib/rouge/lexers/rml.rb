# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
    module Lexers
    class RML < RegexLexer
      title "RML"
      desc "A system agnostic domain specific language for runtime monitoring and verification"
      tag 'rml'
      filenames '*.rml'

      #keywords method
      def self.keywords
        @keywords ||= Set.new %w(
          matches not with empty all if else true false
        )
      end

      #arithmetic_keywords method
      def self.arithmetic_keywords
        @arithmetic_keywords ||= Set.new %w(
          abs sin cos tan min max
        )
      end

      #identifiers
      id_char = /[a-zA-Z0-9_]/
      uppercase_id = /[A-Z]#{id_char}*/
      lowercase_id = /[a-z]#{id_char}*/

      #other
      ellipsis = /(\.){3}/
      int = /[0-9]+/
      float = /#{int}\.#{int}/
      string = /'(\\'|[ a-zA-Z0-9_.])*'/

      #things to ignore
      whitespace = /[ \t\r\n]+/
      comment = /\/\/[^\r\n]*/

      #The following state is an auxiliary one containing rules shared between states
      state :whitespace_and_comments do
        rule %r/#{whitespace}/, Text
        rule %r/#{comment}/, Comment::Single
      end

      state :root do

        mixin :whitespace_and_comments

        rule %r/(#{lowercase_id})(\()/ do
          groups Name::Function, Operator
          push :evTypeParam
        end

        rule %r/#{lowercase_id}/ do |m|
          if m[0] == 'with'
            token Keyword
            push :dataExp
          elsif self.class.keywords.include? m[0]
            token Keyword
          else
            token Name::Function
          end
        end

        rule %r/\(|\{|\[/, Operator, :evTypeParam
        rule %r/#{uppercase_id}/, Name::Class, :equation_blockExp
        rule %r/#{string}/, Literal::String
        rule %r/#{float}/, Num::Float
        rule %r/#{int}/, Num::Integer
        rule %r/[\|;]/, Operator
      end

      state :evTypeParam do

        mixin :whitespace_and_comments

        rule %r/#{string}/, Literal::String
        rule %r/#{float}/, Num::Float
        rule %r/#{int}/, Num::Integer
        rule %r/#{lowercase_id}(?=:)/, Name::Entity

        rule %r/(#{lowercase_id})/ do |m|
        if self.class.keywords.include? m[0]
            token Keyword
          else
            token Literal::String::Regex
          end
        end

        rule %r/\(|\{|\[/, Operator, :push
        rule %r/\)|\}|\]/, Operator, :pop!

        rule %r/#{ellipsis}/, Literal::String::Symbol
        rule %r/[*&%!+\/\\_\|=:,;<>\^-]/, Operator

      end

      state :equation_blockExp do

        mixin :whitespace_and_comments
        rule %r/[<,>]/, Operator
        rule %r/#{lowercase_id}/, Literal::String::Regex

        rule %r(=) do
          token Operator
          goto :exp
        end

        rule %r/;/, Operator, :pop!

      end

      state :exp do
        mixin :whitespace_and_comments

        rule %r/(if)(\()/ do
          groups Keyword, Operator
          push :dataExp
        end

        rule %r/(?:let|var)\b/, Keyword, :equation_blockExp

        rule %r/(#{lowercase_id})(\()/ do
          groups Name::Function, Operator
          push :evTypeParam
        end

        rule %r/(#{lowercase_id})/ do |m|
          if self.class.keywords.include? m[0]
            token Keyword
          else
            token Name::Function
          end
        end

        rule %r/#{uppercase_id}(?=<)/, Name::Class, :dataExp
        rule %r/#{uppercase_id}/, Name::Class

        rule %r/[()*+\/\\_\|=,{}!<>?-]/, Operator
        rule %r/;/, Operator, :pop!

      end

      state :dataExp do

        mixin :whitespace_and_comments

        rule %r/#{lowercase_id}/ do |m|
          if self.class.arithmetic_keywords.include? m[0]
            token Keyword
          else
            token Literal::String::Regex
          end
        end

        rule %r/\(/, Operator, :push
        rule %r/\)/, Operator, :pop!

        rule %r/>(?=\s*else)/, Operator, :pop!
        rule %r/>(?=\s*#{lowercase_id}(?!\())/, Operator
        rule %r/>(?!\s*(=|abs|sin|cos|tan|min|max|true|false|
                    #{float}|#{int}|-|\())/, Operator, :pop!

        rule %r/[*^?!%&\[\]<>\|+=:,.\/\\_-]/, Operator
        rule %r/#{float}/, Num::Float
        rule %r/#{int}/, Num::Integer

        rule %r/;/, Operator, :pop!
      end
    end
    end
end
