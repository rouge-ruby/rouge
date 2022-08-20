# -*- coding: utf-8 -*- #
# frozen_string_literal: true


module Rouge
  module Lexers
    class JQ < RegexLexer
      title 'jq'
      desc 'The jq programming language (https://stedolan.github.io/jq/)'
      tag 'jq'
      filenames "*.jq"

      def self.keywords
        @keywords ||= Set.new %w(as import include module def if then else elif end reduce foreach try catch label break __loc__)
      end

      def self.word_operators
        @word_operators ||= Set.new %w(and or)
      end

      state :root do
        rule %r/#.*/, Comment::Single

        rule %r(((\||\+|\-|\*|/|%|//)=|=)), Operator
        rule %r((\!=|==|//|\<=|\>=|\?//|\+|\-|\*|\/|\%|\<|\>|\?|\.\.)), Operator

        rule %r/(;|:|\||::|,)/, Punctuation
        rule %r/([\[\(\{\}\)\]])/, Punctuation

        rule %r/@[a-zA-Z0-9_]+/, Name::Function::Magic

        rule %r/\.[a-zA-Z_][a-zA-Z_0-9]*/ do |m|
          token Name::Attribute
        end
        rule %r/\./, Name::Attribute

        rule %r/\$[a-zA-Z_][a-zA-Z_0-9]*/ do |m|
          token Name::Variable
        end

        rule %r/[a-zA-Z_][a-zA-Z_0-9]*/ do |m|
          if self.class.word_operators.include?(m[0])
            token Operator::Word
          elsif self.class.keywords.include?(m[0])
            token Keyword
          else
            token Name
          end
        end

        rule %r/[0-9.]+([eE][+-]?[0-9]+)?/, Literal::Number
        rule %r/\"/, Literal::String, :string

        rule %r/\s+/, Text
      end

      state :string do
        rule %r/[^"\\]+/, Literal::String
        rule %r/\\"/, Literal::String::Double
        rule %r/(\\[^u(]|\\u[a-zA-Z0-9]{0,4})/, Literal::String::Escape
        rule %r/\\\(/, Punctuation, :string_interpolation
        rule %r/"/, Literal::String, :pop!
      end

      state :string_interpolation do
        rule %r/\)/, Punctuation, :pop!
        mixin :root
      end
    end
  end
end
