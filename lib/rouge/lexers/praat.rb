# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Praat < RegexLexer
      title "Praat"
      desc "The Praat scripting language (praat.org)"

      tag 'praat'

      filenames '*.praat', '*.proc', '*.psc'

      def self.detect?(text)
        return true if text.shebang? 'praat'
      end

      lazy { require_relative 'praat/builtins' }

      state :root do
        rule %r/(\s+)(#.*?$)/ do
          groups Text, Comment::Single
        end

        rule %r/^#.*?$/, Comment::Single
        rule %r/;[^\n]*/, Comment::Single
        rule %r/\s+/, Text

        rule %r/(\bprocedure)(\s+)/ do
          groups Keyword, Text
          push :procedure_definition
        end

        rule %r/(\bcall)(\s+)/ do
          groups Keyword, Text
          push :procedure_call
        end

        rule %r/@/, Name::Function, :procedure_call

        mixin :function_call

        rule %r/\b(?:select all)\b/, Keyword

        rule %r/(\bform\b)(\s+)([^\n]+)/ do
          groups Keyword, Text, Literal::String
          push :old_form
        end

        rule %r/(print(?:line|tab)?|echo|exit|asserterror|pause|send(?:praat|socket)|include|execute|system(?:_nocheck)?)(\s+)/ do
          groups Keyword, Text
          push :string_unquoted
        end

        rule %r/(goto|label)(\s+)(\w+)/ do
          groups Keyword, Text, Name::Label
        end

        mixin :variable_name
        mixin :number
        mixin :vector_literal

        rule %r/"/, Literal::String, :string

        keywords %r/\b([A-Z][a-zA-Z0-9]+)(?=\s+\S+\n)/ do
          rule OBJECTS, Name::Class, :string_unquoted
          default Keyword
        end

        rule %r/\b(?=[A-Z])/, Text, :command
        rule %r/(\.{3}|[)(,\$])/, Punctuation

        keywords %r/[a_z]+/ do |m|
          rule KEYWORDS, Keyword
          default Text
        end
      end

      state :command do
        rule %r/( ?([^\s:\.'])+ ?)/, Keyword
        mixin :string_interpolated

        rule %r/\.{3}/ do
          token Keyword
          pop!
          push :old_arguments
        end

        rule %r/:/ do
          token Keyword
          pop!
          push :comma_list
        end

        rule %r/[\s]/, Text, :pop!
      end

      state :procedure_call do
        mixin :string_interpolated

        rule %r/(:|\s*\()/, Punctuation, :pop!

        rule %r/'/, Name::Function
        rule %r/[^:\('\s]+/, Name::Function

        rule %r/(?=\s+)/ do
          token Text
          pop!
          push :old_arguments
        end
      end

      state :procedure_definition do
        rule %r/(:|\s*\()/, Punctuation, :pop!

        rule %r/[^:\(\s]+/, Name::Function

        rule %r/(\s+)/, Text, :pop!
      end

      state :function_call do
        keywords %r/\b([a-z][a-zA-Z0-9_.]+)(\$#|##|\$|#)?(?=\s*[:(])/ do
          rule FUNCTIONS, Name::Function, :function
          rule KEYWORDS, Keyword
          default Operator::Word
        end
      end

      state :function do
        rule %r/\s+/, Text

        rule %r/(?::|\s*\()/ do
          token Text
          pop!
          push :comma_list
        end
      end

      state :comma_list do
        rule %r/(\s*\n\s*)(\.{3})/ do
          groups Text, Punctuation
        end

        rule %r/\s*[\]\})\n]/, Text, :pop!

        rule %r/\s+/, Text
        rule %r/"/, Literal::String, :string
        rule %r/\b(if|then|else|fi|endif)\b/, Keyword

        mixin :function_call
        mixin :variable_name
        mixin :operator
        mixin :number
        mixin :vector_literal

        rule %r/[()]/, Text
        rule %r/,/, Punctuation
      end

      state :old_arguments do
        rule %r/\n/, Text, :pop!

        mixin :variable_name
        mixin :operator
        mixin :number

        rule %r/"/, Literal::String, :string
        rule %r/[^\n]/, Text
      end

      state :number do
        rule %r/\n/, Text, :pop!
        rule %r/\b\d+(\.\d*)?([eE][-+]?\d+)?%?/, Literal::Number
      end

      state :variable_name do
        mixin :operator
        mixin :number

        keywords %r/\b([A-Z][a-zA-Z0-9]+)_/ do
          group 1
          rule Set['Object'], Name::Builtin, :object_reference
          rule OBJECTS, Name::Builtin, :object_reference
          default Name::Variable
        end

        keywords %r/\.?[a-z][a-zA-Z0-9_.]*(\$#|##|\$|#)?/ do |m|
          rule VARIABLES, Name::Builtin
          rule KEYWORDS, Keyword
          default Name::Variable
        end

        rule %r/[\[\]]/, Text, :comma_list
        mixin :string_interpolated
      end

      state :vector_literal do
        rule %r/(\{)/, Text, :comma_list
      end

      state :object_reference do
        mixin :string_interpolated
        rule %r/([a-z][a-zA-Z0-9_]*|\d+)/, Name::Builtin

        keywords %r/\.([a-z]+)\b/ do |m|
          group 1
          rule ATTRIBUTES, Name::Builtin, :pop!
        end

        rule %r/\$/, Name::Builtin
        rule %r/\[/, Text, :pop!
      end

      state :operator do
        # This rule incorrectly matches === or +++++, which are not operators
        rule %r/([+\/*<>=!-]=?|[&*|][&*|]?|\^|<>)/, Operator
        rule %r/(?<![\w.])(and|or|not|div|mod)(?![\w.])/, Operator::Word
      end

      state :string_interpolated do
        rule %r/'[\._a-z][^\[\]'":]*(\[([\d,]+|"[\w,]+")\])?(:[0-9]+)?'/, Literal::String::Interpol
      end

      state :string_unquoted do
        rule %r/\n\s*\.{3}/, Punctuation
        rule %r/\n/, Text, :pop!
        rule %r/\s/, Text

        mixin :string_interpolated

        rule %r/'/, Literal::String
        rule %r/[^'\n]+/, Literal::String
      end

      state :string do
        rule %r/\n\s*\.{3}/, Punctuation
        rule %r/"/, Literal::String, :pop!

        mixin :string_interpolated

        rule %r/'/, Literal::String
        rule %r/[^'"\n]+/, Literal::String
      end

      state :old_form do
        rule %r/(\s+)(#.*?$)/ do
          groups Text, Comment::Single
        end

        rule %r/\s+/, Text

        rule %r/(optionmenu|choice)([ \t]+\S+:[ \t]+)/ do
          groups Keyword, Text
          push :number
        end

        rule %r/(option|button)([ \t]+)/ do
          groups Keyword, Text
          push :string_unquoted
        end

        rule %r/(sentence|text)([ \t]+\S+)/ do
          groups Keyword, Text
          push :string_unquoted
        end

        rule %r/(word)([ \t]+\S+[ \t]*)(\S+)?([ \t]+.*)?/ do
          groups Keyword, Text, Literal::String, Text
        end

        rule %r/(boolean)(\s+\S+\s*)(0|1|"?(?:yes|no)"?)/ do
          groups Keyword, Text, Name::Variable
        end

        rule %r/(real|natural|positive|integer)([ \t]+\S+[ \t]*)([+-]?)/ do
          groups Keyword, Text, Operator
          push :number
        end

        rule %r/(comment)(\s+)/ do
          groups Keyword, Text
          push :string_unquoted
        end

        rule %r/\bendform\b/, Keyword, :pop!
      end
    end
  end
end
