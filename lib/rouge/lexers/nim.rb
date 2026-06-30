# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Nim < RegexLexer
      # This is pretty much a 1-1 port of the pygments NimrodLexer class
      title "Nim"
      desc "The Nim programming language (http://nim-lang.org/)"

      tag 'nim'
      aliases 'nimrod'
      filenames '*.nim'

      KEYWORDS = Set.new %w(
        addr as asm atomic bind block break case cast const continue
        converter defer discard distinct do elif else end enum except export
        func finally for from generic if import include interface iterator let
        macro method mixin nil object of out proc ptr raise ref return static
        template try tuple type using var when while with without yield
      )

      OPWORDS = Set.new %w(
        and or not xor shl shr div mod in notin is isnot
      )

      PSEUDOKEYWORDS = Set.new %w(
        nil true false
      )

      TYPES = Set.new %w(
       int int8 int16 int32 int64 float float32 float64 bool char range array
       seq set string
      )

      NAMESPACE = Set.new %w(
        from import include
      )

      state :chars do
        rule(/\\([\\abcefnrtvl"\']|x[a-fA-F0-9]{2}|[0-9]{1,3})/, Str::Escape)
        rule(/'/, Str::Char, :pop!)
        rule(/./, Str::Char)
      end

      state :strings do
        rule(/(?<!\$)\$(\d+|#|\w+)+/, Str::Interpol)
        rule(/[^\\\'"\$\n]+/,         Str)
        rule(/[\'"\\]/,               Str)
        rule(/\$/,                    Str)
      end

      state :dqs do
        rule(/\\([\\abcefnrtvl"\']|\n|x[a-fA-F0-9]{2}|[0-9]{1,3})/,
             Str::Escape)
        rule(/"/, Str, :pop!)
        mixin :strings
      end

      state :rdqs do
        rule(/"(?!")/, Str, :pop!)
        rule(/"/,      Str::Escape, :pop!)
        mixin :strings
      end

      state :tdqs do
        rule(/"""(?!")/, Str, :pop!)
        mixin :strings
        mixin :nl
      end

      state :funcname do
        rule(/((?![\d_])\w)(((?!_)\w)|(_(?!_)\w))*/, Name::Function, :pop!)
        rule(/`.+`/,                                 Name::Function, :pop!)
      end

      state :nl do
        rule(/\n/, Str)
      end

      state :floatnumber do
        rule(/\.(?!\.)[0-9_]*/,       Num::Float)
        rule(/[eE][+-]?[0-9][0-9_]*/, Num::Float)
        rule(//,                      Text, :pop!)
      end

      # Making apostrophes optional, as only hexadecimal with type suffix
      # possibly ambiguous.
      state :floatsuffix do
        rule(/'?[fF](32|64)/,          Num::Float)
        rule(//,                      Text, :pop!)
      end

      state :intsuffix do
        rule(/'?[iI](32|64)/,          Num::Integer::Long)
        rule(/'?[iI](8|16)/,           Num::Integer)
        rule(/'?[uU]/,                 Num::Integer)
        rule(//,                      Text, :pop!)
      end

      state :root do
        rule(/##.*$/, Str::Doc)
        rule(/#.*$/,  Comment)
        rule(/\*|=|>|<|\+|-|\/|@|\$|~|&|%|\!|\?|\||\\|\[|\]/, Operator)
        rule(/\.\.|\.|,|\[\.|\.\]|{\.|\.}|\(\.|\.\)|{|}|\(|\)|:|\^|`|;/,
             Punctuation)

        # Strings
        rule(/(?:\w+)"/,Str, :rdqs)
        rule(/"""/,       Str, :tdqs)
        rule(/"/,         Str, :dqs)

        # Char
        rule(/'/, Str::Char, :chars)

        rule(/(p_?r_?o_?c_?\s)(?![\(\[\]])/, Keyword, :funcname)

        # Keywords and Identifiers
        keywords %r/(?![_\d])\w+/ do
          # underscores can be used freely in idents
          transform { |word| word.delete('_') }

          rule OPWORDS,        Operator::Word
          rule KEYWORDS,       Keyword
          rule NAMESPACE,      Keyword::Namespace
          rule Set['var'],     Keyword::Declaration
          rule TYPES,          Keyword::Type
          rule PSEUDOKEYWORDS, Keyword::Pseudo
          default Name
        end

        # Numbers
        # Note: Have to do this with a block to push multiple states first,
        #       since we can't pass array of states like w/ Pygments.
        rule(/[0-9][0-9_]*(?=([eE.]|'?[fF](32|64)))/) do
          push :floatsuffix
          push :floatnumber
          token Num::Float
        end

        rule(/0[xX][a-fA-F0-9][a-fA-F0-9_]*/, Num::Hex,     :intsuffix)
        rule(/0[bB][01][01_]*/,               Num,          :intsuffix)
        rule(/0o[0-7][0-7_]*/,                Num::Oct,     :intsuffix)
        rule(/[0-9][0-9_]*/,                  Num::Integer, :intsuffix)

        # Whitespace
        rule(/\s+/, Text)
        rule(/.+$/, Error)
      end

    end
  end
end
