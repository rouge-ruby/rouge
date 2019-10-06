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


#      def self.detect?(text)
#        return true if text.shebang?(/pythonw?(?:[23](?:\.\d+)?)?/)
#      end

      def self.keywords
        @keywords ||= %w(
          agent any call cover def defualt do else emit empty
          event extend if import!! in is[ ]+first is[ ]+only 
          is[ ]+also is keep like list of!! match modifier multi_match
          not on outer properties repeat sample scenario soft struct
          then try type undefined wait when with
        )
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
	@builtin_types ||=%w(
	  uint64 int64 uint int acceleration angle angular_speed
	  distance speed temprature time weight bool junction segment
	)
      end 

      def self.keywords_pseudo
        @builtins_pseudo ||= %w(true false null this it)
      end

      identifier =/[a-z_][a-z0-9_]*/i
      state :root do
	rule /".*"/, Str

        rule %r/\n+/m, Text
        rule %r/^(:)(\s*)([ru]{,2}""".*?""")/mi do
          groups Punctuation, Text, Str::Doc
        end

        rule %r/[^\S\n]+/, Text
        rule %r(#(.*)?\n?), Comment::Single
        rule %r/[\[\](){}.,:;]/, Punctuation
        rule %r/\\\n/, Text
        rule %r/\\/, Text

        rule %r/(and|or)\b/, Operator::Word
        rule %r/[\~\!\?\$\@\*\/\+\-\<\>\=\&\^\%|]|!=/, Operator

        rule %r/(class)((?:\s|\\\s)+)/ do
          groups Keyword, Text
          push :classname
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

	exponentPart = /[eE] [+-]? [0-9]+/
	decimalInteger = /'0' | [1-9] [0-9]*/

        fl1 = /#{decimalInteger}.[0-9]+#{exponentPart}/
        fl2 = /.[0-9]+#{exponentPart}/
        fl3 = /#{decimalInteger}#{exponentPart}/

        rule %r/0(b|B)(_?[0-1])+/i, Num::Bin
        rule %r/0(o|O)(_?[0-7])+/i, Num::Oct
        rule %r/0(x|X)(_?[a-f0-9])+/i, Num::Hex
        dl = %r/([1-9](_?[0-9])*|0)/

	rule /(#{fl1}|#{fl2}|#{fl3}|#{dl})([a-zA-Z]+)/, Num
	rule /(#{fl1}|#{fl2}|#{fl3})/, Num::Float
	rule /#{dl}/, Num::Integer

      end

      state :funcname do
        rule identifier, Name::Function, :pop!
      end

      state :classname do
        rule identifier, Name::Class, :pop!
      end

      state :raise do
        rule %r/from\b/, Keyword
        rule %r/raise\b/, Keyword
        rule %r/yield\b/, Keyword
        rule %r/\n/, Text, :pop!
        rule %r/;/, Punctuation, :pop!
        mixin :root
      end

      state :strings do
        rule %r/%(\([a-z0-9_]+\))?[-#0 +]*([0-9]+|[*])?(\.([0-9]+|[*]))?/i, Str::Interpol
      end

      state :strings_double do
        rule %r/[^\\"%\n]+/, Str
        mixin :strings
      end

      state :strings_single do
        rule %r/[^\\'%\n]+/, Str
        mixin :strings
      end

      state :nl do
        rule %r/\n/, Str
      end

      state :escape do
        rule %r(\\
          ( [\\abfnrtv"']
          | \n
          | N{[a-zA-Z][a-zA-Z ]+[a-zA-Z]}
          | u[a-fA-F0-9]{4}
          | U[a-fA-F0-9]{8}
          | x[a-fA-F0-9]{2}
          | [0-7]{1,3}
          )
        )x, Str::Escape
      end

      state :raw_escape do
        rule %r/\\./, Str
      end

      state :dqs do
        rule %r/"/, Str, :pop!
        mixin :escape
        mixin :strings_double
      end

      state :sqs do
        rule %r/'/, Str, :pop!
        mixin :escape
        mixin :strings_single
      end

      state :tdqs do
        rule %r/"""/, Str, :pop!
        rule %r/"/, Str
        mixin :escape
        mixin :strings_double
        mixin :nl
      end

      state :tsqs do
        rule %r/'''/, Str, :pop!
        rule %r/'/, Str
        mixin :escape
        mixin :strings_single
        mixin :nl
      end

      %w(tdqs tsqs dqs sqs).each do |qtype|
        state :"raw_#{qtype}" do
          mixin :raw_escape
          mixin :"#{qtype}"
        end
      end

    end
  end
end
