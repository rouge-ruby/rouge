# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Brainfuck < RegexLexer
      tag 'brainfuck'
      filenames '*.b', '*.bf'
      mimetypes 'text/x-brainfuck'

      title "Brainfuck"
      desc "The Brainfuck programming language"

      # optional comment or whitespace
      ws = %r((?:\s|[^><\[\]\+\-\.,]*)+)
      id = /[a-zA-Z_][a-zA-Z0-9_]*/

      def self.keywords
        @keywords ||= Set.new %w(
          > < . , [ ] + -
        )
      end

      def self.keywords_type
        @keywords_type ||= Set.new %w(
          
        )
      end

      def self.reserved
        @reserved ||= Set.new %w(
          
        )
      end

      def self.builtins
        @builtins ||= Set.new %w(
          
        )
      end

      start { push :bol }

      state :expr_bol do
        mixin :inline_whitespace

        rule /#if\s0/, Comment, :if_0
        rule /#/, Comment::Preproc, :macro

        rule(//) { pop! }
      end

      # :expr_bol is the same as :bol but without labels, since
      # labels can only appear at the beginning of a statement.
      state :bol do
        rule /#{id}:(?!:)/, Name::Label
        mixin :expr_bol
      end

      state :inline_whitespace do
        rule /[ \t\r]+/, Text
        rule /\\\n/, Text # line continuation
        rule %r(/(\\\n)?[*].*?[*](\\\n)?/)m, Comment::Multiline
      end

      state :whitespace do
        rule /\n+/m, Text, :bol
        rule %r((\\[^><\[\]\+\-\.,]|[^><\[\]\+\-\.,])*?$), Comment::Single, :bol
        mixin :inline_whitespace
      end

      state :expr_whitespace do
        rule /\n+/m, Text, :expr_bol
        mixin :whitespace
      end

      state :statements do
        mixin :whitespace
        rule /(\[|\]|\.|,|\+|\-|<|>)/, Operator
        rule id do |m|
          name = m[0]

          if self.class.keywords.include? name
            token Keyword
          elsif self.class.keywords_type.include? name
            token Keyword::Type
          elsif self.class.reserved.include? name
            token Keyword::Reserved
          elsif self.class.builtins.include? name
            token Name::Builtin
          else
            token Name
          end
        end
      end

      state :case do
      end

      state :root do
        mixin :expr_whitespace

        
        rule(//) { push :statement }
      end

      state :statement do
        mixin :expr_whitespace
        mixin :statements
      end

      state :function do
      end

      state :string do
      end

      state :macro do
      end

      state :if_0 do
      end
    end
  end
end
