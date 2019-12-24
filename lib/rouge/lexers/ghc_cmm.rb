# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class GHCCmm < RegexLexer
      title "GHC Cmm (C--)"
      desc "Intermediate representation of the GHC Haskell compiler."
      tag 'ghc-cmm'
      filenames '*.dump-cmm', '*.dump-cmm-*'

      state :root do
        # sections
        rule %r/^=====.*=====$/, Generic::Heading
        # timestamps
        rule %r/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d+ UTC$/, Comment::Single

        rule %r/\[\]/, Punctuation

        mixin :section

        # rest is Text
        rule %r/\s/m, Text
        rule %r/./, Text
      end

      state :section do
        rule %r/\/{2}.*/, Comment::Single
        rule %r/-?[0-9]+/, Literal::Number::Integer

        rule %r/Sp(?![a-zA-Z0-9#\$])/, Name::Variable::Global
        rule %r/SpLim(?![a-zA-Z0-9#\$])/, Name::Variable::Global
        rule %r/[+\-*\/<>=]/, Operator

        rule %r/\(likely.*?\)/, Comment

        rule %r/[\[\].{}:;,()]/, Punctuation
        rule %r/section/, Keyword::Reserved
        rule %r/const/, Keyword::Constant
        rule %r/"data"/, Name::Builtin
        rule %r/"cstring"/, Name::Builtin
        rule %r/"/, Literal::String::Double

        rule %r/if/, Keyword
        rule %r/else/, Keyword
        rule %r/goto/, Keyword

        rule %r/I\d{1,2}\[\]/, Keyword::Type
        rule %r/[A-Z]\w+(?=\.)/, Name::Namespace
        rule %r/[\w#\$]+/, Name::Label
        rule %r/\s/m, Text
      end
    end
  end
end
