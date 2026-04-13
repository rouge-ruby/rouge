# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Factor < RegexLexer
      title "Factor"
      desc "Factor, the practical stack language (factorcode.org)"
      tag 'factor'
      filenames '*.factor'
      mimetypes 'text/x-factor'

      KEYWORDS = Set.new %w(deprecated final foldable flushable inline recursive)

      lazy { require_relative 'factor/builtins' }

      def self.detect?(text)
        return true if text.shebang? 'factor'
      end

      state :root do
        rule %r/\s+/m, Text

        rule %r/(:|::|MACRO:|MEMO:|GENERIC:|HELP:)(\s+)(\S+)/m do
          groups Keyword, Text, Name::Function
        end

        rule %r/(M:|HOOK:|GENERIC#)(\s+)(\S+)(\s+)(\S+)/m do
          groups Keyword, Text, Name::Class, Text, Name::Function
        end

        rule %r/\((?=\s)/, Name::Function, :stack_effect
        rule %r/;(?=\s)/, Keyword

        rule %r/(USING:)((?:\s|\\\s)+)/m do
          groups Keyword::Namespace, Text
          push :import
        end

        rule %r/(IN:|USE:|UNUSE:|QUALIFIED:|QUALIFIED-WITH:)(\s+)(\S+)/m do
          groups Keyword::Namespace, Text, Name::Namespace
        end

        rule %r/(FROM:|EXCLUDE:)(\s+)(\S+)(\s+)(=>)/m do
          groups Keyword::Namespace, Text, Name::Namespace, Text, Punctuation
        end

        rule %r/(?:ALIAS|DEFER|FORGET|POSTPONE):/, Keyword::Namespace

        rule %r/(TUPLE:)(\s+)(\S+)(\s+)(<)(\s+)(\S+)/m do
          groups(
            Keyword, Text,
            Name::Class, Text,
            Punctuation, Text,
            Name::Class
          )
          push :slots
        end

        rule %r/(TUPLE:)(\s+)(\S+)/m do
          groups Keyword, Text, Name::Class
          push :slots
        end

        rule %r/(UNION:|INTERSECTION:)(\s+)(\S+)/m do
          groups Keyword, Text, Name::Class
        end

        rule %r/(PREDICATE:)(\s+)(\S+)(\s+)(<)(\s+)(\S+)/m do
          groups(
            Keyword, Text,
            Name::Class, Text,
            Punctuation, Text,
            Name::Class
          )
        end

        rule %r/(C:)(\s+)(\S+)(\s+)(\S+)/m do
          groups(
            Keyword, Text,
            Name::Function, Text,
            Name::Class
          )
        end

        rule %r(
          (INSTANCE|SLOT|MIXIN|SINGLETONS?|CONSTANT|SYMBOLS?|ERROR|SYNTAX
           |ALIEN|TYPEDEF|FUNCTION|STRUCT):
        )x, Keyword

        rule %r/(?:<PRIVATE|PRIVATE>)/, Keyword::Namespace

        rule %r/(MAIN:)(\s+)(\S+)/ do
          groups Keyword::Namespace, Text, Name::Function
        end

        # strings
        rule %r/"(?:\\\\|\\"|[^"])*"/, Str
        rule %r/\S+"\s+(?:\\\\|\\"|[^"])*"/, Str
        rule %r/(CHAR:)(\s+)(\\[\\abfnrstv]*|\S)(?=\s)/, Str::Char

        # comments
        rule %r/!\s+.*$/, Comment
        rule %r/#!\s+.*$/, Comment

        # booleans
        rule %r/[tf](?=\s)/, Name::Constant

        # numbers
        rule %r/-?\d+\.\d+(?=\s)/, Num::Float
        rule %r/-?\d+(?=\s)/, Num::Integer

        rule %r/HEX:\s+[a-fA-F\d]+(?=\s)/m, Num::Hex
        rule %r/BIN:\s+[01]+(?=\s)/, Num::Bin
        rule %r/OCT:\s+[0-7]+(?=\s)/, Num::Oct

        rule %r([-+/*=<>^](?=\s)), Operator

        keywords %r/\S+/ do
          rule KEYWORDS, Keyword
          rule BUILTINS, Name::Builtin
          default Name
        end
      end

      state :stack_effect do
        rule %r/\s+/, Text
        rule %r/\(/, Name::Function, :stack_effect
        rule %r/\)/, Name::Function, :pop!

        rule %r/--/, Name::Function
        rule %r/\S+/, Name::Variable
      end

      state :slots do
        rule %r/\s+/, Text
        rule %r/;(?=\s)/, Keyword, :pop!
        rule %r/\S+/, Name::Variable
      end

      state :import do
        rule %r/;(?=\s)/, Keyword, :pop!
        rule %r/\s+/, Text
        rule %r/\S+/, Name::Namespace
      end
    end
  end
end
