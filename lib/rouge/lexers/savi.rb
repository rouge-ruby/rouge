# -*- coding: utf-8 -*- #
# frozen_string_literal: true

# The canonical version of this file can be found in the following repository,
# where it is kept in sync with any language changes, as well as the other
# rouge-like lexers that are maintained for use with other tools:
# - https://github.com/savi-lang/savi/blob/main/tooling/rouge/lexers/savi.rb
#
# If you're changing this file in the rouge repository, please ensure that
# any changes you make are also propagated to the official Savi repository,
# in order to avoid accidental clobbering of your changes later when an update
# from the Savi repository flows forward into the rouge repository.
#
# If you're changing this file in the Savi repository, please ensure that
# any changes you make are also reflected in the other rouge-like lexers
# (pygments, vscode, etc) so that all of the lexers can be kept cleanly in sync.

module Rouge
  module Lexers
    class Savi < RegexLexer
      desc 'The Savi programming language (https://github.com/savi-lang/savi)'
      tag 'savi'
      filenames '*.savi'
      mimetypes 'text/x-savi', 'application/x-savi'

      state :root do
        # Line Comment
        rule %r{//.*?$}, Comment::Single

        # Doc Comment
        rule %r{::.*?$}, Comment::Single

        # Capability Operator
        rule %r{(\')(\w+)(?=[^\'])} do
          groups Operator, Name
        end

        # Double-Quote String
        rule %r{\w?"}, Str::Double, :string_double

        # Single-Char String
        rule %r{'}, Str::Char, :string_char

        # Class (or other type)
        rule %r{([_A-Z]\w*)}, Name::Class

        # Declare
        rule %r{^(\s*)(:)(\w+)} do
          groups Text, Name::Tag, Name::Tag
          push :decl
        end

        # Error-Raising Calls/Names
        rule %r{((\w+|\+|\-|\*)\!)}, Generic::Deleted

        # Numeric Values
        rule %r{\b\d([\d_]*(\.[\d_]+)?)\b}, Num

        # Hex Numeric Values
        rule %r{\b0x([0-9a-fA-F_]+)\b}, Num::Hex

        # Binary Numeric Values
        rule %r{\b0b([01_]+)\b}, Num::Bin

        # Function Call (with braces)
        rule %r{(\w+(?:\?|\!)?)(?=\()}, Name::Function

        # Function Call (with receiver)
        rule %r{(?<=\.)(\w+(?:\?|\!)?)}, Name::Function

        # Function Call (with self receiver)
        rule %r{(?<=@)(\w+(?:\?|\!)?)}, Name::Function

        # Parenthesis
        rule %r{\(}, Punctuation, :root
        rule %r{\)}, Punctuation, :pop!

        # Brace
        rule %r{\{}, Punctuation, :root
        rule %r{\}}, Punctuation, :pop!

        # Bracket
        rule %r{\[}, Punctuation, :root
        rule %r{(\])(\!)} do
          groups Punctuation, Generic::Deleted
          pop!
        end
        rule %r{\]}, Punctuation, :pop!

        # Punctuation
        rule %r{[,;:\.@]}, Punctuation

        # Piping Operators
        rule %r{(\|\>)}, Operator

        # Branching Operators
        rule %r{(\&\&|\|\||\?\?|\&\?|\|\?|\.\?)}, Operator

        # Comparison Operators
        rule %r{(\<\=\>|\=\~|\=\=|\<\=|\>\=|\<|\>)}, Operator

        # Arithmetic Operators
        rule %r{(\+|\-|\/|\*|\%)}, Operator

        # Assignment Operators
        rule %r{(\=)}, Operator

        # Other Operators
        rule %r{(\!|\<\<|\<|\&|\|)}, Operator

        # Identifiers
        rule %r{\b\w+\b}, Name

        # Whitespace
        rule %r{\s+}, Text
      end

      # Declare (nested rules)
      state :decl do
        rule %r{\b[a-z_]\w*\b(?!\!)}, Keyword::Declaration
        rule %r{:}, Punctuation, :pop!
        rule %r{\n}, Text, :pop!
        mixin :root
      end

      # Double-Quote String (nested rules)
      state :string_double do
        rule %r/\\u[0-9a-fA-F]{4}/, Str::Escape
        rule %r/\\x[0-9a-fA-F]{2}/, Str::Escape
        rule %r{\\[bfnrt\\"]}, Str::Escape
        rule %r{\\"}, Str::Escape
        rule %r{"}, Str::Double, :pop!
        rule %r{[^\\"]+}, Str::Double
        rule %r{.}, Error
      end

      # Single-Char String (nested rules)
      state :string_char do
        rule %r/\\u[0-9a-fA-F]{4}/, Str::Escape
        rule %r/\\x[0-9a-fA-F]{2}/, Str::Escape
        rule %r{\\[bfnrt\\"]}, Str::Escape
        rule %r{\\'}, Str::Escape
        rule %r{'}, Str::Char, :pop!
        rule %r{[^\\']+}, Str::Char
        rule %r{.}, Error
      end
    end
  end
end
