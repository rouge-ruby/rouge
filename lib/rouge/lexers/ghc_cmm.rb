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

        # rest is Text
        rule %r/\s/m, Text
        rule %r/.*/, Text
      end
    end
  end
end
