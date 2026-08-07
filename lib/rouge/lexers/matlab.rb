# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Matlab < RegexLexer
      title "MATLAB"
      desc "Matlab"
      tag 'matlab'
      aliases 'm'
      filenames '*.m'
      mimetypes 'text/x-matlab', 'application/x-matlab'

      def self.keywords
        @keywords = Set.new %w(
          arguments break case catch classdef continue else elseif end for
          function global if import methods otherwise parfor persistent
          properties return spmd switch try while
        )
      end

      lazy do
        require_relative 'matlab/keywords'
      end

      state :root do
        rule %r/\s+/m, Text # Whitespace
        rule %r([{]%.*?%[}])m, Comment::Multiline
        rule %r/%.*$/, Comment::Single
        rule %r/([.][.][.])(.*?)$/ do
          groups(Keyword, Comment)
        end

        rule %r/^(!)(.*?)(?=%|$)/ do |m|
          token Keyword, m[1]
          delegate Shell, m[2]
        end

        ident = %r/[a-z][_a-z0-9]*/i

        # [jneen]: there are elements of BUILTINS with
        # a . in them - the generic rule below won't match any of those.
        keywords %r/#{ident}[.]#{ident}/ do
          rule BUILTINS, Name::Builtin
        end

        keywords ident do
          rule :keywords, Keyword
          rule BUILTINS, Name::Builtin
          default Name
        end

        rule %r{[(){};:,\/\\\]\[]}, Punctuation

        rule %r/~=|==|<<|>>|[-~+\/*%=<>&^|.@]/, Operator


        rule %r/(\d+\.\d*|\d*\.\d+)(e[+-]?[0-9]+)?/i, Num::Float
        rule %r/\d+e[+-]?[0-9]+/i, Num::Float
        rule %r/\d+L/, Num::Integer::Long
        rule %r/\d+/, Num::Integer

        rule %r/'(?=(.*'))/, Str::Single, :chararray
        rule %r/"(?=(.*"))/, Str::Double, :string
        rule %r/'/, Operator
      end

      state :chararray do
        rule %r/[^']+/, Str::Single
        rule %r/''/, Str::Escape
        rule %r/'/, Str::Single, :pop!
      end

      state :string do
        rule %r/[^"]+/, Str::Double
        rule %r/""/, Str::Escape
        rule %r/"/, Str::Double, :pop!
      end
    end
  end
end
