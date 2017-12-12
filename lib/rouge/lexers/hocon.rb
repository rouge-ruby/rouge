# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class HOCON < RegexLexer
      title 'HOCON'
      desc "Human-Optimized Object Configuration Notation (https://github.com/lightbend/config)"
      tag 'hocon'
      filenames '*.hocon'

      keywords = %w(include url file classpath)
      keys = '[\w\-\.]+?'
      values = '[^\$\"{}\[\]:=,\+#`\^\?!@\*&]+?'

      state :root do
        # Whitespaces
        rule /\s+/m, Text::Whitespace

        # Comments
        rule %r(//.*?$), Comment::Single
        rule %r(#.*?$), Comment::Single

        # Interpolation
        rule /[$][{][?]?/, Literal::String::Interpol, :in_interpolation

        # Strings
        rule /"""/, Literal::String::Double, :multiline_string
        rule /"/, Literal::String::Double, :singleline_string

        # Keywords
        rule /\b(?:#{keywords.join('|')})\b/, Keyword

        # Constants
        rule /(?:true|false|null)\b/, Keyword::Constant

        # Symbols
        rule /[()={},:\[\]]/, Punctuation

        # Keys
        rule /(#{keys} ?)([{:=]|\+=)/ do
          groups Name::Attribute, Punctuation::Indicator
        end

        # Numbers
        rule /\d+\.(\d+\.?){3,}/, Literal # Handle the case where we multiple periods (ie. IP addresses)
        rule /\d+([.]\d+)(e[+-]\d+)?/, Literal::Number::Float
        rule /\d+?(e[+-]\d+)?/, Literal::Number

        # Values
        rule /#{values}/, Literal
      end

      state :multiline_string do
        rule /"[^"]{1,2}/, Literal::String::Double
        mixin :in_string
        rule /"""/, Literal::String::Double, :pop!
      end

      state :singleline_string do
        mixin :in_string
        rule /"/, Literal::String::Double, :pop!
      end

      state :in_string do
        rule /[$][{][?]?/, Literal::String::Interpol, :in_interpolation
        rule /[^\\"\${]+/, Literal::String::Double
        rule /\\./, Literal::String::Escape
      end

      state :in_interpolation do
        rule /#{keys}/, Name::Attribute
        rule /}/, Literal::String::Interpol, :pop!
      end
    end
  end
end
