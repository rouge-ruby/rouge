# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class GHCCmm < RegexLexer
      title "GHC Cmm (C--)"
      desc "Intermediate representation of the GHC Haskell compiler."
      tag 'ghc-cmm'
      filenames '*.cmm', '*.dump-cmm', '*.dump-cmm-*'

      state :root do
        # sections
        rule %r/^=====.*=====$/, Generic::Heading
        # timestamps
        rule %r/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d+ UTC$/, Comment::Single

        rule %r/(?=section\s+"")/ do
          push :section
        end

        rule %r/\[\]/, Punctuation

        mixin :preprocessor_macros

        mixin :comments
        mixin :literals
        mixin :operators_and_keywords
        mixin :infos
        mixin :names

        # rest is Text
        rule %r/\s/m, Text
        rule %r/./, Text
      end

      state :preprocessor_macros do
        rule %r/(#if)( +)(defined)/ do |m|
          token Comment::Preproc, m[1]
          token Text, m[2]
          token Comment::Preproc, m[3]
        end

        rule %r/#include|#endif|#else|#define/, Comment::Preproc
      end

      state :comments do
        rule %r/\/{2}.*/, Comment::Single
        rule %r/\(likely.*?\)/, Comment
        rule %r/\/\*.*?\*\//m, Comment::Multiline
      end

      state :literals do
        rule %r/-?[0-9]+/, Literal::Number::Integer
        rule %r/"/, Literal::String::Delimiter, :literal_string
      end

      state :literal_string do
        # quotes
        rule %r/\\./, Literal::String::Escape
        rule %r/"/, Literal::String::Delimiter, :pop!
        rule %r/./, Literal::String
      end

      state :section do
        rule %r/section/, Keyword::Reserved
        rule %r/"data"/, Name::Builtin
        rule %r/"cstring"/, Name::Builtin

        rule %r/{/, Punctuation, :pop!

        mixin :names
        mixin :operators_and_keywords

        rule %r/\s/, Text
      end

      state :operators_and_keywords do
        rule %r/[+\-*\/<>=!&]/, Operator

        rule %r/[\[\].{}:;,()]/, Punctuation
        rule %r/const/, Keyword::Constant
        rule %r/"/, Literal::String::Double

        rule %r/if|else|goto|call|offset|import/, Keyword

        rule %r/(returns)( +?)(to)/ do |m|
          token Keyword, m[1]
          token Text, m[2]
          token Keyword, m[3]
        end
      end

      state :infos do
        rule %r/(args|res|upd|label|rep|srt|arity|fun_type|arg_space|updfr_space)(:)/ do |m|
          token Name::Property, m[1]
          token Punctuation, m[2]
        end

        rule %r/(info_tbls|stack_info)(:)/ do |m|
          token Name::Entity, m[1]
          token Punctuation, m[2]
        end
      end

      state :names do
        rule %r/(Sp|SpLim|Hp|HpLim|HpAlloc|BaseReg|CurrentNursery|CurrentTSO|R\d{1,2})(?![a-zA-Z0-9#\$_])/, Name::Variable::Global
        rule %r/[IPF]\d{1,3}\[\]/, Keyword::Type
        rule %r/[IPF]\d{1,3}(?=[\[\]()\s])/, Keyword::Type
        rule %r/[A-Z]\w+(?=\.)/, Name::Namespace
        rule %r/[\w#\$]+/, Name::Label
      end
    end
  end
end
