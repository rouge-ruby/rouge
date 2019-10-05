# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Agda < RegexLexer
      title "Agda"
      desc "The Agda programming language and proof assistant"
      tag "agda"
      filenames "*.agda"
      mimetypes "text/x-agda"

      reserved = %w(
        abstract codata coinductive constructor data field forall hiding in
        inductive infix infixl infixr instance let mutual pattern postulate
        primitive private record renaming rewrite syntax tactic variable using
        module where with open import as
      )

      state :root do
        rule %r/^--.*/, Comment

        rule %r/\b(?:#{reserved.join('|')})\b/, Keyword::Reserved

        rule %r/\(|\)/, Punctuation
        rule %r/\{|\}/, Punctuation

        rule %r/\s+(=)\s+|(:)/, Operator

        rule %r/./, Text
      end
    end
  end
end
