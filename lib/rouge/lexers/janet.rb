# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Janet < RegexLexer
      title "Janet"
      desc "The Janet programming language (janet-lang.org)"

      tag 'janet'
      aliases 'jdn'

      filenames '*.janet', '*.jdn'

      mimetypes 'text/x-janet', 'application/x-janet'

      lazy { require_relative 'janet/builtins' }

      punctuation = %r/[_!$%^&*+=~<>.?\/-]/o
      symbol = %r/([[:alpha:]]|#{punctuation})([[:word:]]|#{punctuation}|:)*/o

      state :root do
        rule %r/#.*?$/, Comment::Single
        rule %r/\s+/m, Text::Whitespace

        rule %r/(true|false|nil)\b/, Name::Constant
        rule %r/(['~])(#{symbol})/ do
          groups Operator, Str::Symbol
        end
        rule %r/:([[:word:]]|#{punctuation}|:)*/, Keyword::Constant

        # radix-specified numbers
        rule %r/[+-]?\d{1,2}r[\w.]+(&[+-]?\w+)?/, Num::Float

        # hex numbers
        rule %r/[+-]?0x\h[\h_]*(\.\h[\h_]*)?/, Num::Hex
        rule %r/[+-]?0x\.\h[\h_]*/, Num::Hex

        # decimal numbers (Janet treats all decimals as floats)
        rule %r/[+-]?\d[\d_]*(\.\d[\d_]*)?([e][+-]?\d+)?/i, Num::Float
        rule %r/[+-]?\.\d[\d_]*([e][+-]?\d+)?/i, Num::Float

        rule %r/@?"/, Str::Double, :string
        rule %r/@?(`+).*?\1/m, Str::Heredoc

        rule %r/\(/, Punctuation, :function

        rule %r/(')(@?[(\[{])/ do
          groups Operator, Punctuation
          push :quote
        end

        rule %r/(~)(@?[(\[{])/ do
          groups Operator, Punctuation
          push :quasiquote
        end

        rule %r/[\#~,';\|]/, Operator

        rule %r/@?[(){}\[\]]/, Punctuation

        rule symbol, Name
      end

      state :string do
        rule %r/"/, Str::Double, :pop!
        rule %r/\\(u\h{4}|U\h{6})/, Str::Escape
        rule %r/\\./, Str::Escape
        rule %r/[^"\\]+/, Str::Double
      end

      state :function do
        rule %r/[\)]/, Punctuation, :pop!

        keywords symbol do
          rule(Set['quote']) { token Keyword; goto :quote }
          rule(Set['quasiquote']) { token Keyword; goto :quasiquote }
          rule(SPECIALS) { token Keyword; goto :root }
          rule(BUNDLED) { token Keyword::Reserved; goto :root }
          default { token Name::Function; goto :root }
        end

        mixin :root
      end

      state :quote do
        rule %r/[(\[{]/, Punctuation, :push
        rule %r/[)\]}]/, Punctuation, :pop!
        rule symbol, Str::Escape
        mixin :root
      end

      state :quasiquote do
        rule %r/(,)(\()/ do
          groups Operator, Punctuation
          push :function
        end
        rule %r/(\()(\s*)(unquote)(\s+)(\()/ do
          groups Punctuation, Text, Keyword, Text, Punctuation
          push :function
        end

        rule %r/(,)(#{symbol})/ do
          groups Operator, Name
        end
        rule %r/(\()(\s*)(unquote)(\s+)(#{symbol})/ do
          groups Punctuation, Text, Keyword, Text, Name
        end

        mixin :quote
      end
    end
  end
end
