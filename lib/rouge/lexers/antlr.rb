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
      get_label = true
      identifier = %r/[A-Za-z][a-zA-Z0-9_]*/
      integer = %r/0|[1-9][0-9]*/
      lowercase_name = %r/[a-z][a-zA-Z0-9_]*/
      uppercase_name = %r/[A-Z][a-zA-Z0-9_]*/
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
        rule identifier, Name::Attribute
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
        rule lowercase_name, Name::Label, :pop!
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
          get_label = false
        end
        rule %r/;/ do
          token Punctuation
          get_label = true
        end
        rule uppercase_name do
          if get_label
            token Name::Label
          else
            token Name::Class
          end
        end
        rule lowercase_name do |m|
          if self.class.keywords.include? m[0]
            token Keyword
            case m[0]
            when 'options'
              push :options_spec
            when 'throws'
              get_label = false
            end
          elsif get_label
            token Name::Label
          else
            token Name::Variable
          end
        end
      end
    end
  end
end
