# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class OpenEdge < RegexLexer
      tag 'openedge'
      aliases 'abl'
      filenames '*.w', '*.i', '*.p', '*.cls', '*.df'
      mimetypes 'text/x-openedge'

      title 'OpenEdge ABL'
      desc 'The OpenEdge ABL programming language'

      lazy { require_relative 'openedge/keywords' }

      id = /[a-zA-Z_&{}!][a-zA-Z0-9_\-&!}]*/

      state :statements do
        mixin :singlelinecomment
        mixin :multilinecomment
        mixin :string
        mixin :numeric
        mixin :constant
        mixin :operator
        mixin :whitespace
        mixin :preproc
        mixin :decorator
        mixin :function
      end

      state :whitespace do
        rule %r/\s+/m, Text
      end

      state :singlelinecomment do
        rule %r(//.*$), Comment::Single
      end

      state :multilinecomment do
        rule %r(/[*]), Comment::Multiline, :multilinecomment_content
      end

      state :multilinecomment_content do
        rule %r([*]/), Comment::Multiline, :pop!
        rule %r(/[*]), Comment::Multiline, :multilinecomment_content
        rule %r([^*/]+), Comment::Multiline
        rule %r([*/]), Comment::Multiline
      end

      state :string do
        rule %r/"/, Str::Delimiter, :doublequotedstring
        rule %r/'/, Str::Delimiter, :singlequotedstring
      end

      state :numeric do
        rule %r((?:\d+[.]\d*|[.]\d+)(?:e[+-]?\d+[lu]*)?)i, Num::Float
        rule %r(\d+e[+-]?\d+[lu]*)i, Num::Float
        rule %r/0x[0-9a-f]+[lu]*/i, Num::Hex
        rule %r/0[0-7]+[lu]*/i, Num::Oct
        rule %r/\d+[lu]*/i, Num::Integer
      end

      state :constant do
        rule %r/(?:TRUE|FALSE|YES|NO(?!\-)|\?)\b/i, Keyword::Constant
      end

      state :operator do
        rule %r([~!%^*+=\|?:<>/-]), Operator
        rule %r/[()\[\],.]/, Punctuation
      end

      state :doublequotedstring do
        rule %r/\~[~nrt"]?/, Str::Escape
        rule %r/[^\\"]+/, Str::Double
        rule %r/"/, Str::Delimiter, :pop!
      end

      state :singlequotedstring do
        rule %r/\~[~nrt']?/, Str::Escape
        rule %r/[^\\']+/, Str::Single
        rule %r/'/, Str::Delimiter, :pop!
      end

      state :preproc do
        rule %r/(\&analyze-suspend|\&analyze-resume)/i, Comment::Preproc, :analyze_suspend_resume_content
        rule %r/(\&scoped-define|\&global-define)\s*([\.\w\\\/-]*)/i , Comment::Preproc, :analyze_suspend_resume_content
        mixin :include_file
      end

      state :analyze_suspend_resume_content do
        rule %r/.*(?=(?:\/\/|\/\*))/, Comment::Preproc, :pop!
        rule %r/.*\n/, Comment::Preproc, :pop!
        rule %r/.*/, Comment::Preproc, :pop!
      end

      state :preproc_content do
        rule %r/\n/, Text, :pop!
        rule %r/\s+/, Text

        rule %r/({?&)(\S+)/ do
          groups Comment::Preproc, Name::Other
        end

        rule %r/"/, Str, :string
        mixin :numeric

        rule %r/\S+/, Name
      end

      state :include_file do
        rule %r/(\{(?:[^\{\}]|(\g<0>))+\})/i , Comment::Preproc
      end

      state :decorator do
        rule %r/@#{id}/, Name::Decorator #, :decorator_content
      end

      state :function do
        rule %r/\!?#{id}(?=\s*\()/i , Name::Function
      end

      state :root do
        mixin :statements

        keywords id do
          transform(&:upcase)

          rule KEYWORDS_PREPRO, Comment::Preproc
          rule KEYWORDS, Keyword
          rule KEYWORDS_TYPE, Keyword::Type
          default Name
        end
      end
    end
  end
end
