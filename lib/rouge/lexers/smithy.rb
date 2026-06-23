# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Smithy < RegexLexer
      tag 'smithy'
      filenames '*.smithy'

      title 'Smithy'
      desc 'Smithy is a language for defining services and SDKs (https://smithy.io).'

      state :whitespace do
        rule %r/\s+/, Text::Whitespace
      end

      state :key do
        rule %r/\w+\:/, Name::Attribute
      end

      state :comment do
        rule %r/\/\/.*/, Comment::Single
      end

      state :annotation do
        rule %r/@\w+([.#]\w+)*/, Name::Decorator
      end

      state :simple_string do
        rule %r/"/, Str::Double, :string
      end
      
      state :root do
        mixin :whitespace
        mixin :comment
        mixin :annotation

        rule %r/^\$version:/, Keyword::Reserved
        rule %r/^\w+/, Keyword::Reserved
        mixin :simple_string

        rule %r/\(/, Punctuation, :arguments
        rule %r/\[/, Punctuation, :array
        rule %r/\{/, Punctuation, :object

        rule %r/\w+([.#]\w+)*/, Name::Class
      end

      state :arguments do
        rule %r/"\w+(\.\w+)*":/, Name::Attribute
        mixin :whitespace
        mixin :simple_string

        rule %r/,/, Punctuation

        rule %r/(true|false)/, Keyword::Constant
        rule %r/\d+(\.\d+)?/, Num
        rule %r/\[/, Punctuation, :array
        rule %r/\{/, Punctuation, :object
        rule %r/\w+:/, Name::Attribute
        rule %r/\)/, Punctuation, :pop!
      end

      state :value do
        mixin :whitespace
        mixin :comment
        mixin :annotation

        rule %r/:/, Punctuation

        rule %r/\$\w+/, Name::Label
        mixin :simple_string
        rule %r/\[/, Punctuation, :array
        rule %r/\{/, Punctuation, :object
        rule %r/\w+:/, Name::Attribute
        rule %r/(\w+)(\s)(:=)/ do
          groups Name::Attribute, Text::Whitespace, Punctuation
        end
        rule %r/[\w.#]+/, Name::Entity

      end

      state :string do
        rule %r/[^"]/, Str::Double
        rule %r/"/, Str::Double, :pop!
      end


      state :array do
        mixin :whitespace
        mixin :value
        mixin :key


        rule %r/,/, Punctuation
        rule %r/\]/, Punctuation, :pop!
      end

      state :object do
        mixin :annotation
        rule %r/\(/, Punctuation, :arguments
        rule %r/:=/, Punctuation
        rule %r/\=/, Punctuation
        mixin :whitespace
        mixin :value
        mixin :key


        rule %r/\}/, Punctuation, :pop!
        rule %r/,/, Punctuation
      end
    end
  end
end
