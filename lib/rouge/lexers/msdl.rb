# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Msdl < RegexLexer
      title "Msdl"
      desc "Measurable scenario description language"
      tag 'msdl'
      aliases 'sdl'
      filenames '*.sdl'


      def self.keywords
        @keywords ||= %w(
          any call cover def defualt do else emit empty
          if import in keep like match modifier multi_match
          not on outer properties repeat sample soft struct
          then try undefined wait when with
        ) # is, is first, is only, is also and list of are handled later 
      end

      def self.scenarios
	@scenarios ||= %w(
	  first_of match multi_match mix one_of parallel repeat
	  serial try emit wait_time wait call dut.error end fail
	  out info debug trace drive if
	)
      end

      def self.modifiers
	@modifiers ||= %w(
	  in on synchronize until
	)
      end

      def self.builtin_types
	@builtin_types ||= %w(
	  uint64 int64 uint int acceleration angle angular_speed
	  distance speed temprature time weight bool junction segment
	)
      end 

      def self.keywords_pseudo
        @builtins_pseudo ||= %w(true false null this it)
      end

      identifier = /[a-z_][a-z0-9_]*/i
      state :root do
	preProcBody = /<<.*$<</
	rule /\$.*([^.]|#{preProcBody})/, Comment::Preproc

	rule %r(/\*.*\*/)m, Comment::Multiline
	rule %r(//.*[^.]), Comment::Single
	rule /#.*[^.]/, Comment::Single

	#this removes the " character. needs fix or simplification
	rule /\"/ do
	  groups Str, Text
	  push :string
	end
	rule %r/\)\$/, :pop!

        rule %r/[^\S\n]+/, Text
        rule %r(#(.*)?\n?), Comment::Single
        rule %r/[\[\](){}.,:;]/, Punctuation
        rule %r/[\\\n][\\\r]/, Text

        rule %r/(and|or)\b/, Operator::Word
        rule %r/[\~\!\?\$\@\*\/\+\-\<\>\=\&\^\%|]|!=/, Operator

	rule %r/list +of/, Keyword

        rule %r/(def)((?:\s|\\\s)+)/ do
          groups Keyword, Text
          push :funcname
        end

        rule %r/(actor)((?:\s|\\\s)+)/ do
          groups Keyword, Text
          push :classname
        end

        rule %r/(scenario)((?:\s|\\\s)+)/ do
          groups Keyword, Text
          push :classname
        end

        rule %r/(type)((?:\s|\\\s)+)/ do
          groups Keyword, Text
          push :classname
        end

        rule %r/(extend)((?:\s|\\\s)+)/ do
          groups Keyword, Text
          push :classname
        end

        rule %r/(event)((?:\s|\\\s)+)/ do
          groups Keyword, Text
          push :eventName
        end

        rule %r/(is)((?:\s|\\\s)+)/ do
          groups Keyword, Text
          push :afterIs
        end

        # using negative lookbehind so we don't match property names
        rule %r/(?<!\.)#{identifier}/ do |m|
          if self.class.keywords.include? m[0]
            token Keyword
          elsif self.class.keywords_pseudo.include? m[0]
            token Keyword::Pseudo
	  elsif self.class.scenarios.include? m[0]
	    token Name::Builtin
	  elsif self.class.modifiers.include? m[0]
	    token Name::Builtin::Pseudo
	  elsif self.class.builtin_types.include? m[0]
	    token Keyword::Type
          else
            token Name
          end
        end

        rule identifier, Name

	exponentPart = /e [+-]? [0-9]+/ix
	decimalInteger = /0 | [1-9] [0-9]*/x
	decimalNumber = /#{decimalInteger}?\.[0-9]/

        floatLiteral = /(#{decimalNumber}#{exponentPart}?)|(#{decimalInteger}#{exponentPart})/

        rule %r/0b(_?[0-1])+/i, Num::Bin
        rule %r/0o(_?[0-7])+/i, Num::Oct
        rule %r/0x(_?[a-f0-9])+/i, Num::Hex
        decimalLiteral = %r/([1-9](_?[0-9])*|0)/

	 #quantified number
	rule /(#{floatLiteral}|#{decimalLiteral})([a-zA-Z&&[^e]])([a-zA-Z]*)/, Num
	rule /(#{floatLiteral})/, Num::Float
	rule /#{decimalLiteral}/, Num::Integer

      end

      #untested
      state :string do
        rule /\\./, Str::Escape
	rule /\"/, Str, :pop!
	rule /[^\\\n\"]+/, Str
	rule /\$\(/, Punctuation
	mixin :root
      end

      state :funcname do
        rule identifier, Name::Function, :pop!
      end

      state :classname do
        rule identifier, Name::Class
	rule %r/::/, Punctuation
	rule %r/:/, Punctuation, :pop!
	rule %r/[^\S\n]*{/, Punctuation, :pop!
      end

      state :eventName do
	rule identifier, Name::Atribute, :pop!
      end

      state :afterIs do
	rule %r/[ ]*((first)|(only)|(also))/, Keyword, :pop!
	rule %r//, Generic::Deleted, :pop!
      end

    end
  end
end
