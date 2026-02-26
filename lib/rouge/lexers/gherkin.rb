# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Gherkin < RegexLexer
      tag 'gherkin'
      aliases 'cucumber', 'behat'

      title "Gherkin"
      desc 'A business-readable spec DSL (github.com/cucumber/cucumber/wiki/Gherkin)'

      filenames '*.feature'
      mimetypes 'text/x-gherkin'

      def self.detect?(text)
        return true if text.shebang? 'cucumber'
      end

      lazy do
        require_relative 'gherkin/keywords'
      end

      rest_of_line = /.*?(?=[#\n])/

      state :basic do
        rule %r(#.*$), Comment
        rule %r/[ \r\t]+/, Text
      end

      state :root do
        mixin :basic
        rule %r(\n), Text
        rule %r(""".*?""")m, Str
        rule %r(@[^\s@]+), Name::Tag
        mixin :has_table
        mixin :has_examples
      end

      state :has_scenarios do
        rule %r((.*?)(:)) do |m|
          reset_stack

          keyword = m[1]
          keyword_tok = if KEYWORDS[:element].include? keyword
            push :description; Keyword::Namespace
          elsif KEYWORDS[:feature].include? keyword
            push :feature_description; Keyword::Declaration
          elsif KEYWORDS[:examples].include? keyword
            push :example_description; Name::Namespace
          else
            Error
          end

          groups keyword_tok, Punctuation
        end
      end

      state :has_examples do
        mixin :has_scenarios
        rule Gherkin::STEP_REGEX do
          token Name::Function
          reset_stack
          push :step
        end
      end

      state :has_table do
        rule(/(?=[|])/) { push :table_header }
      end

      state :table_header do
        rule %r/[^|\s]+/, Name::Variable
        rule %r/\n/ do
          token Text
          goto :table
        end
        mixin :table
      end

      state :table do
        mixin :basic
        rule %r/\n/, Text, :table_bol
        rule %r/[|]/, Punctuation
        rule %r/[^|\s]+/, Name
      end

      state :table_bol do
        rule(/(?=\s*[^\s|])/) { reset_stack }
        rule(//) { pop! }
      end

      state :description do
        mixin :basic
        mixin :has_examples
        rule %r/\n/, Text
        rule rest_of_line, Text
      end

      state :feature_description do
        mixin :basic
        mixin :has_scenarios
        rule %r/\n/, Text
        rule rest_of_line, Text
      end

      state :example_description do
        mixin :basic
        mixin :has_table
        rule %r/\n/, Text
        rule rest_of_line, Text
      end

      state :step do
        mixin :basic
        rule %r/<.*?>/, Name::Variable
        rule %r/".*?"/, Str
        rule %r/\S[^\s<]*/, Text
        rule rest_of_line, Text, :pop!
      end
    end
  end
end
