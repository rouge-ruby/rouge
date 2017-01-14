# -*- coding: utf-8 -*- #
module Rouge
  module Lexers
    class Robot < RegexLexer
      tag 'robot'
      aliases 'robotframework'

      title "Robot"
      desc 'Test DSL ( http://robotframework.org/ )'

      filenames '*.robot'
      mimetypes 'text/x-robot'

      def self.analyze_text(text)
        return 1 if text =~ /\*\*\*\s+Settings\s+\*\*\*/
      end

      SETTINGS = '(Resource)|(Variables)|(Documentation)|(Metadata)|(Suite Setup)|(Suite Teardown)|(Force Tags)|(Default Tags)|(Test Setup)|(Test Teardown)|(Test Template)|(Test Timeout)'
      BDD = 'Given|When|Then|And|But'
      TEST_CASE = 'Documentation|Tags|Setup|Teardown|Template|Timeout'
      KEYWORD = 'Documentation|Tags|Arguments|Return|Teardown|Timeout'
      rest_of_line = /.*?(?=[#\n])/

      state :basic do
#        rule /\t/ do |m|
#          token Punctuation, '→' + m[0]
#        end
        rule %r(\n), Text
        rule %r(#.*$), Comment
        rule /\$\{.*?\}/, Name::Variable
        rule /\@\{.*?\}/, Name::Variable # list
        rule /\&\{.*?\}/, Name::Variable # dict
        rule %r([ \r]+), Text
        rule %r([|]), Punctuation
      end

      state :root do
        mixin :basic
        rule %r(\*\*\*\s+Test Case(s)?\s+\*\*\*) do 
          reset_stack
          push :test_cases
          token Name::Namespace
        end
        rule %r(\*\*\*\s+Keywords\s+\*\*\*) do 
          reset_stack
          push :keywords
          token Name::Namespace
        end
        rule %r(\*\*\*\s+Settings\s+\*\*\*) do 
          reset_stack 
          push :settings
          token Name::Namespace
        end
        rule %r(\*\*\*\s+Variables?\s+\*\*\*) do 
          token Name::Namespace
        end
      end

      state :settings do
         mixin :root
         rule /^#{SETTINGS}/ do
            reset_stack
            push :rest
            token Keyword::Reserved
         end
      end

      state :rest do
         mixin :settings
         rule rest_of_line, Text
      end

      state :test_cases do
        mixin :root
        rule /\[(#{TEST_CASE})\]/i, Keyword::Reserved
        rule %r(^\S.+$) do
          reset_stack
          push :test_definition
          token Name::Function
        end
      end
      state :test_definition do
        mixin :test_cases 
        rule /#{BDD}/i, Keyword::Constant
        rule /.+?/, Text # FIXME Arguments
      end

      state :keywords do
        mixin :root
        rule /\[(#{KEYWORD})\]/i, Keyword::Reserved
        rule %r(^\S.+) do |m|
          reset_stack
          push :keyword_definition
          token Name::Function
        end
      end
      state :keyword_definition do
         mixin :keywords 
        rule /.+?/, Text # FIXME Arguments
      end

    end
  end
end
