# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Stata < RegexLexer
      title "Stata"
      desc "The Stata programming language (www.stata.com)"
      tag 'stata'
      filenames '*.do', '*.ado'
      mimetypes 'application/x-stata', 'text/x-stata'

      lazy { require_relative 'stata/builtins' }

      start { push :bol }

      state :inline_whitespace do
        rule %r/[ \t]+/, Text::Whitespace
      end

      state :bol do
        mixin :inline_whitespace

        # Multi-line comment: /* and */
        rule %r(/(\\\n)?[*].*?[*](\\\n)?/)m, Comment::Multiline

        keywords %r/[a-z_]+/ do
          rule KEYWORDS, Keyword, :pop!
        end

        # Pre-processor commands: #
        rule %r/#.*\n?/, Comment::Preproc

        rule %r/[*]!.*\n?/, Comment::Hashbang
        rule %r/[*].*\n?/, Comment::Single

        rule(//) { pop! }
      end

      ###
      # Lexer state and rules
      ###
      state :root do
        mixin :inline_whitespace

        # In-line comment: //
        rule %r(//.*\n?), Comment::Single, :bol
        rule %r([\r\n]+), Text, :bol

        # Strings indicated by compound double-quotes (`""') and double-quotes ("")
        rule %r/`"(\\.|.)*?"'/, Str::Double
        rule %r/"(\\.|.)*?"/, Str::Double

        # Format locals (`') and globals ($) as strings
        rule %r/`(\\.|.)*?'/, Str::Double
        rule %r/(?<!\w)\$\w+/, Str::Double

        # Display formats
        rule %r/\%\S+/, Name::Property

        # Additional string types: str1-str2045
        rule %r/\bstr(204[0-5]|20[0-3][0-9]|[01][0-9][0-9][0-9]|[0-9][0-9][0-9]|[0-9][0-9]|[1-9])\b/, Keyword::Type

        # Only recognize primitive functions when they are actually used as a function call, i.e. followed by an opening parenthesis
        # `Name::Builtin` would be more logical, but is not usually highlighted, so use `Name::Function` instead
        keywords %r/\w+(?=[(])/ do
          rule PRIMITIVE_FUNCTIONS, Name::Function
        end

        # Matrix operator `..` (declare here instead of with other operators, in order to avoid conflict with numbers below)
        rule %r/\.\.(?=.*\])/, Operator

        # Numbers
        rule %r/[+-]?(\d+([.]\d+)?|[.]\d+)([eE][+-]?\d+)?/, Num

        # Factor variable and time series operators
        rule %r/\b[ICOicoLFDSlfds]\w*\./, Operator
        rule %r/\b[ICOicoLFDSlfds]\w*(?=\(.*\)\.)/, Operator

        keywords %r/\w+/ do
          rule RESERVED_KEYWORDS, Keyword::Reserved
          rule TYPE_KEYWORDS, Keyword::Type
          default Name
        end

        rule %r/[\[\]{}();,]/, Punctuation

        rule %r([-<>?*+'^/\\!#.=~:&|]), Operator
      end
    end
  end
end
