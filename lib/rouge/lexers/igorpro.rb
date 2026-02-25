# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class IgorPro < RegexLexer
      tag 'igorpro'
      filenames '*.ipf'
      mimetypes 'text/x-igorpro'

      title "IgorPro"
      desc "WaveMetrics Igor Pro"

      lazy { require_relative "igorpro/builtins" }

      def self.keywords
        @keywords ||= Set.new %w(
          structure endstructure
          threadsafe static
          macro proc window menu function end
          if else elseif endif switch strswitch endswitch
          break return continue
          for endfor do while
          case default
          try catch endtry
          abortonrte abortonvalue
        )
      end

      def self.preprocessor
        @preprocessor ||= Set.new %w(
          pragma include
          define ifdef ifndef undef
          if elif else endif
        )
      end

      def self.igor_declarations
        @igor_declarations ||= Set.new %w(
          variable string wave strconstant constant
          nvar svar dfref funcref struct
          char uchar int16 uint16 int32 uint32 int64 uint64 float double
        )
      end

      def self.igor_constants
        @igor_constants ||= Set.new %w(nan inf)
      end

      def self.object_name
        /\b[a-z][a-z0-9_\.]*?\b/i
      end

      object = self.object_name
      noLineBreak = /(?:[ \t]|(?:\\\s*[\r\n]))+/
      operator = %r([\#$~!%^&*+=\|?:<>/-])
      punctuation = /[{}()\[\],.;]/
      number_float= /0x[a-f0-9]+/i
      number_hex  = /\d+\.\d+(e[\+\-]?\d+)?/
      number_int  = /[\d]+(?:_\d+)*/

      state :root do
        rule %r(//), Comment, :comments

        rule %r/#{object}/ do |m|
          if m[0].downcase =~ /function/
            token Keyword::Declaration
            push :parse_function
          elsif self.class.igor_declarations.include? m[0].downcase
            token Keyword::Declaration
            push :parse_variables
          elsif self.class.keywords.include? m[0].downcase
            token Keyword
          elsif self.class.igor_constants.include? m[0].downcase
            token Keyword::Constant
          elsif FUNCTIONS.include?(m[0].downcase)
            token Name::Builtin
          elsif OPERATIONS.include? m[0].downcase
            token Keyword::Reserved
            push :operationFlags
          elsif m[0].downcase =~ /\b(v|s|w)_[a-z]+[a-z0-9]*/
            token Name::Constant
          else
            token Name
          end
        end

        mixin :preprocessor
        mixin :waveFlag

        mixin :characters
        mixin :numbers
        mixin :whitespace
      end

      state :preprocessor do
        rule %r((\#)(#{object})) do |m|
          if self.class.preprocessor.include? m[2].downcase
            token Comment::Preproc
          else
            token Punctuation, m[1] #i.e. ModuleFunctions
            token Name, m[2]
          end


        end
      end

      state :assignment do
        mixin :whitespace
        rule %r/\"/, Literal::String::Double, :string1 #punctuation for string
        mixin :string2
        rule %r/#{number_float}/, Literal::Number::Float, :pop!
        rule %r/#{number_int}/, Literal::Number::Integer, :pop!
        rule %r/[\(\[\{][^\)\]\}]+[\)\]\}]/, Generic, :pop!
        rule %r/[^\s\/\(]+/, Generic, :pop!
        rule(//) { pop! }
      end

      state :parse_variables do
        mixin :whitespace
        rule %r/[=]/, Punctuation, :assignment
        rule object, Name::Variable
        rule %r/[\[\]]/, Punctuation # optional variables in functions
        rule %r/[,]/, Punctuation, :parse_variables
        rule %r/\)/, Punctuation, :pop! # end of function
        rule %r([/][a-z]+)i, Keyword::Pseudo, :parse_variables
        rule(//) { pop! }
      end

      state :parse_function do
        rule %r([/][a-z]+)i, Keyword::Pseudo # only one flag
        mixin :whitespace
        rule object, Name::Function
        rule %r/[\(]/, Punctuation, :parse_variables
        rule(//) { pop! }
      end

      state :operationFlags do
        rule %r/#{noLineBreak}/, Text
        rule %r/[=]/, Punctuation, :assignment
        rule %r([/][a-z]+)i, Keyword::Pseudo, :operationFlags
        rule %r/(as)(\s*)(#{object})/i do
          groups Keyword::Type, Text, Name::Label
        end
        rule(//) { pop! }
      end

      # inline variable assignments (i.e. for Make) with strict syntax
      state :waveFlag do
        rule %r(
          (/(?:wave|X|Y))
          (\s*)(=)(\s*)
          (#{object})
          )ix do |m|
          token Keyword::Pseudo, m[1]
          token Text, m[2]
          token Punctuation, m[3]
          token Text, m[4]
          token Name::Variable, m[5]
        end
      end

      state :characters do
        rule %r/\s/, Text
        rule %r/#{operator}/, Operator
        rule %r/#{punctuation}/, Punctuation
        rule %r/\"/, Literal::String::Double, :string1 #punctuation for string
        mixin :string2
      end

      state :numbers do
        rule %r/#{number_float}/, Literal::Number::Float
        rule %r/#{number_hex}/, Literal::Number::Hex
        rule %r/#{number_int}/, Literal::Number::Integer
      end

      state :whitespace do
        rule %r/#{noLineBreak}/, Text
      end

      state :string1 do
        rule %r/%\w\b/, Literal::String::Other
        rule %r/\\\\/, Literal::String::Escape
        rule %r/\\\"/, Literal::String::Escape
        rule %r/\\/, Literal::String::Escape
        rule %r/[^"]/, Literal::String
        rule %r/\"/, Literal::String::Double, :pop! #punctuation for string
      end

      state :string2 do
        rule %r/\'[^']*\'/, Literal::String::Single
      end

      state :comments do
        rule %r{([/]\s*)([@]\w+\b)}i do
          # doxygen comments
          groups Comment, Comment::Special
        end
        rule %r/[^\r\n]/, Comment
        rule(//) { pop! }
      end
    end
  end
end
