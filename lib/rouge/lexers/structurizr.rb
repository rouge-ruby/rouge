# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Structurizr < RegexLexer
      title "Structurizr"
      desc "The Structurizr DSL (https://github.com/structurizr/dsl)"
      tag "structurizr"
      filenames "*.c4", "*.dsl", "*.structurizr"

      # TODO: Verify all examples parse from https://github.com/structurizr/dsl/tree/master/examples

      def self.keywords
        @keywords ||= Set.new(%w(workspace model enterprise group person
        softwareSystem container component deploymentEnvironment
        deploymentGroup deploymentNode infrastructureNode
        softwareSystemInstance containerInstance healthCheck element tags url
        properties perspectives views systemLandscape systemContext container
        component filtered dynamic deployment custom include exclude autoLayout
        animation title styles element relationship theme themes branding
        terminology configuration users).map { |s| s.downcase })
      end

      def self.keywords_include
        @keywords_include ||= Set.new ["!include"]
      end

      def self.keywords_doc_include
        @keywords_doc_include ||= Set.new ["!docs", "!adrs"]
      end

      identifier = %r(\w+)

      state :identifier do
        mixin :whitespace
        rule %r/(#{identifier})\b/, Name::Variable
      end

      state :whitespace do
        rule %r/\s+/m, Text::Whitespace
      end

      state :comment do
        rule %r/\/\/.*$/, Comment
        rule %r/#.*$/, Comment
        # TODO: Verify that whitespace after comment-close doesn't break the lexer
        rule %r(\/\*.*?\*\/$)m, Comment::Multiline
      end

      state :include do
        mixin :whitespace
        rule %r/(\!#{identifier})\b(\p{Blank}+)([^\n]+)$/i do |m|
          if self.class.keywords_include.include? m[1].downcase
            groups Keyword, Text::Whitespace, Text
          elsif self.class.keywords_doc_include.include? m[1].downcase
            groups Comment, Text::Whitespace, Text
          else
            token Error, m[0]
          end
        end
      end

      state :constant do
        mixin :whitespace
        rule %r/(!constant)\b(\p{Blank}+)(#{identifier})\b(\p{Blank}+)/i do
          groups Keyword::Declaration, Text::Whitespace, Name::Constant, Text::Whitespace
          push :value
        end
      end

      state :value do
        rule %r/\n/, Text::Whitespace, :pop!
        mixin :whitespace
        mixin :string
        rule %r/\*/, Str::Symbol
        rule %r/\b(?:true|false)\b/, Keyword::Constant, :pop!
        # TODO: Use identifier mixin and explore refactoring for statelessness
        rule %r/(#{identifier})\b/, Name::Variable, :pop!
        rule %r/#([a-fA-F0-9]{3,8})\b/, Str::Symbol, :pop!
        rule %r/-?(?:0|[1-9]\d*)\.\d+(?:e[+-]?\d+)?/i, Num::Float, :pop!
        rule %r/-?(?:0|[1-9]\d*)(?:e[+-]?\d+)?/i, Num::Integer, :pop!
      end

      state :string do
        rule %r/https?:\S+/, Str::Other
        rule %r/"/, Str::Double, :string_body
      end

      state :string_body do
        #rule %r/[$][{]/, Str::Interpol, :string_intp
        rule %r/($\{)([a-zA-Z0-9\-_.]+?)(\})/i do
          groups Str::Interpol, Name::Variable, Str::Interpol
        end
        rule %r/"/, Str::Double, :pop!
        rule %r/./, Str
      end

      state :string_intp do
        rule %r/}/, Str::Interpol, :pop!
        rule %r/(#{identifier})\b/, Name::Variable, :pop!
      end

      state :property do
        rule %r/(#{identifier})\b(\p{Blank}*)/i do
          groups Keyword::Declaration, Text::Whitespace
          push :value
        end
      end

      state :construct do
        rule %r/(#{identifier})\b(\p{Blank}*)/i do |m|
          if self.class.keywords.include? m[1].downcase
            groups Keyword::Type, Text::Whitespace
            push :construct_args
          else
            groups Keyword::Declaration, Text::Whitespace
            push :value
          end
        end
      end

      state :construct_args do
        rule %r/\n/, Text::Whitespace, :pop!
        rule %r/\*/, Str::Symbol

        mixin :whitespace
        mixin :string
        mixin :identifier

        rule %r/{/ do
          token Punctuation
          pop!
          push :context
        end
      end

      state :context do
        mixin :whitespace
        mixin :comment

        mixin :base

        rule %r/}/, Punctuation, :pop!
        rule %r/{/, Punctuation, :context
      end

      # NOTE: State definitions in line with StructurizrDslParser.java
      state :assignment do
        rule %r/(#{identifier})\b(\p{Blank}*)(=)/i do
          groups Keyword::Declaration, Text::Whitespace, Operator
        end
      end

      state :relationship_explicit do
        rule %r/(#{identifier})\b(\p{Blank}*)(->)/i do
          groups Keyword::Declaration, Text::Whitespace, Operator
        end
      end

      state :relationship_implicit do
        rule %r/(->)(\p{Blank}*)/i do
          groups Operator, Text::Whitespace
        end
      end

      state :rel do
        mixin :relationship_explicit
        mixin :relationship_implicit
      end

      state :ref do
        rule %r/(ref)(\p{Blank}+)({)/i do
          groups Keyword::Declaration, Text::Whitespace, Punctuation
        end

        rule %r/(ref)(\p{Blank}+)/i, Keyword::Declaration, :construct_args
      end

      state :base do
        mixin :whitespace
        mixin :comment

        mixin :assignment
        mixin :rel
        mixin :ref

        mixin :construct
        mixin :property
        mixin :constant
        mixin :include
      end

      state :root do
        mixin :base
      end
    end
  end
end
