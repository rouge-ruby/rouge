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

      pragmas = %w(
        BUILTIN CATCHALL COMPILE FOREIGN DISPLAY ETA IMPOSSIBLE INJECTIVE
        INLINE NOINLINE LINE MEASURE NO_POSITIVITY_CHECK NO_TERMINATION_CHECK
        NO_UNIVERSE_CHECK NON_COVERING NON_TERMINATING OPTIONS POLARITY REWRITE
        STATIC TERMINATING WARNING_ON_USAGE WARNING_ON_IMPORT
      )

      # These exclude the reflection builtins because there are too many
      # See https://agda.readthedocs.io/en/latest/language/reflection.html
      builtins = %w(
        UNIT SIGMA LIST MAYBE BOOL TRUE FALSE NATURAL NATPLUS NATMINUS NATTIMES
        NATEQUALS NATLESS NATDIVSUCAUX NATMODSUCAUX WORD64 INTEGER INTEGERPOS
        INTERGERNEGSUC FLOAT CHAR STRING EQUALITY TYPE PROP SETOMEGA LEVEL
        LEVELZERO LEVELSUC LEVELMAX SIZEUNIV SIZE SIZELT SIZESUC SIZEINF
        SIZEMAX INFINITY SHARP FLAT IO REWRITE FROMNAT FROMNEG FROMSTRING
      )

      reserved = %w(
        abstract codata coinductive constructor data do eta-equality field
        forall import in inductive infix infixl infixr instance interleaved let
        macro module mutual no-eta-equality open overlap pattern postulate
        primitive private quote quoteTerm record rewrite syntax tactic unquote
        unquoteDecl unquoteDef variable where with
        using hiding renaming to public
      )

      state :root do
        # Comments can stick behind some punctuation
        rule %r/(^|[\s\(\)\{\}\.;])(--.*)$/ do
          groups Punctuation, Comment
        end
        rule %r/{-#/, Comment::Preproc, :pragma
        rule %r/{-/, Comment::Multiline, :comment
        rule %r/{!/, Comment::Special, :hole

        # Keywords
        rule %r/\b(#{reserved.join('|')})\b/, Keyword::Reserved

        # Agda primitives (see https://agda.github.io/agda-stdlib/Agda.Primitive.html)
        # Do we also want to do built-ins (see https://agda.readthedocs.io/en/latest/language/built-ins.html)?
        rule %r/\b(Level)\b/, Keyword::Type
        rule %r/\b(lsuc|lzero)/, Name::Builtin
        rule %r/\b(Prop[₀₁₂₃₄₅₆₇₈₉]*|S?Set(ω?|[₀₁₂₃₄₅₆₇₈₉]*))\b/, Keyword::Type

        # Attributes
        rule %r/@flat|@♭|@⊤/, Name::Attribute
        rule %r/(@)(\()(tactic)/ do
          groups Name::Attribute, Punctuation, Name::Attribute
        end

        # Punctuation, including idiom brackets, instance arguments
        # The way that ..., .., and . are handled could be more refined
        # Should unmatched parentheses, braces, and brackets be lexical errors?
        rule %r/[\(\)\{\}\.;]/, Punctuation
        rule %r/\(\|\)/, Punctuation
        rule %r/(\(\|)(\s+)/ do
          groups Punctuation, Text
        end
        rule %r/(\s+)(\|\))/ do
          groups Text, Punctuation
        end
        rule %r/(\s+)[⦇⦈⦃⦄](\s+)/ do
          groups Text, Punctuation, Text
        end

        # Special operators with characters that could appear in regular names
        # require spaces after them to distinguish them from names
        # No name can begin with a lambda, and @ is disallowed in names
        rule %r/λ|\\|@/, Operator
        rule %r/(->|[∀→⊔=:_\|\?])(\s+)/ do
          groups Operator, Text
        end

        # TODO: Strings and numbers (incl. escape codes, floats, binary, hex)

        rule %r/[^\s\(\)\{\}\.\;\@]+/, Name
        rule %r/\s+/, Text
      end

      state :pragma do
        rule %r/#-}/, Comment::Preproc, :pop!
        rule %r/\s+/, Comment::Preproc
        rule %r/\w+/ do |m|
          if pragmas.include?(m[0])
            token Keyword::Pseudo
          elsif builtins.include?(m[0])
            token Keyword::Pseudo
          else
            # This could be a little more restrictive.
            # For instance, if we're in the OPTIONS pragma,
            # we enter an :options state in which we lex only flags.
            token Comment::Preproc
          end
        end
        rule %r/./, Comment::Preproc
      end

      state :comment do
        rule %r/-}/, Comment::Multiline, :pop!
        rule %r/{-/, Comment::Multiline, :comment
        rule %r/./, Comment::Multiline
      end

      state :hole do
        rule %r/!}/, Comment::Special, :pop!
        rule %r/{!/, Comment::Special, :hole
        rule %r/./, Comment::Special
      end
    end
  end
end
