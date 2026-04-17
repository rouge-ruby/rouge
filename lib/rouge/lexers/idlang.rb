# -*- coding: utf-8 -*- #
# frozen_string_literal: true

# vim: set ts=2 sw=2 et:

module Rouge
  module Lexers
    class IDLang < RegexLexer
      title "IDL"
      desc "Interactive Data Language"

      tag 'idlang'
      filenames '*.idl'

      name = /[_A-Z]\w*/i
      kind_param = /(\d+|#{name})/
      exponent = /[dDeE][+-]\d+/

      lazy { require_relative 'idlang/builtins' }

      state :root do
        rule %r/\s+/, Text::Whitespace
        # Normal comments
        rule %r/;.*$/, Comment::Single
        rule %r/\,\s*\,/, Error
        rule %r/\!#{name}/, Name::Variable::Global

        rule %r/[(),:\&\$]/, Punctuation

        ## Format statements are quite a strange beast.
        ## Better process them in their own state.
        #rule %r/\b(FORMAT)(\s*)(\()/mi do |m|
        #  token Keyword, m[1]
        #  token Text::Whitespace, m[2]
        #  token Punctuation, m[3]
        #  push :format_spec
        #end

        rule %r(
          [+-]? # sign
          (
            (\d+[.]\d*|[.]\d+)(#{exponent})?
            | \d+#{exponent} # exponent is mandatory
          )
          (_#{kind_param})? # kind parameter
        )xi, Num::Float

        rule %r/\d+(B|S|U|US|LL|L|ULL|UL)?/i, Num::Integer
        rule %r/"[0-7]+(B|O|U|ULL|UL|LL|L)?/i, Num::Oct
        rule %r/'[0-9A-F]+'X(B|S|US|ULL|UL|U|LL|L)?/i, Num::Hex
        rule %r/(#{kind_param}_)?'/, Str::Single, :string_single
        rule %r/(#{kind_param}_)?"/, Str::Double, :string_double

        rule %r{\#\#|\#|\&\&|\|\||/=|<=|>=|->|\@|\?|[-+*/<=~^{}]}, Operator
        # Structures and the like
        rule %r/(#{name})(\.)([^\s,]*)/i do
          groups Name, Operator, Name
          #delegate IDLang, m[3]
        end

        rule %r/(function|pro)((?:\s|\$\s)+)/i do
          groups Keyword, Text::Whitespace
          push :funcname
        end

        rule %r((?:AND|EQ|GE|GT|LE|LT|MOD|NE|OR|XOR|NOT)=), Operator

        keywords %r/#{name}=?/m do
          transform(&:upcase)

          rule KEYWORDS, Keyword
          rule CONDITIONALS, Keyword
          rule DECORATORS, Keyword
          rule STANDALONE_STATEMENTS, Keyword::Reserved
          rule ROUTINES, Name::Builtin

          default Name
        end

      end

      state :funcname do
        rule %r/#{name}/, Name::Function

        rule %r/\s+/, Text::Whitespace
        rule %r/(:+|\$)/, Operator
        rule %r/;.*/, Comment::Single

        # Be done with this state if we hit EOL or comma
        rule %r/$/, Text::Whitespace, :pop!
        rule %r/,/, Operator, :pop!
      end

      state :string_single do
        rule %r/[^']+/, Str::Single
        rule %r/''/, Str::Escape
        rule %r/'/, Str::Single, :pop!
      end

      state :string_double do
        rule %r/[^"]+/, Str::Double
        rule %r/"/, Str::Double, :pop!
      end

      state :format_spec do
        rule %r/'/, Str::Single, :string_single
        rule %r/"/, Str::Double, :string_double
        rule %r/\(/, Punctuation, :format_spec
        rule %r/\)/, Punctuation, :pop!
        rule %r/,/, Punctuation
        rule %r/\s+/, Text::Whitespace
        # Edit descriptors could be seen as a kind of "format literal".
        rule %r/[^\s'"(),]+/, Literal
      end
    end
  end
end
