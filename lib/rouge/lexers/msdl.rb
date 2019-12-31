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

      @@indents = [[0, :none]]
      @@scope = :none
      @@isClassDef = false
      @@isScenarioDef = false
      @@isExtend = false
      @@hasDot = false
      @@expectingIndent = false

      def self.keywords
        @keywords ||= %w(
          any cover def default do empty
          import actor scenario type event modifier extend
          is keep like label
          not outer properties sample soft struct
          undefined when with
        ) # is first, is only, is also and list of are handled later 
      end

      def self.class_defs
        @class_defs ||= %w(actor scenario modifier extend)
      end

      def self.keywords_pseudo
        @builtins_pseudo ||= %w(true false null this it)
      end

      def self.operator_scenarios
        @operator_scenarios ||= %w(
          first_of if else match multi_match mix one_of parallel repeat serial try
        )
      end

      def self.annoying_scenarios
        @annoying_scenarios ||= %w(emit wait call)
      end

      def self.annoying_modifiers
        @annoying_modifiers ||= %w(in on)
      end

      identifier = /[a-z_][a-z0-9_]*/i

      state :root do
        rule(//) do
          reset_lexer
          push :top
        end
      end

      def reset_lexer()
        @@indents = [[0, :none]]
        @@scope = :none
        @@isClassDef = false
        @@isScenarioDef = false
        @@isExtend = false
        @@hasDot = false
        @@expectingIndent = false
        reset_stack
      end

      state :top do
        mixin :baseRules
        mixin :whitespaceCountIndent
      end

      state :baseRules do
	rule(/(?<=^|\n)\h*\$.*?[.[^.]]*?\$end/, Comment::Preproc)
	rule(/(?<=^|\n)\h*\$.*/, Comment::Preproc)

	rule %r(/\*.*\*/)m, Comment::Multiline
	rule(/(\#)/) do
	  token Comment
	  push :commentOrIgnore
	end

	rule(/(")/) do
	  groups Str, Text
	  push :string
	end

        rule %r/(and|or)\b/, Operator::Word
        rule %r/[\~\!\?\$\*\/\+\-\<\>\=\&\^\%|]|!=/, Operator

	rule %r/list +of/, Keyword

        rule %r/(def)((?:[^\S\n])+)/ do
          groups Keyword, Text
          @@scope = :none
        end

	mixin :label
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
	rule(/(#{floatLiteral}|#{decimalLiteral})([a-zA-Z&&[^e]])([a-zA-Z]*)/, Num)
	rule(/(#{floatLiteral})/, Num::Float)
	rule(/#{decimalLiteral}/, Num::Integer)

        rule(/\(/) do
          token Punctuation
          push :brackets
        end
        rule %r/\.\./, Punctuation
        rule %r/[\[\]){}.,:;\\\@]/, Punctuation

      end

      state :commentOrIgnore do
        rule(/COMPILER_SKIP_FILE.*/m, Comment::Special, :pop!)
	rule(/COMPILER_IGNORE_BEGIN.*#COMPILER_IGNORE_END/m, Comment::Special, :pop!)
	rule(/.*$/, Comment::Single, :pop!)
      end

      state :string do
        rule(/\\./, Str::Escape)
	rule(/\"/, Str, :pop!)
	rule(/(\$\()/) do
	  token Punctuation
	  push :expression
	end
	rule(/[^\\\n\"\$]+/, Str)
	rule(/\$/, Str)
      end

      state :expression do
        rule identifier, Name::Variable
	rule %r/ /, Text::Whitespace

	rule(/(\()/) do
	  token Punctuation
	  push :expression
	end
	rule(/\)/, Punctuation, :pop!)

        rule %r/\.\./, Punctuation
        rule %r/[\[\]{}.,:;\@]/, Punctuation
        rule %r/(and|or)\b/, Operator::Word
        rule %r/[\~\!\?\$\*\/\+\-\<\>\=\&\^\%|]|!=/, Operator

        rule %r/0b(_?[0-1])+/i, Num::Bin
        rule %r/0o(_?[0-7])+/i, Num::Oct
        rule %r/0x(_?[a-f0-9])+/i, Num::Hex

	exponentPart = /e [+-]? [0-9]+/ix
	decimalInteger = /0 | [1-9] [0-9]*/x
	decimalNumber = /#{decimalInteger}?\.[0-9]/

        decimalLiteral = %r/([1-9](_?[0-9])*|0)/
        floatLiteral = /(#{decimalNumber}#{exponentPart}?)|(#{decimalInteger}#{exponentPart})/

	 #quantified number
	rule(/(#{floatLiteral}|#{decimalLiteral})([a-zA-Z&&[^e]])([a-zA-Z]*)/, Num)
	rule(/(#{floatLiteral})/, Num::Float)
	rule(/#{decimalLiteral}/, Num::Integer)

      end

      state :label do
        rule(/#{identifier}(?=\:)/) do |m|
          parseIdentifier(m[0], Name::Label)
        end
        rule(/\:/, Punctuation)
      end

      state :identifier do
        rule identifier do |m|
          parseIdentifier(m[0], Name)
        end
      end

      state :scopeDependantIdentifier do
        rule identifier do |m|
          parseIdentifier(m[0], getTokenByScope)
        end
      end

      def parseIdentifier(identifier, tk, sceOrModContext = false)
        if self.class.keywords.include? identifier
          token Keyword, identifier
          if identifier == "with"
            @@scope = :with
            push :withBlockOrBrackets
          elsif self.class.class_defs.include? identifier
            @@isScenarioDef = identifier == "scenario" or identifier == "modifier"
            @@isExtend = identifier == "extend"
            @@hasDot = false
            push :classname
          elsif identifier == "do"
            @@scope = :do
             push :do
          elsif identifier == "is"
            push :afterIs
          elsif identifier == "label"
            push :labelBracketsStart
          end
        elsif self.class.keywords_pseudo.include? identifier
          token Keyword::Pseudo, identifier
	elsif self.class.operator_scenarios.include? identifier
          token Keyword::Declaration, identifier
          @@scope = :op
          @@expectingIndent = true
          push :sceAndModBlock
	elsif self.class.annoying_scenarios.include? identifier and sceOrModContext
          token Name::Entity, identifier
	elsif self.class.annoying_modifiers.include? identifier and sceOrModContext
          token Name::Attribute, identifier
          if identifier == "on"
            @@scope = :op
            @@expectingIndent = true
            push :sceAndModBlock
          end
        else
          token tk, identifier
        end
      end

      def getTokenByScope()
        case @@scope
        when :none
          Name
        when :scenarioBody
          Name::Attribute
        when :do
          Name::Entity
        when :op
          Name::Entity
        when :with
          Name::Attribute
        end
      end

      state :withBlockOrBrackets do
        rule %r/ /, Text::Whitespace
        rule %r/\(/ do
          token Punctuation
          goto :modifierBrackets
        end
        rule %r/\:/ do
          token Punctuation
        end
        rule %r/ *(?=\n|\#)/ do
          token Text::Whitespace
          @@expectingIndent = true
          goto :sceAndModBlock
        end
        rule %r// do
          goto :modifierLines
        end
      end

      state :sceAndModBlock do
        rule(/((?: *\n)+)( *)(#{identifier})\:( *)(#{identifier})(?=\()/) do |m|
          token Text::Whitespace, m[1]
          updateIndentStack(m[2].length, @@indents)
          token Text::Whitespace, m[2]

          parseIdentifier(m[3], Name::Label)

          token Punctuation, ":"
          token Text::Whitespace, m[4]

          parseIdentifier(m[5], getTokenByScope())
        end


        rule(/((?: *\n)+)( *)(#{identifier})(?=\()/) do |m|
          token Text::Whitespace, m[1]
          updateIndentStack(m[2].length, @@indents)
          token Text::Whitespace, m[2]
          parseIdentifier(m[3], getTokenByScope())
        end

        rule(/((?: *\n)+)( *)(#{identifier})\:( *)(#{identifier})\.(?!\.)/) do |m|
          token Text::Whitespace, m[1]
          updateIndentStack(m[2].length, @@indents)
          token Text::Whitespace, m[2]

          parseIdentifier(m[3], Name::Label)

          token Punctuation, ":"
          token Text::Whitespace, m[4]

          parseIdentifier(m[5], Name)
          token Punctuation, "."
          push :path
        end


        rule(/((?: *\n)+)( *)(#{identifier})\.(?!\.)/) do |m|
          token Text::Whitespace, m[1]
          updateIndentStack(m[2].length, @@indents)
          token Text::Whitespace, m[2]
          parseIdentifier(m[3], Name)
          token Punctuation, "."
          push :path
        end

        rule(/list +of/, Keyword)

        mixin :label
        rule identifier do |m|
          parseIdentifier(m[0], Name, true)
        end

	mixin :whitespaceCountIndent
        mixin :baseRules
      end

      state :do do
        rule %r/ /, Text::Whitespace
        rule(/#{identifier}(?=\.[^\.])/) do |m|
          goto :path
          parseIdentifier(m[0], Name)
        end
        rule identifier do |m|
          pop!
          if self.class.operator_scenarios.include? m[0]
            token Keyword::Declaration
            @@scope = :op
            @@expectingIndent = true
            push :sceAndModBlock
          else
            token Name::Entity
          end
        end
      end

      state :whitespace do
        rule(/\n+/) do
          token Text::Whitespace
        end
        rule %r/ +/, Text::Whitespace
      end

      state :whitespaceCountIndent do
        rule(/((?: *\n)+)( *)(?![\s\#])/) do |m|
          token Text::Whitespace, m[1]
          updateIndentStack(m[2].length, @@indents)
          token Text::Whitespace, m[2]
        end
        rule(/(?: *\n)+ *(?=\#)/, Text::Whitespace)
        rule %r/ +/, Text::Whitespace
      end

      def updateIndentStack(indent, indentStack)
        if indent < indentStack[0][0]
          while indent < indentStack[0][0]
            if indentStack[0][1] != :none
              pop!
            end
            indentStack.shift
          end
          @@scope = indentStack[0][1]
        elsif indent > indentStack[0][0] and @@expectingIndent
          indentStack.unshift([indent, @@scope])
          @@scope = indentStack[0][1]
          @@expectingIndent=false
        end
      end

      state :path do
        rule(/#{identifier}(?=\.[^\.])/) do |m|
          parseIdentifier(m[0], Name)
        end
        rule %r/\./, Punctuation
        rule identifier do |m|
          parseIdentifier(m[0], getTokenByScope())
          pop!
        end
      end

      state :classname do
        rule %r/ /, Text::Whitespace
        rule identifier, Name::Class
        rule %r/\./ do
          token Punctuation
          @@hasDot = true
        end
        rule %r/:/ do
          token Punctuation
          pop!
          if @@isScenarioDef or (@@isExtend and @@hasDot)
            @@scope = :scenarioBody
            @@expectingIndent = true
            push :sceAndModBlock
          end
        end
      end

      state :brackets do
        rule(/\)/, Punctuation, :pop!)
        mixin :baseRules
        mixin :whitespace
      end

      state :labelBrackets do
        rule(/\)/, Punctuation, :pop!)
        rule identifier, Name
        mixin :baseRules
        mixin :whitespace
      end

      state :modifierBrackets do
        rule(/\)/) do
          token Punctuation
          pop!
          @@scope = @@indents[0][1]
        end
        rule(/\(/) do
          token Punctuation
          push :brackets
        end
        mixin :label
        mixin :scopeDependantIdentifier
        rule %r/\.\./, Punctuation
        rule %r/[\[\]{}.,:;\@]/, Punctuation
        mixin :whitespace
      end

      state :modifierLines do
        rule %r/\n/ do
          token Text::Whitespace
          @@scope = @@indents[0][1]
          pop!
        end
        rule(/\#/) do
          token Comment
          @@scope = @@indents[0][1]
          goto :commentOrIgnore
        end
        rule %r/ +/, Text::Whitespace
        mixin :label
        mixin :scopeDependantIdentifier
        mixin :baseRules
      end

      state :afterIs do
	rule %r/[ ]+((first)|(only)|(also))/, Keyword, :pop!
	rule %r//, Generic::Deleted, :pop!
      end

      state :labelBracketsStart do
        rule %r/ /, Text::Whitespace
        rule %r/\(/ do
          token Punctuation
          goto :labelBrackets
        end
      end

    end
  end
end
