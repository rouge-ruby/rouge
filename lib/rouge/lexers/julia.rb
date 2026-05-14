# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Julia < RegexLexer
      title "Julia"
      desc "The Julia programming language"
      tag 'julia'
      aliases 'jl'
      filenames '*.jl'
      mimetypes 'text/x-julia', 'application/x-julia'

      # Documentation: https://docs.julialang.org/en/v1/manual/variables/#Allowed-Variable-Names-1

      def self.detect?(text)
        return true if text.shebang? 'julia'
      end

      lazy { require_relative 'julia/builtins' }


      OPERATORS           = / \+      | =        | -     | \*   | \/
                              | \\    | &        | \|    | \$   | ~
                              | \^    | %        | !     | >>>  | >>
                              | <<    | &&       | \|\|  | \+=  | -=
                              | \*=   | \/=      | \\=   | ÷=   | %=
                              | \^=   | &=       | \|=   | \$=  | >>>=
                              | >>=   | <<=      | ==    | !=   | ≠
                              | <=    | ≤        | >=    | ≥    | \.
                              | ::    | <:       | ->    | \?   | \.\*
                              | \.\^  | \.\\     | \.\/  | \\   | <
                              | >     | ÷        | >:    | :    | ===
                              | !==   | =>
                            /x

      PUNCTUATION         = /[\[\]{}\(\),;]/


      state :root do
        rule %r/\n/, Text
        rule %r/[^\S\n]+/, Text
        rule %r/#=/, Comment::Multiline, :blockcomment
        rule %r/#.*$/, Comment
        rule OPERATORS, Operator
        rule %r/\\\n/, Text
        rule %r/\\/, Text


        # functions and macros
        rule %r/(function|macro)((?:\s|\\\s)+)/ do
          groups Keyword, Name::Function
          push :funcname
        end

        # types
        rule %r/((?:mutable )?struct|(?:abstract|primitive) type)((?:\s|\\\s)+)/ do
          groups Keyword, Name::Class
          push :typename
        end

        # keywords
        # TODO: end is a builtin when inside of an indexing expression
        # TODO: symbols
        keywords %r/\w+/ do
          rule Set['local', 'global', 'const'], Keyword::Declaration
          rule KEYWORDS, Keyword
          rule BUILTINS, Name::Builtin
          rule TYPES, Keyword::Type
        end

        # backticks
        rule %r/`.*?`/, Literal::String::Backtick

        # chars
        rule %r/'(\\.|\\[0-7]{1,3}|\\x[a-fA-F0-9]{1,3}|\\u[a-fA-F0-9]{1,4}|\\U[a-fA-F0-9]{1,6}|[^\\\'\n])'/, Literal::String::Char

        # try to match trailing transpose
        rule %r/(?<=[.\w)\]])\'+/, Operator

        # strings
        # TODO: triple quoted string literals
        # TODO: Detect string interpolation
        rule %r/(?:[IL])"/, Literal::String, :string
        rule %r/[E]?"/, Literal::String, :string

        # names
        rule %r/@[\w.]+/, Name::Decorator
        rule %r/(?:[a-zA-Z_\u00A1-\uffff]|[\u1000-\u10ff])(?:[a-zA-Z_0-9\u00A1-\uffff]|[\u1000-\u10ff])*!*/, Name

        rule PUNCTUATION, Other

        # numbers
        rule %r/(\d+(_\d+)+\.\d*|\d*\.\d+(_\d+)+)([eEf][+-]?[0-9]+)?/, Literal::Number::Float
        rule %r/(\d+\.\d*|\d*\.\d+)([eEf][+-]?[0-9]+)?/, Literal::Number::Float
        rule %r/\d+(_\d+)+[eEf][+-]?[0-9]+/, Literal::Number::Float
        rule %r/\d+[eEf][+-]?[0-9]+/, Literal::Number::Float
        rule %r/0b[01]+(_[01]+)+/, Literal::Number::Bin
        rule %r/0b[01]+/, Literal::Number::Bin
        rule %r/0o[0-7]+(_[0-7]+)+/, Literal::Number::Oct
        rule %r/0o[0-7]+/, Literal::Number::Oct
        rule %r/0x[a-fA-F0-9]+(_[a-fA-F0-9]+)+/, Literal::Number::Hex
        rule %r/0x[a-fA-F0-9]+/, Literal::Number::Hex
        rule %r/\d+(_\d+)+/, Literal::Number::Integer
        rule %r/\d+/, Literal::Number::Integer
      end

      NAME_RE = %r/[\p{L}\p{Nl}\p{S}_][\p{Word}\p{S}\p{Po}!]*/

      state :funcname do
        rule NAME_RE, Name::Function, :pop!
        rule %r/\([^\s\w{]{1,2}\)/, Operator, :pop!
        rule %r/[^\s\w{]{1,2}/, Operator, :pop!
      end

      state :typename do
        rule NAME_RE, Name::Class, :pop!
      end

      state :stringescape do
        rule %r/\\([\\abfnrtv"\']|\n|N\{.*?\}|u[a-fA-F0-9]{4}|U[a-fA-F0-9]{8}|x[a-fA-F0-9]{2}|[0-7]{1,3})/,
          Literal::String::Escape
      end

      state :blockcomment do
        rule %r/[^=#]/, Comment::Multiline
        rule %r/#=/, Comment::Multiline, :blockcomment
        rule %r/\=#/, Comment::Multiline, :pop!
        rule %r/[=#]/, Comment::Multiline
      end

      state :string do
        mixin :stringescape

        rule %r/"/, Literal::String, :pop!
        rule %r/\\\\|\\"|\\\n/, Literal::String::Escape  # included here for raw strings
        rule %r/\$(\(\w+\))?[-#0 +]*([0-9]+|[*])?(\.([0-9]+|[*]))?/, Literal::String::Interpol
        rule %r/[^\\"$]+/, Literal::String
        # quotes, dollar signs, and backslashes must be parsed one at a time
        rule %r/["\\]/, Literal::String
        # unhandled string formatting sign
        rule %r/\$/, Literal::String
      end
    end
  end
end
