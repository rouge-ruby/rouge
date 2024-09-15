# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
    module Lexers
      # Lexer for the Gleam programming language (https://gleam.run/)
      class Gleam < RegexLexer
        title 'Gleam'
        desc 'The Gleam programming language (https://gleam.run/)'
        tag 'gleam'
        filenames '*.gleam'
        mimetypes 'text/x-gleam'
  
        # Character sets
        ID = /[a-z_][a-zA-Z0-9_]*/.freeze
        TYPE_ID = /[A-Z][a-zA-Z0-9_]*/.freeze
        MODULE_METHOD_CALL = %r{([a-z_][a-zA-Z0-9_]*)(\.)([a-zA-Z_][a-zA-Z0-9_]*)}.freeze
        WHITESPACE = /\s+/.freeze
        NEWLINE = /\n/.freeze
  
        # Keywords, built-ins, constants
        KEYWORDS_LIST = %w[
          as assert case const external fn if import let opaque pub todo try type use
          module else panic test
        ].freeze
  
        KEYWORDS = %r{\b(?:#{KEYWORDS_LIST.join('|')})\b}.freeze
  
        BUILTINS_LIST = %w[
          Int Float Bool String List Result Option Iterator
        ].freeze
  
        BUILTINS = %r{\b(?:#{BUILTINS_LIST.join('|')})\b}.freeze
  
        CONSTANTS = %r{\b(?:Nil|Ok|Error|Stop|Continue|True|False)\b}.freeze
  
        BIT_STRING_KEYWORDS_LIST = %w[
          binary bits bytes int float bit_string bit_array utf8 utf16 utf32
          utf8_codepoint utf16_codepoint utf32_codepoint signed unsigned big little
          native unit size
        ].freeze
  
        BIT_STRING_KEYWORDS = %r{\b(?:#{BIT_STRING_KEYWORDS_LIST.join('|')})\b}.freeze
  
        # Operators and punctuation
        OPERATORS = %r{>>|<<|\|\||&&|==|!=|<=|>=|->|=>|<-|<>|\|>|[-+\/*%=!<>&|^~]}.freeze
        PUNCTUATION = /[()\[\]{}.,:;]/.freeze
  
        # Numbers
        BINARY_NUMBER = /\b0b[01](?:_?[01]+)*\b/.freeze
        OCTAL_NUMBER = /\b0o[0-7](?:_?[0-7]+)*\b/.freeze
        HEX_NUMBER = /\b0x[0-9a-fA-F](?:_?[0-9a-fA-F]+)*\b/.freeze
        FLOAT_NUMBER = /\b\d[\d_]*\.\d[\d_]*(e[+-]?\d[\d_]*)?\b/.freeze
        INTEGER_NUMBER = /\b\d[\d_]*\b/.freeze
  
        # Strings
        DOUBLE_QUOTED_STRING = %r{"(\\\\|\\"|[^"])*"}.freeze
        SINGLE_QUOTED_STRING = %r{'(\\\\|\\'|[^'])*'}.freeze
        ESCAPE_SEQUENCE = %r{\\[nrt\\"'0]}.freeze
  
        # Comments
        LINE_COMMENT = %r{//.*?$}.freeze
  
        state :root do
          mixin :simple_tokens
  
          # Raw strings (backticks)
          rule %r{`}, Str::Backtick, :raw_string
  
          # Triple-quoted strings
          rule %r{"""}, Str::Double, :triple_string
  
          # Double-quoted strings
          rule %r{"}, Str::Double, :string
  
          # Single-quoted strings (characters)
          rule %r{'}, Str::Char, :char
  
          # Bit arrays
          rule %r{<<}, Operator, :bitarray
        end
  
        state :simple_tokens do
          # Whitespace and newline
          rule WHITESPACE, Text::Whitespace
          rule NEWLINE, Text
  
          # Comments
          rule LINE_COMMENT, Comment::Single
  
          # Keywords, built-ins, constants
          rule KEYWORDS, Keyword
          rule BUILTINS, Name::Builtin
          rule CONSTANTS, Name::Constant
  
          # Type names (user-defined)
          rule %r{\b#{TYPE_ID}\b}, Name::Class
  
          # Function definitions
          rule %r{(\b(?:pub\s+)?fn\b)(\s+)(#{ID}) } do
            groups Keyword, Text::Whitespace, Name::Function
          end
  
          # Module and method calls (e.g., list.map)
          rule MODULE_METHOD_CALL do
            groups Name::Namespace, Punctuation, Name::Function
          end
  
          # Function calls
          rule %r{(#{ID})(\s*)(\() } do
            groups Name::Function, Text::Whitespace, Punctuation
            push :func_call_params
          end
  
          # Module-qualified function calls
          rule %r{(#{ID})(\.)(#{ID})(\s*)(\() } do
            groups Name::Namespace, Punctuation, Name::Function, Text::Whitespace, Punctuation
            push :func_call_params
          end
  
          # Identifiers (variables, fields)
          rule %r{\b#{ID}\b}, Name::Variable
  
          # Discard names (e.g., _var)
          rule %r{\b_[a-z][a-zA-Z0-9_]*\b}, Name::Builtin::Pseudo
  
          # Operators and punctuation
          rule OPERATORS, Operator
          rule PUNCTUATION, Punctuation
  
          # Numbers
          rule BINARY_NUMBER, Num::Bin
          rule OCTAL_NUMBER, Num::Oct
          rule HEX_NUMBER, Num::Hex
          rule FLOAT_NUMBER, Num::Float
          rule INTEGER_NUMBER, Num::Integer
  
          # Strings and escape sequences
          rule ESCAPE_SEQUENCE, Str::Escape
  
          # Attributes
          rule %r{[@]#{ID}}, Name::Decorator
        end
  
        # Function call parameters
        state :func_call_params do
          rule %r{\)}, Punctuation, :pop!
          rule %r{[^)]+}, Text
        end
  
        # Raw strings
        state :raw_string do
          rule %r{[^`]+}, Str::Backtick
          rule %r{`}, Str::Backtick, :pop!
        end
  
        # Triple-quoted strings
        state :triple_string do
          rule %r{"""}, Str::Double, :pop!
          rule %r{[^"]+}, Str::Double
          rule %r{"}, Str::Double
        end
  
        # Single-line strings
        state :string do
          rule %r{[^"\\]+}, Str::Double
          rule %r{\\[\\"]}, Str::Escape
          rule %r{"}, Str::Double, :pop!
        end
  
        # Character literals
        state :char do
          rule %r{[^'\\]+}, Str::Char
          rule %r{\\[\\']}, Str::Escape
          rule %r{'}, Str::Char, :pop!
        end
  
        # Bit arrays
        state :bitarray do
          rule %r{>>}, Operator, :pop!
          rule WHITESPACE, Text::Whitespace
          rule BIT_STRING_KEYWORDS, Keyword
          rule %r{[^>]+}, Text
        end
      end
    end
  end
  