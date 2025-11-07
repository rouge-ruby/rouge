# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Rell < RegexLexer
      title "Rell"
      desc "The Rell programming language (https://docs.chromia.com/rell/rell-intro)"
      tag 'rell'
      filenames '*.rell'
      mimetypes 'text/x-rell'

      def self.keywords
        @keywords ||= %w(
          abstract break class continue create delete else entity enum
          false for function guard if import in include index key limit
          module mutable namespace null object offset operation override
          query record return struct true update val var when while and or not
        )
      end

      def self.builtins
        @builtins ||= %w(
          big_integer boolean byte_array decimal gtv integer json list
          map rowid set text iterable collection unit range tuple virtual
        )
      end

      id = /[a-zA-Z_][a-zA-Z0-9_]*/

      state :root do
        rule %r/\s+/, Text

        # Comments
        rule %r(//.*?$), Comment::Single
        rule %r(/\*), Comment::Multiline, :comment

        # Annotations
        rule %r/@#{id}/, Name::Decorator

        # At-expressions (special operators)
        rule %r/@[*+?]/, Operator
        rule %r/@/, Operator

        # Byte array literals (must come before identifier matching)
        rule %r/x'[0-9a-fA-F]*'/, Str::Other
        rule %r/x"[0-9a-fA-F]*"/, Str::Other

        # Keywords
        rule %r/\b(entity|enum|namespace|object|struct)\b/, Keyword::Declaration
        rule %r/\b(function|operation|query)\b/ do
          token Keyword::Declaration
          push :function_name
        end

        rule id do |m|
          name = m[0]
          if self.class.keywords.include?(name)
            token Keyword
          elsif self.class.builtins.include?(name)
            token Keyword::Type
          else
            token Name
          end
        end

        # String literals
        rule %r/'/, Str::Single, :string_single
        rule %r/"/, Str::Double, :string_double

        # Numeric literals
        # Hexadecimal
        rule %r/-?0[xX][0-9a-fA-F]+/, Num::Hex
        
        # Integers with exponent and L suffix (bigint)
        rule %r/-?\d+[eE][+-]?\d+[lL]/, Num::Integer
        
        # Decimals with exponent (no L suffix)
        rule %r/-?\d+[eE][+-]?\d+/, Num::Float
        
        # Decimal with decimal point
        rule %r/-?\d*\.\d+(?:[eE][+-]?\d+)?/, Num::Float
        
        # Plain integers (with optional L suffix)
        rule %r/-?\d+[lL]?/, Num::Integer

        # Operators (long operators first)
        rule %r/===|!==/, Operator
        rule %r/==|!=|<=|>=/, Operator
        rule %r/\+=|-=|\*=|\/=|%=/, Operator
        rule %r/\+\+|--/, Operator
        rule %r/\?\.|!!|\?:|\?\?/, Operator
        rule %r/->/, Operator
        rule %r/[+\-*\/%<>=!?]/, Operator

        # Special characters
        rule %r/\$/, Operator
        rule %r/\^/, Operator

        # Attribute access
        rule %r/(\.)(\s*)(#{id})/ do
          groups Punctuation, Text, Name::Attribute
        end

        # Punctuation
        rule %r/[{}()\[\];:,.]/, Punctuation
      end

      state :function_name do
        rule %r/\s+/, Text
        rule id, Name::Function, :pop!
        rule(//) { pop! }
      end

      state :comment do
        rule %r(/\*), Comment::Multiline, :comment
        rule %r(\*/), Comment::Multiline, :pop!
        rule %r([^/*]+), Comment::Multiline
        rule %r([/*]), Comment::Multiline
      end

      state :string_double do
        rule %r/[^\\"]+/, Str::Double
        rule %r/\\[\\'"nrtbf]/, Str::Escape
        rule %r/\\u[0-9a-fA-F]{4}/, Str::Escape
        rule %r/\\U[0-9a-fA-F]{8}/, Str::Escape
        rule %r/\\./, Str::Escape
        rule %r/"/, Str::Double, :pop!
      end

      state :string_single do
        rule %r/[^\\']+/, Str::Single
        rule %r/\\[\\'"nrtbf]/, Str::Escape
        rule %r/\\u[0-9a-fA-F]{4}/, Str::Escape
        rule %r/\\U[0-9a-fA-F]{8}/, Str::Escape
        rule %r/\\./, Str::Escape
        rule %r/'/, Str::Single, :pop!
      end
    end
  end
end
