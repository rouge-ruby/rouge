# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    load_lexer 'json.rb'

    class HOCON < JSON
      title 'HOCON'
      desc "Human-Optimized Config Object Notation (https://github.com/lightbend/config)"
      tag 'hocon'
      filenames '*.hocon'

      prepend :root do
        # Comments
        rule %r(//.*?$), Comment::Single
        rule %r(#.*?$), Comment::Single

        # Interpolation
        rule %r/[$][{][?]?/, Literal::String::Interpol, :interpolation

        # Strings
        rule %r/"""/, Literal::String::Double, :multiline_string

        # Keywords
        rule %r/\b(?:include|url|file|classpath)\b/, Keyword

        # Symbols (only those not handled by JSON)
        rule %r/[()=]/, Punctuation

        # Keys
        rule %r/([\w\-\.]+? *)([{:=]|\+=)/ do
          groups Name::Attribute, Punctuation::Indicator
        end

        # Numbers (handle the case where we have multiple periods, ie. IP addresses)
        rule %r/\d+\.(\d+\.?){3,}/, Literal #

        # Values
        rule %r/[^\$\"{}\[\]:=,\+#`\^\?!@\*&]+?/, Literal
      end

      prepend :string do
        rule %r/[$][{][?]?/, Literal::String::Interpol, :interpolation
        rule %r/[^\\"\${]+/, Literal::String::Double
      end

      state :multiline_string do
        rule %r/"[^"]{1,2}/, Literal::String::Double
        mixin :string
        rule %r/"""/, Literal::String::Double, :pop!
      end

      state :interpolation do
        rule %r/[\w\-\.]+?/, Name::Variable
        rule %r/}/, Literal::String::Interpol, :pop!
      end
    end
  end
end
