# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Dylan < RegexLexer
      title 'Dylan'
      desc 'Dylan Language'
      tag 'dylan'
      filenames '*.dylan'

      # Definitions from the Dylan Reference Manual
      # see:
      # https://opendylan.org/books/drm/Modules
      # https://opendylan.org/books/drm/Conditional_Execution
      # https://opendylan.org/books/drm/Statement_Macros
      reserved_words = Set.new %w(
        begin block case class constant create define domain else
        end exception for function generic handler if let library local
        macro method module otherwise select unless until variable while
      )

      hash_word = Set.new %w(#t #f #next #rest #key #all-keys #include)
      operators = Set.new %w(+ - * / ^ = == ~ ~= ~== < <= > >= & | :=)

      state :root do
        rule %r/^[\w.-]+:/, Comment::Preproc, :header
        rule %r/\s+/, Text::Whitespace
        rule(%r//) { goto :main }
      end

      # see https://opendylan.org/books/drm/Dylan_Interchange_Format
      state :header do
        rule(/.*?$/) { token Comment; goto :header_value }
      end

      state :header_value do
        # line continuations are defined as any line that starts with whitespace
        rule %r/^[ \t]+.*?$/, Comment
        rule %r/\n+/, Comment
        rule(//) { pop! }
      end

      state :main do
        # Comments
        rule %r(//.*?$), Comment::Single
        rule %r(/\*.*?\*/)m, Comment::Multiline
        rule %r/\s+/, Text::Whitespace

        # Keywords
        rule %r/\w+/ do |m|
          if reserved_words.include?(m[0])
            token Keyword
          elsif hash_word.include?(m[0])
            token Keyword::Constant
          else
            fallthrough!
          end
        end

        rule %r/#(t|f|next|rest|key|all-keys|include)\b/, Keyword::Constant

        # Numbers
        rule %r([+-]?\d+/\d+), Literal::Number::Other
        rule %r/[+-]?\d*[.]\d+(?:e[+-]?\d+)?/i, Literal::Number::Float
        rule %r/[+-]?\d+[.]\d*(?:e[+-]?\d+)?/i, Literal::Number::Float
        rule %r/[+-]\d+(?:e[+-]?\d+)?/i, Literal::Number::Float
        rule %r/#b[01]+/, Literal::Number::Bin
        rule %r/#o[0-7]+/, Literal::Number::Oct
        rule %r/[+-]?[0-9]+/, Literal::Number::Integer
        rule %r/#x[0-9a-f]+/i, Literal::Number::Hex

        # Names
        rule %r/[-]/, Operator

        # Operators and punctuation
        rule %r/::|=>|#[(\[#]|[.][.][.]|[(),.;\[\]{}=?]/, Punctuation

        rule %r([\w!&*<>|^\$%@][\w!&*<>|^\$%@=/?~+-]*) do |m|
          word = m[0]
          if operators.include?(m[0])
            token Operator
          elsif word.start_with?('<') && word.end_with?('>')
            token Name::Class
          elsif word.start_with?('*') && word.end_with?('*')
            token Name::Variable::Instance
          elsif word.start_with?('$')
            token Name::Constant
          else
            token Name
          end
        end

        rule %r/:/, Operator # For 'constrained names'
        # Strings, characters and whitespace
        rule %r/"/, Str::Double, :dq
        rule %r/'([^\\']|(\\[\\'abefnrt0])|(\\[0-9a-f]+))'/, Str::Char
      end

      state :dq do
        rule %r/\\[\\'"abefnrt0]/, Str::Escape
        rule %r/[^\\"]+/, Str::Double
        rule %r/"/, Str::Double, :pop!
      end
    end
  end
end
