# -*- coding: utf-8 -*- #
# frozen_string_literal: true

# NOTE: This is for Lean 3 (community fork).
module Rouge
  module Lexers
    class Lean < RegexLexer
      title 'Lean'
      desc 'The Lean programming language (leanprover.github.io)'
      tag 'lean'
      aliases 'lean'
      filenames '*.lean'

      def self.keywords
        @keywords ||= Set.new %w(
          assume
          axiom
          begin
          by
          calc
          #check
          constant
          constants
          def
          end
          example
          #eval
          from
          fun
          have
          import
          include
          instance
          lemma
          match
          namespace
          notation
          open
          #print
          repeat
          set_option
          show
          theorem
          universe
          variable
          variables
          with
        )
      end

      state :root do

        # FIXME: using /^\s*--\s+.*?$/ makes it not match
        # comments starting after some space
        rule %r/\s*--+\s+.*?$/, Comment::Doc

        rule %r/"/, Str, :string
        rule %r/\d+/, Num::Integer

        # special commands
        rule(/#\w+/) do |m|
          match = m[0]
          if self.class.keywords.include?(match)
            token Keyword
          else
            token Name
          end
        end

        # special unicode keywords
        rule %r/[λ]/, Keyword

        # match keywords
        rule(/\w+/) do |m|
          match = m[0]
          if self.class.keywords.include?(match)
            token Keyword
          else
            token Name
          end
        end

        # ----------------
        # operators rules
        # ----------------

        rule %r/\:=?/, Text
        rule %r/\.[0-9]*/, Operator
        rule %r/\.\.\.*/, Operator

        rule %r/(->)|(<-)|[=\|\+\*\^><&@`]/, Operator
        # common operators (unicode)
        rule %r/[→←↔≠∀∃¬≥≤⊓⊔⟨⟩Π∨∧ℕ]/, Operator

        # unmatched symbols
        rule %r/[\s\(\),\[\]αβ‹›]+/, Text

        # show missing matches
        rule %r/./, Error

      end

      state :string do
        rule %r/"/, Str, :pop!
        rule %r/\\/, Str::Escape, :escape
        rule %r/[^\\"]+/, Str
      end

    end
  end
end
