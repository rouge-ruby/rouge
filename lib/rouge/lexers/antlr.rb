# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class ANTLR < RegexLexer
      title "ANTLR"
      desc "ANother Tool for Language Recognition"
      tag 'antlr'
      filenames '*.g4'
      def self.keywords
        @keywords ||= Set.new %w(
          catch channel channels finally fragment grammar import lexer locals
          mode more options parser popMode private protected public pushMode
          returns skip throws tokens type
        )
      end
      identifier = %r/[A-Za-z][a-zA-Z0-9_]*/
      integer = %r/0|[1-9][0-9]*/
      parse_rule_name = false
      rule_name = %r/[a-z][a-zA-Z0-9_]*/
      token_name = %r/[A-Z][a-zA-Z0-9_]*/
      state :whitespace do
        rule %r/\s+/, Text
      end
      state :comment_and_whitespace do
        mixin :whitespace
        rule %r(//.*?$), Comment::Single
        rule %r(/\*.*?\*/)m, Comment::Multiline
      end
      state :escape_sequence do
        rule %r/\\./, Str::Escape
      end
      state :string do
        mixin :escape_sequence
        rule %r/'/, Str, :pop!
        rule %r/[^\\'\n]+/, Str
      end
      state :options_spec do
        mixin :comment_and_whitespace
        rule %r/{/, Punctuation
        rule %r/}/, Punctuation, :pop!
        rule %r/=/, Operator, :option_value
        rule identifier, Name::Variable
      end
      state :option_value do
        mixin :comment_and_whitespace
        rule %r/;/, Punctuation, :pop!
        rule %r/./, Punctuation
        rule %r/'/, Str, :string
        rule %r/{/, Punctuation, :action_block
        rule identifier, Name::Constant
        rule integer, Num::Integer
      end
      state :action_block do
        mixin :escape_sequence
        mixin :whitespace
        rule %r/[^\\{}\s]+/, Name::Function
        rule %r/{/, Punctuation, :action_block
        rule %r/}/, Punctuation, :pop!
      end
      state :arg_action_block do
        mixin :escape_sequence
        mixin :whitespace
        rule %r/[^\\\[\]]+/, Str
        rule %r/\]/, Str, :pop!
      end
      state :label do
        mixin :comment_and_whitespace
        rule rule_name, Name::Label, :pop!
      end
      state :root do
        mixin :comment_and_whitespace
        rule %r/'/, Str, :string
        rule %r/[@<>=~\-+?*]/, Operator
        rule %r/[|,.()]/, Punctuation
        rule %r/{/, Punctuation, :action_block
        rule %r/\[/, Str, :arg_action_block
        rule %r/#/, Name::Label, :label
        rule integer, Num::Integer
        rule %r/:/ do
          token Punctuation
          parse_rule_name = false
        end
        rule %r/;/ do
          token Punctuation
          parse_rule_name = true
        end
        rule token_name do
          if parse_rule_name
            token Name::Label
          else
            token Name::Class
          end
        end
        rule rule_name do |m|
          if self.class.keywords.include? m[0]
            token Keyword
            case m[0]
            when 'grammar'
              parse_rule_name = true
            when 'options'
              push :options_spec
            when 'throws'
              parse_rule_name = false
            end
          elsif parse_rule_name
            token Name::Label
          else
            token Name::Variable
          end
        end
      end
    end
  end
end
