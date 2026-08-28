# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Scilab < RegexLexer
      title "Scilab"
      desc "Scilab"
      tag 'scilab'
      aliases 'sci', 'sce', 'tst'
      filenames '*.sci', '*.sce','*.tst'
      mimetypes 'text/x-scilab', 'application/x-scilab'

      # Scilab identifiers
      # See SCI/modules/ast/src/cpp/parse/flex/scanscilab.ll
      UTF2  =          /\b([\\xC2-\\xDF][\\x80-\\xBF])\b/
      UTF31 =          /\b([\\xE0][\\xA0-\\xBF][\\x80-\\xBF])\b/
      UTF32 =          /\b([\\xE1-\\xEC][\\x80-\\xBF][\\x80-\\xBF])\b/
      UTF33 =          /\b([\\xED][\\x80-\\x9F][\\x80-\\xBF])\b/
      UTF34 =          /\b([\\xEE-\\xEF][\\x80-\\xBF][\\x80-\\xBF])\b/
      UTF41 =          /\b([\\xF0][\\x90-\\xBF][\\x80-\\xBF][\\x80-\\xBF])\b/
      UTF42 =          /\b([\\xF1-\\xF3][\\x80-\\xBF][\\x80-\\xBF][\\x80-\\xBF])\b/
      UTF43 =          /\b([\\xF4][\\x80-\\x8F][\\x80-\\xBF][\\x80-\\xBF])\b/

      UTF3  =          /(#{UTF31}|#{UTF32}|#{UTF33}|#{UTF34})/
      UTF4  =          /(#{UTF41}|#{UTF42}|#{UTF43})/

      UTF   =          /(#{UTF2}|#{UTF3}|#{UTF4})/
      
      SCILAB_IDENTIFIER = /((([a-zA-Z_%!#?]|#{UTF})([a-zA-Z_0-9!#?$]|#{UTF})*)|([$]([a-zA-Z_0-9!#?$]|#{UTF})+))/
      SCILAB_CONJUGATE_TRANSPOSE = /((([a-zA-Z_%!#?]|#{UTF})([a-zA-Z_0-9!#?$]|#{UTF})*)|([$]([a-zA-Z_0-9!#?$]|#{UTF})+))\K'/

      # self-modifying method that loads the keywords file
      def self.keywords
        Kernel::load File.join(Lexers::BASE_DIR, 'scilab/keywords.rb')
        keywords
      end

      # self-modifying method that loads the builtins file
      def self.builtins
        Kernel::load File.join(Lexers::BASE_DIR, 'scilab/builtins.rb')
        builtins
      end

      # self-modifying method that loads the predefs file
      def self.predefs
        Kernel::load File.join(Lexers::BASE_DIR, 'scilab/predefs.rb')
        predefs
      end

      # self-modifying method that loads the functions file
      def self.functions
        Kernel::load File.join(Lexers::BASE_DIR, 'scilab/functions.rb')
        functions
      end

      state :root do
        # Whitespace
        rule %r/\s+/m, Text

        # Comments
        rule %r(//.*?$), Comment::Single
        rule %r(/\*.*?\*/)m, Comment::Multiline

        # Punctuation
        rule %r{[(){};:,\/\\\]\[]}, Punctuation

        # Operators (without ' (conjugate transpose) with is managed in a specific case)
        rule %r/~=|==|\.'|[-~+\/*=<>&^|.@]/, Operator

        # Special case for .' operator' (needed to avoid ' * b' to be considered as a single_string in c = a' * b')
        rule %r/#{SCILAB_CONJUGATE_TRANSPOSE}/ do |m|
          token Name::Variable, m[1]
          token Operator, m[0]
        end

        # Numbers
        rule %r/(\d+\.\d*|\d*\.\d+)(e[+-]?[0-9]+)?/i, Num::Float
        rule %r/\d+e[+-]?[0-9]+/i, Num::Float
        rule %r/\d+L/, Num::Integer::Long
        rule %r/\d+/, Num::Integer

        # Builtins, Keyworks, ...
        rule %r(#{SCILAB_IDENTIFIER})m do |m| 
          match = m[0]
          if self.class.keywords.include? match
            token Keyword
          elsif self.class.builtins.include? match
            token Name::Builtin
          elsif self.class.predefs.include? match
            token Keyword::Variable
          elsif self.class.functions.include? match
            token Name::Function
          else
            token Name::Variable
          end
        end

        # Strings: "abc" or 'abc'
        rule %r/'(?=(.*'))/, Str::Single, :single_string
        rule %r/"(?=(.*"))/, Str::Double, :double_string
        
      end

      # String: 'abc'
      state :single_string do
        rule %r/[^'"]+/, Str::Single
        rule %r/(''|"")/, Str::Escape
        rule %r/'/, Str::Single, :pop!
      end

      # String: "abc"
      state :double_string do
        rule %r/[^"']+/, Str::Double
        rule %r/(""|'')/, Str::Escape
        rule %r/"/, Str::Double, :pop!
      end

    end
  end
end
