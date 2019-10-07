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
          if import in keep like match multi_match
          not on outer properties repeat sample soft struct
          then try undefined wait when with
        ) # is, is first, is only, is also and list of are handled later 
      end

      def self.keywords_pseudo
        @builtins_pseudo ||= %w(true false null this it)
      end

      def self.scenarios
	@scenarios ||= %w(
	  first_of match multi_match mix one_of parallel repeat
	  serial try emit wait_time wait call dut.error start end fail
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

      identifier = /[a-z_][a-z0-9_]*/i
      state :root do
	rule /\$.*?\<\<[.[^.]]*?\$\<\</, Comment::Preproc #should be multiline?
	rule /\$.*/, Comment::Preproc

	rule %r(/\*.*\*/)m, Comment::Multiline
	rule /(\#)/ do
	  groups Comment, Text
	  push :commentOrIgnore
	end

	rule /(")/ do
	  groups Str, Text
	  push :string
	end

        rule %r/[^\S\n]+/, Text
        rule %r/[\[\](){}.,:;]/, Punctuation
        rule %r/[\n]/, Text

        rule %r/(and|or)\b/, Operator::Word
        rule %r/[\~\!\?\$\@\*\/\+\-\<\>\=\&\^\%|]|!=/, Operator

	rule %r/list +of/, Keyword

        rule %r/(def)((?:[^\S\n])+)/ do
          groups Keyword, Text
          push :funcDef
        end

        rule %r/((?:actor)|(?:scenario)|(?:type)|(?:extend))((?:[^\S\n])+)/ do
          groups Keyword, Text
          push :classname
        end

#should be variable name?
        rule %r/((?:event)|(?:modifier))((?:[^\S\n])+)/ do
          groups Keyword, Text
          push :variableName
        end

        rule %r/(is)(?=\W)/ do
          groups Keyword, Text
          push :afterIs
        end

	rule /(#{identifier})(?=\: #{identifier})/ do |m|
	  if self.class.keywords.include? m[0] or
	     self.class.keywords_pseudo.include? m[0] or
	     self.class.scenarios.include? m[0] or
	     self.class.modifiers.include? m[0] or
	     self.class.builtin_types.include? m[0]
	    raise 'cannot use reserved identifier as variable name'
	  end
	  token Name::Variable
	  push :afterVarb
	end

	rule /(#{identifier})(?=\()/ do |m|
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
	    token Name::Function
	  end
	  push :funcCall
	end

	mixin :identifier

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

      state :commentOrIgnore do
#        rule /COMPILER_SKIP_FILE.*/m, Comment::Special
	rule /COMPILER_IGNORE_BEGIN.*#COMPILER_IGNORE_END/m, Comment::Special, :pop!
	rule /.*[^.]/, Comment::Single, :pop!
      end

      state :string do
        rule /\\./, Str::Escape
	rule /\"/, Str, :pop!
	rule /(\$\()/ do
	  token Punctuation
	  push :expression
	end
	rule /[^\\\n\"\$]+/, Str
	rule /\$/, Str
      end

      state :expression do
        rule identifier, Name::Variable

	rule /(\()/ do
	  token Punctuation
	  push :expression
	end
	rule /\)/, Punctuation, :pop!

        rule %r/[\[\]{}.,:;]/, Punctuation
        rule %r/(and|or)\b/, Operator::Word
        rule %r/[\~\!\?\$\@\*\/\+\-\<\>\=\&\^\%|]|!=/, Operator

        rule %r/0b(_?[0-1])+/i, Num::Bin
        rule %r/0o(_?[0-7])+/i, Num::Oct
        rule %r/0x(_?[a-f0-9])+/i, Num::Hex

	exponentPart = /e [+-]? [0-9]+/ix
	decimalInteger = /0 | [1-9] [0-9]*/x
	decimalNumber = /#{decimalInteger}?\.[0-9]/

        decimalLiteral = %r/([1-9](_?[0-9])*|0)/
        floatLiteral = /(#{decimalNumber}#{exponentPart}?)|(#{decimalInteger}#{exponentPart})/

	 #quantified number
	rule /(#{floatLiteral}|#{decimalLiteral})([a-zA-Z&&[^e]])([a-zA-Z]*)/, Num
	rule /(#{floatLiteral})/, Num::Float
	rule /#{decimalLiteral}/, Num::Integer

      end

      state :funcDef do
        rule identifier, Name::Function
	rule /\(/ do
	  token Punctuation
	  push :funcVarbDef
	end
	rule /\)/, Punctuation, :pop!
      end

      state :funcVarbDef do
	rule identifier do
	  token Name::Variable
	  push :funcDefAfterVarb
	end
	rule %r/ +/, Text
	rule %r/(?=\))/, Generic::Deleted, :pop!
      end

      state :funcDefAfterVarb do
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
	    token Name::Class
	  end
	rule %r/ +/, Text
	rule %r/\:/, Punctuation
	rule %r/(\,)|(?=\()/, Punctuation, :pop!
	mixin :expression
      end

      state :funcCall do
	rule %r/\(/, Punctuation
	rule identifier do
	  token Name::Variable
	  push :funcVarbVal
	end
	rule %r/ +/, Text
	rule %r/\)/, Punctuation, :pop!
      end

      state :funcVarbVal do
	mixin :identifier
	rule %r/ +/, Text
	rule %r/\:/, Punctuation
	rule %r/(\,)|(?=\))/, Punctuation, :pop!
	mixin :expression
      end

      state :identifier do
        rule identifier do |m|
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
      end


      state :classname do
        rule identifier, Name::Class
	rule %r/\./, Punctuation
	rule %r/:/, Punctuation, :pop!
      end

      state :variableName do
	rule identifier, Name::Attribute, :pop!
      end

      state :afterVarb do
	rule %r/\:/, Punctuation
	rule %r/ +/, Text
	rule %r/#{identifier}(?=\()/ do
	  token Name::Class
	  push :constrCall
	end 
	rule identifier, Name::Class, :pop!
	rule %r/\)/, Punctuation, :pop!
      end

      state :constrCall do
	rule %r/\(/, Punctuation
	rule identifier do
	  token Name::Variable
	  push :funcVarbVal
	end
	rule %r/ +/, Text
	rule %r/(?=\))/, Punctuation, :pop!
      end

      state :afterIs do
	rule %r/[ ]+((first)|(only)|(also))/, Keyword, :pop!
	rule %r//, Generic::Deleted, :pop!
      end

    end
  end
end
