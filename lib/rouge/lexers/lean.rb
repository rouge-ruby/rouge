# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Lean < RegexLexer
      title "lean"
      desc 'Lean (leanprover.github.io)'
      tag 'lean'
      mimetypes 'text/x-lean'

      keywords = Set.new %w(
        import abbreviation opaque_hint tactic_hint definition
        renaming inline hiding exposing parameter parameters
        conjecture hypothesis lemma corollary variable variables
        theorem axiom inductive structure universe universes alias hott
        help options precedence postfix prefix calc_trans
        calc_subst calc_refl infix infixl infixr notation eval
        check exit coercion private using namespace include
        including instance section context protected expose
        export set_option add_rewrite extends open example
        constant constants print opaque reducible irreducible
      )

      tac = %w(
        forall fun Pi obtain from have show assume
        take let if else then by in with begin end
        proof qed calc match
      )

      operators = %w(
        != # & && \* \+ - / @ ! ` -\. ->
        \. \.\. \.\.\. :: :> ; ;; <
        <- = == > _ \| \|\| ~ => <= >=
        /\ \/ ∀ Π λ ↔ ∧ ∨ ≠ ≤ ≥ ⊎
        ¬ ⁻¹ ⬝ ▸ → ∃ ℕ ℤ ≈ × ⌞ ⌟ ≡ ⟨ ⟩
      )

      punctuation = %w@\( \) : \{ \} , \[ \] ⦃ ⦄ :=@

      name_start = "A-Za-z_\u03b1-\u03ba\u03bc-\u03fb\u1f00-\u1ffe\u2100-\u214f"
      name_mid1 = "A-Za-z_'\u03b1-\u03ba\u03bc-\u03fb\u1f00-\u1ffe\u2070-\u2079"
      name_mid2 = "\u207f-\u2089\u2090-\u209c\u2100-\u214f0-9."
      name = %r([#{name_start}][#{name_mid1}#{name_mid2}]*)

      state :root do
        rule /\s+/m, Text::Whitespace
        rule %r(/-), Comment::Multiline, :comment
        rule /--.*$/, Comment::Single
        rule /\"/, Str, :string
        rule /\d+/, Num::Integer
        rule /[~?][a-z][\w\']*:/, Name::Variable
        rule name do |m|
          name = m[0]
          if keywords.include? name
            token Keyword
          elsif tac.include? name
            token Keyword::Pseudo
          else
            token Name
          end
        end
        rule %r(#{operators.join('|')}), Name::Builtin::Pseudo
        rule %r(#{punctuation.join('|')}), Operator
        # rule %r@\(@, Operator
      end

      state :comment do
        rule %r([^/-]+), Comment::Multiline
        rule(%r(/-)) { token Comment::Multiline; push }
        rule %r(-/), Comment::Multiline, :pop!
        rule /-/, Comment::Multiline
      end

      state :string do
        rule /[^\\\"]+/, Str
        rule /\\[n\"\\]/, Str::Escape
        rule /\"/, Str, :pop!
      end
    end
  end
end
