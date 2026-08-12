# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Dart < RegexLexer
      title "Dart"
      desc "The Dart programming language (dart.dev)"

      tag 'dart'
      filenames '*.dart'
      mimetypes 'text/x-dart'

      KEYWORDS = Set.new %w(
        as assert await break case catch continue default do else finally for if
        in is new rethrow return super switch this throw try while when with yield
      )

      DECLARATIONS = Set.new %w(
        abstract base async dynamic const covariant external extends
        factory final get implements interface late native on
        operator required sealed set static sync typedef var
      )

      TYPES = Set.new %w(
        bool Comparable double Dynamic enum Function int List Map
        Never Null num Object Pattern Record Set String Symbol Type
        Uri void
      )

      IMPORTS = Set.new %w(import deferred export library part source)

      id = /[a-zA-Z_]\w*/

      state :root do
        rule %r(^
          (\s*(?:[a-zA-Z_][a-zA-Z\d_.\[\]]*\s+)+?) # return arguments
          ([a-zA-Z_]\w*)                           # method name
          (\s*)(\()                                # signature start
        )mx do |m|
          # TODO: do this better, this shouldn't need a delegation
          delegate Dart, m[1]
          token Name::Function, m[2]
          token Text, m[3]
          token Punctuation, m[4]
        end

        rule %r/\s+/, Text
        rule %r(//.*?$), Comment::Single
        rule %r(/\*.*?\*/)m, Comment::Multiline
        rule %r/"/, Str, :dqs
        rule %r/'/, Str, :sqs
        rule %r/r""".*?"""/m, Str::Other
        rule %r/r'''.*?'''/m, Str::Other
        rule %r/r"[^"]*"/, Str::Other
        rule %r/r'[^']*'/, Str::Other
        rule %r/##{id}*/i, Str::Symbol
        rule %r/@#{id}/, Name::Decorator
        rule %r/part\s*of\b/, Keyword::Namespace, :import

        keywords id do
          rule KEYWORDS, Keyword
          rule DECLARATIONS, Keyword::Declaration
          rule TYPES, Keyword::Type
          rule Set['true', 'false', 'nil'], Keyword::Constant
          rule Set['class', 'mixin'], Keyword::Declaration, :class
          rule IMPORTS, Keyword::Namespace, :import
        end

        rule %r/(\.)(#{id})/ do
          groups Operator, Name::Attribute
        end

        rule %r/#{id}:/, Name::Label
        rule %r/\$?#{id}/, Name
        rule %r/[~^*!%&\|+=:\/?-]/, Operator
        rule %r/[\[\](){}<>\.,;]/, Punctuation
        rule %r/\d*\.\d+([eE]\-?\d+)?/, Num::Float
        rule %r/0x[\da-fA-F]+/, Num::Hex
        rule %r/\d+L?/, Num::Integer
        rule %r/\n/, Text
      end

      state :class do
        rule %r/\s+/m, Text
        rule id, Name::Class, :pop!
      end

      state :dqs do
        rule %r/"/, Str, :pop!
        rule %r/[^\\\$"]+/, Str
        mixin :string
      end

      state :sqs do
        rule %r/'/, Str, :pop!
        rule %r/[^\\\$']+/, Str
        mixin :string
      end

      state :import do
        rule %r/;/, Operator, :pop!
        rule %r/(?:show|hide)\b/, Keyword::Declaration
        mixin :root
      end

      state :string do
        mixin :interpolation
        rule %r/\\[nrt\"\'\\]/, Str::Escape
      end

      state :interpolation do
        rule %r/\$#{id}/, Str::Interpol
        rule %r/\$\{[^\}]+\}/, Str::Interpol
      end
    end
  end
end
