# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class GHCCmm < RegexLexer
      title "GHC Cmm (C--)"
      desc "Intermediate representation of the GHC Haskell compiler."
      tag 'ghc-cmm'
      filenames '*.cmm', '*.dump-cmm', '*.dump-cmm-*'

      # todo use this pattern where ever possible
      ws = %r(\s|//.*?\n|/[*].*?[*]/)

      state :root do
        rule %r/\s+/m, Text

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

        rule %r{(?=[\w#\$%_']+#{ws}*\()} do
          push :function
        end

        # Memory access
        rule %r/([\w#\$%_']+)(?=\[[^\]])/ do |m|
          token Keyword::Type, m[1]
        end

        # Array type
        rule %r/([\w#\$%_']+\[\])/ do |m|
          token Keyword::Type, m[1]
        end

        rule %r/(?=[\w#\$%_']+(\s|\/\/.*?\n|\/[*].*?[*]\/)+{)/ do
          push :function_explicit_stack
        end

        rule %r/(^[\w#\$_']+)(?=(\s|\/\/.*?\n|\/[*].*?[*]\/)+[\w#\$_]+(\s|\/\/.*?\n|\/[*].*?[*]\/)*[),;])/ do |m|
          token Keyword::Type, m[1]
        end

        mixin :infos
        mixin :names

        # rest is Text
        rule %r/./, Text
      end

      state :function do
        rule %r/INFO_TABLE_FUN|INFO_TABLE_CONSTR|INFO_TABLE_SELECTOR|INFO_TABLE_RET|INFO_TABLE/, Name::Builtin
        rule %r/%[\w#\$_%']+/, Name::Builtin
        rule %r/[\w#\$_%']+/, Name::Function
        rule %r/\s+/, Text
        rule %r/[()]/, Punctuation, :pop!
        mixin :comments
      end

      state :function_explicit_stack do
        rule %r/%[\w#\$_%']+/, Name::Builtin
        rule %r/[\w#\$_%']+/, Name::Function
        mixin :comments
        rule %r/\s+/, Text
        rule %r/[{]/, Punctuation, :pop!
      end

      state :preprocessor_macros do
        rule %r/#include|#endif|#else|#if/, Comment::Preproc

        rule %r{
            (\#define)
            (#{ws}*)
            ([\w#\$_%']+)
          }mx do |m|
          token Comment::Preproc, m[1]
          recurse m[2]
          token Name::Label, m[3]
        end
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
        rule %r/%./, Literal::String::Symbol
        rule %r/"/, Literal::String::Delimiter, :pop!
        rule %r/./, Literal::String
      end

      state :section do
        rule %r/section/, Keyword::Reserved
        rule %r/"(data|cstring|text|rodata|relrodata|bss)"/, Name::Builtin

        rule %r/{/, Punctuation, :pop!

        mixin :names
        mixin :operators_and_keywords

        rule %r/\s/, Text
      end

      state :operators_and_keywords do
        rule %r/\.\./, Operator
        rule %r/[+\-*\/<>=!&|~]/, Operator
        rule %r/(::)(#{ws}*)([A-Z]\w+)/ do |m|
          token Operator, m[1]
          recurse m[2]
          token Keyword::Type, m[3]
        end

        rule %r/[\[\].{}:;,()]/, Punctuation
        rule %r/const/, Keyword::Constant
        rule %r/"/, Literal::String::Double

        rule %r/(returns)(#{ws}*)(to)/ do |m|
          token Keyword, m[1]
          recurse m[2]
          token Keyword, m[3]
        end

        rule %r/(never)(#{ws}*)(returns)/ do |m|
          token Keyword, m[1]
          recurse m[2]
          token Keyword, m[3]
        end

        rule %r{return(?=(#{ws}*)\()}, Keyword
        rule %r{(if|else|goto|call|offset|import|jump|ccall|foreign|prim|switch|case|unwind)(?=#{ws})}, Keyword
        rule %r{(export|reserve|push)(?=#{ws})}, Keyword
        rule %r{(default)(?=#{ws}*:)}, Keyword
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
        rule %r/(Sp|SpLim|Hp|HpLim|HpAlloc|BaseReg|CurrentNursery|CurrentTSO|R\d{1,2}|gcptr)(?![a-zA-Z0-9#\$_])/, Name::Variable::Global
        rule %r/CLOSURE/, Keyword::Type
        rule %r/True|False/, Name::Builtin
        rule %r/[A-Z]\w+(?=\.)/, Name::Namespace
        rule %r/[\w#\$%_']+/, Name::Label # todo extract constant, this appears in some positions
      end
    end
  end
end
