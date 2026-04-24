# -*- coding: utf-8 -*- #
# frozen_string_literal: true
# Lexer adapted from https://github.com/pygments/pygments/blob/ad55974ce83b85dbb333ab57764415ab84169461/pygments/lexers/theorem.py

module Rouge
  module Lexers
    class Isabelle < RegexLexer
      title "Isabelle"
      desc 'Isabelle theories (isabelle.in.tum.de)'
      tag 'isabelle'
      aliases 'isa', 'Isabelle'
      filenames '*.thy'
      mimetypes 'text/x-isabelle'

      lazy { require_relative 'isabelle/keywords' }

      state :root do
        rule %r/\s+/, Text::Whitespace
        rule %r/\(\*/, Comment, :comment
        rule %r/\{\*|‹/, Text, :text

        rule %r/::|\[|\]|-|[:()_=,|+!?]/, Operator
        rule %r/[{}.]|\.\./, Operator::Word

        keywords %r/[a-zA-Z]\w*/ do
          rule KEYWORD_PSEUDO, Keyword::Pseudo
          rule KEYWORD_DIAG, Keyword::Type
          rule KEYWORDS, Keyword

          rule KEYWORD_SECTION, Generic::Heading
          rule KEYWORD_SUBSECTION, Generic::Subheading
          rule KEYWORD_THEORY, Keyword::Namespace
          rule KEYWORD_ABANDON_PROOF, Generic::Error
          default Name
        end

        rule %r/\\<\w*>/, Str::Symbol

        rule %r/'[^\W\d][.\w']*/, Name::Variable

        rule %r/0[xX][\da-fA-F][\da-fA-F_]*/, Num::Hex
        rule %r/0[oO][0-7][0-7_]*/, Num::Oct
        rule %r/0[bB][01][01_]*/, Num::Bin

        rule %r/"/, Str, :string
        rule %r/`/, Str::Other, :fact
        # Everything except for (most) operators whitespaces may be name
        rule %r/[^\s:|\[\]\-()=,+!?{}._][^\s:|\[\]\-()=,+!?{}]*/, Name
      end

      state :comment do
        rule %r/[^(*)]+/, Comment
        rule %r/\(\*/, Comment, :comment
        rule %r/\*\)/, Comment, :pop!
        rule %r/[(*)]/, Comment
      end

      state :text do
        rule %r/[^{*}‹›]+/, Text
        rule %r/\{\*|‹/, Text, :text
        rule %r/\*\}|›/, Text, :pop!
        rule %r/[{*}]/, Text
      end

      state :string do
        rule %r/[^"\\]+/, Str
        rule %r/\\<\w*>/, Str::Symbol
        rule %r/\\"/, Str
        rule %r/\\/, Str
        rule %r/"/, Str, :pop!
      end

      state :fact do
        rule %r/[^`\\]+/, Str::Other
        rule %r/\\<\w*>/, Str::Symbol
        rule %r/\\`/, Str::Other
        rule %r/\\/, Str::Other
        rule %r/`/, Str::Other, :pop!
      end
    end
  end
end
