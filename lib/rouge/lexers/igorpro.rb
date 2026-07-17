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

      KEYWORDS = Set.new %w(
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

      PREPROCESSOR_WORDS = Set.new %w(
        pragma include
        define ifdef ifndef undef
        if elif else endif
      )

      DECLARATIONS = Set.new %w(
        variable string wave strconstant constant
        nvar svar dfref funcref struct
        char uchar int16 uint16 int32 uint32 int64 uint64 float double
      )

      CONSTANTS = Set.new %w(nan inf)

      lazy { require_relative 'igorpro/builtins' }

      object = /[a-z][a-z0-9_\.]*/i
      noLineBreak = /(?:[ \t]|(?:\\\s*[\r\n]))+/
      operator = %r([\#$~!%^&*+=\|?:<>/-])
      punctuation = /[{}()\[\],.;]/
      number_float= /0x[a-f0-9]+/i
      number_hex  = /\d+\.\d+(e[\+\-]?\d+)?/
      number_int  = /[\d]+(?:_\d+)*/

      state :root do
        rule %r(//), Comment, :comments

        rule object do |m|
          obj = m[0].downcase

          if obj.include?('function')
            token Keyword::Declaration
            push :parse_function
          elsif DECLARATIONS.include?(obj)
            token Keyword::Declaration
            push :parse_variables
          elsif KEYWORDS.include?(obj)
            token Keyword
          elsif CONSTANTS.include?(obj)
            token Keyword::Constant
          elsif FUNCTIONS.include?(obj)
            token Name::Builtin
          elsif OPERATIONS.include?(obj)
            token Keyword::Reserved
            push :operationFlags
          elsif obj.match?(/\A(v|s|w)_[a-z]+[a-z0-9]*/o)
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
          if PREPROCESSOR_WORDS.include? m[2].downcase
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
        rule number_float, Literal::Number::Float, :pop!
        rule number_int, Literal::Number::Integer, :pop!
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
        rule noLineBreak, Text
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
        rule operator, Operator
        rule punctuation, Punctuation
        rule %r/\"/, Literal::String::Double, :string1 #punctuation for string
        mixin :string2
      end

      state :numbers do
        rule number_float, Literal::Number::Float
        rule number_hex, Literal::Number::Hex
        rule number_int, Literal::Number::Integer
      end

      state :whitespace do
        rule noLineBreak, Text
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
