# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class BitBake < RegexLexer
      title "BitBake"
      desc 'Task execution engine for Open Embedded (https://github.com/openembedded/bitbake)'
      tag 'bitbake'

      filenames '*.bb', '*.bbclass', '*.bbappend', '*.inc'

      start do
        @python = Python.new(options)
        @shell = Shell.new(options)
      end

      identifier = /[[:alpha:]_][[:alnum:]_${}-]*/
      assignments = /=|\?=|\?\?=|:=|\+=|\.=|=\.|=\+/

      state :root do
        rule %r/#.*?\n/, Comment
        rule %r/\n+/m, Text

        rule %r/(inherit|include|require|EXPORT_FUNCTIONS)(\s+.*)$/ do
          groups Keyword::Namespace, Text
        end

        rule %r/(addtask)(\s+)/ do
          groups Keyword, Text
          push :addtask
        end
        rule %r/(deltask|addhandler)(\s+.*)$/ do
          groups Keyword, Text
        end

        # [export] VAR = "..."
        rule %r/(export)?(\s*)(#{identifier})(\s*)(#{assignments})(\s*)(")/ do
          groups Keyword::Namespace, Text, Name::Variable, Text, Operator, Text, Literal::String::Delimiter
          push :quoted
        end

        # VAR[flag] = "..."
        rule %r/(#{identifier})(\s*)(\[)(\s*)(#{identifier})(\s*)(\])(\s*)(#{assignments})(\s*)(")/ do
          groups Name::Variable, Text, Operator, Text, Name::Attribute, Text, Operator, Text, Operator, Text, Literal::String::Delimiter
          push :quoted
        end

        # python() { ... }
        rule %r/(python)(\s*)(\(\))(\s*)({)/ do
          groups Keyword, Text, Operator, Text, Punctuation
          @python.reset!
          push :python_content
        end

        # python task() { ... }
        rule %r/(python)(\s*)(#{identifier})(\s*)(\(\))(\s*)({)/ do
          groups Keyword, Text, Name::Function, Text, Operator, Text, Punctuation
          @python.reset!
          push :python_content
        end

        # task() { ... }
        rule %r/(#{identifier})(\s*)(\(\))(\s*)({)/ do
          groups Name::Function, Text, Operator, Text, Punctuation
          @shell.reset!
          push :shell_content
        end
      end

      state :quoted do
        rule %r/\${@/ do
          token Keyword
          @python.reset!
          push :inline_python
        end
        rule %r/(\${)(\s*)(#{identifier})(\s*)(})/ do
          groups Keyword, Text, Name::Variable, Text, Keyword
        end
        rule %r/[^"$]+/, Literal::String
        rule %r/\$/, Literal::String
        rule %r/"/, Literal::String::Delimiter, :pop!
      end

      state :addtask do
        rule %r/\n/, Text, :pop!
        rule %r/\s+/, Text
        rule %r/before|after/, Keyword
        rule %r/#{identifier}/, Text
      end

      state :shell_content do
        rule %r/^}$/, Punctuation, :pop!
        rule %r/\n+/m, Text

        rule %r/^.*$/ do
          delegate @shell
        end
      end

      state :python_content do
        rule %r/^}$/, Punctuation, :pop!
        rule %r/\n+/m, Text

        rule %r/^.*$/ do
          delegate @python
        end
      end

      state :inline_python do
        rule %r/}/, Keyword, :pop!
        rule %r/{/ do
          token Keyword
          push :inline_python
        end

        rule %r/[^{}]+/ do
          delegate @python
        end
      end
    end
  end
end
