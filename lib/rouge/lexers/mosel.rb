# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Mosel < RegexLexer
      tag 'mosel'
      filenames '*.mos'
      title "Mosel"
      desc "An optimization language used by Fico's Xpress."
      # http://www.fico.com/en/products/fico-xpress-optimization-suite
      filenames '*.mos'

      mimetypes 'text/x-mosel'

      id = /[a-zA-Z_][a-zA-Z0-9_]*/

      lazy { require_relative 'mosel/keywords' }


      state :whitespace do
        # Spaces
        rule %r/\s+/m, Text
        # ! Comments
        rule %r((!).*$\n?), Comment::Single
        # (! Comments !)
        rule %r(\(!.*?!\))m, Comment::Multiline

      end


      # From Mosel documentation:
      # Constant strings of characters must be quoted with single (') or double quote (") and may extend over several lines. Strings enclosed in double quotes may contain C-like escape sequences introduced by the 'backslash'
      # character (\a \b \f \n \r \t \v \xxx with xxx being the character code as an octal number).
      # Each sequence is replaced by the corresponding control character (e.g. \n is the `new line' command) or, if no control character exists, by the second character of the sequence itself (e.g. \\ is replaced by '\').
      # The escape sequences are not interpreted if they are contained in strings that are enclosed in single quotes.

      state :single_quotes do
        rule %r/'/, Str::Single, :pop!
        rule %r/[^']+/, Str::Single
      end

      state :double_quotes do
        rule %r/"/, Str::Double, :pop!
        rule %r/(\\"|\\[0-7]{1,3}\D|\\[abfnrtv]|\\\\)/, Str::Escape
        rule %r/[^"]/, Str::Double
      end

      state :base do

        rule %r{"}, Str::Double, :double_quotes
        rule %r{'}, Str::Single, :single_quotes

        rule %r{((0(x|X)[0-9a-fA-F]*)|(([0-9]+\.?[0-9]*)|(\.[0-9]+))((e|E)(\+|-)?[0-9]+)?)(L|l|UL|ul|u|U|F|f|ll|LL|ull|ULL)?}, Num
        rule %r{[~!@#\$%\^&\*\(\)\+`\-={}\[\]:;<>\?,\.\/\|\\]}, Punctuation
#        rule %r{'([^']|'')*'}, Str
#        rule %r/"(\\\\|\\"|[^"])*"/, Str



        rule %r/(true|false)\b/i, Name::Builtin

        # Handle the extremely special case of core keywords being valid if they are *all* upper case,
        # but not *partially* upper case.
        #
        # ref: https://www.fico.com/fico-xpress-optimization/docs/latest/mosel/mosel_lang/dhtml/moselreflang.html?scroll=seclangintro_2
        # > Note that, although the lexical analyzer of Mosel is case-sensitive,
        # > the reserved words are defined both as lower and upper case (i.e. AND
        # > and and are keywords but not And).
        rule id do |m|
          fallthrough! unless CORE_KEYWORDS.include?(m[0].downcase)
          fallthrough! unless m[0].match?(/\A[A-Z_]+\z|\A[a-z_]+\z/)
          token Keyword
        end

        keywords id do
          rule CORE_FUNCTIONS, Name::Builtin
          rule MMXPRS_FUNCTIONS, Name::Function
          rule MMXPRES_CONSTANTS, Name::Constant
          rule MMXPRS_PARAMETERS, Name::Property
          rule MMSYSTEM_FUNCTIONS, Name::Function
          rule MMSYSTEM_PARAMETERS, Name::Property
          rule MMJOBS_FUNCTIONS, Name::Function
          rule MMJOBS_PARAMETERS, Name::Property
          default Name
        end
      end

      state :root do
        mixin :whitespace
        mixin :base
      end
    end
  end
end
