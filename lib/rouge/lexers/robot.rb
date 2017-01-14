# -*- coding: utf-8 -*- #
module Rouge
  module Lexers
    class Robot < RegexLexer
      tag 'robot'
      aliases 'robotframework'

      title "Robot"
      desc 'Test DSL ( http://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html )'

      filenames '*.robot'
      mimetypes 'text/x-robot'

      def self.analyze_text(text)
        return 1 if text =~ /\*\*\*\s+Setting(s)?\s+\*\*\*/
      end

      SETTINGS = '(Resource)|(Variables)|(Documentation)|(Metadata)|(Suite Setup)|(Suite Teardown)|(Force Tags)|(Default Tags)|(Test Setup)|(Test Teardown)|(Test Template)|(Test Timeout)|(Library)'
      BDD = 'Given|When|Then|And|But'
      TEST_CASE = 'Documentation|Tags|Setup|Teardown|Template|Timeout'
      KEYWORD = 'Documentation|Tags|Arguments|Return|Teardown|Timeout'
      rest_of_line = /.*?(?=[#\n])/


      state :basic do
#        #In robot framework tabs are very important, 
#        #but highliting with a '→' sign can be an isssue for copypaste
#        rule /\t/ do |m|
#         #token Punctuation, '→' + m[0] 
#        end
        rule %r(\n), Text
        rule %r(#.*$), Comment
        rule /\$\{.*?\}/, Name::Variable
        rule /\@\{.*?\}/, Name::Variable # list
        rule /\&\{.*?\}/, Name::Variable # dict
        rule %r([\r]+), Text
        rule %r([|]), Punctuation
        rule /".+"/, Str::Double
        rule /'.+'/, Str::Single
        rule /".+"/, Str::Double
        rule  /\b[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\b/, Str # ipv4
#        rule /\W-?(?:0|[1-9]\d*)\.\d+(?:e[+-]\d+)?\W/i, Num::Float 
#        rule /\W-?(?:0|[1-9]\d*)(?:e[+-]\d+)?\W/i, Num::Integer    
      end

      # Token types are set for visual perfofmance in gitlab webui
      state :root do
        mixin :basic
        rule /\*\*\*\s+Test Case(s)?\s+\*\*\*/i do 
          reset_stack
          push :test_cases
          token   Name::Tag
        end
        rule /\*\*\*\s+Keywords\s+\*\*\*/i do 
          reset_stack
          push :keywords
          token    Name::Tag
        end
        rule /\*\*\*\s+Setting(s)?\s+\*\*\*/i do 
          reset_stack 
          push :settings
          token   Name::Tag
        end
        rule /\*\*\*\s+Variables?\s+\*\*\*/i do 
          token   Name::Tag
        end
      end

      state :settings do
         mixin :root
         rule /^#{SETTINGS}\s/ do
            token Keyword::Reserved
         end
        rule /.+?/, Text
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
        rule /^\s*(#{BDD})\s/i, Keyword::Constant
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
