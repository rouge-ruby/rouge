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

      # Primary reference: https://github.com/agda/agda/blob/master/src/full/Agda/Syntax/Parser/Lexer.x

      PRAGMAS = Set.new %w(
        BUILTIN CATCHALL COMPILE FOREIGN DISPLAY ETA ETA_EQUALITY IMPOSSIBLE
        INJECTIVE INJECTIVE_FOR_INFERENCE INLINE INCOHERENT NOINLINE
        NOT_PROJECTION_LIKE LINE MEASURE NO_POSITIVITY_CHECK
        NO_TERMINATION_CHECK NO_UNIVERSE_CHECK NON_COVERING NON_TERMINATING
        OPTIONS OVERLAPPABLE OVERLAPPING OVERLAPS POLARITY REWRITE STATIC
        TERMINATING WARNING_ON_USAGE WARNING_ON_IMPORT
      )

      # These exclude the reflection builtins because there are too many
      # See https://agda.readthedocs.io/en/latest/language/reflection.html
      BUILTINS = Set.new %w(
        UNIT SIGMA LIST MAYBE BOOL TRUE FALSE NATURAL NATPLUS NATMINUS NATTIMES
        NATEQUALS NATLESS NATDIVSUCAUX NATMODSUCAUX WORD64 INTEGER INTEGERPOS
        INTERGERNEGSUC FLOAT CHAR STRING EQUALITY TYPE PROP SETOMEGA LEVEL
        LEVELZERO LEVELSUC LEVELMAX SIZEUNIV SIZE SIZELT SIZESUC SIZEINF
        SIZEMAX INFINITY SHARP FLAT IO REWRITE FROMNAT FROMNEG FROMSTRING
      )

      RESERVED = Set.new %w(
        abstract codata coinductive constructor data do eta-equality field
        forall import in inductive infix infixl infixr instance interleaved let
        macro module mutual no-eta-equality open overlap pattern postulate
        primitive private quote quoteTerm record rewrite syntax tactic unquote
        unquoteDecl unquoteDef variable where with opaque unfolding
        using hiding renaming to public
      )

      ESCAPES = %r/
        a | b | f | n | r | t | v |
        NUL | SOH | STX | ETX | EOT | ENQ | ACK | BEL | BS  | HT  | LF  | VT  |
        FF  | CR  | SO  | SI  | DLE | DC1 | DC2 | DC3 | DC4 | NAK | SYN | ETB |
        CAN | EM  | SUB | ESC | FS  | GS  | RS  | US  | SP  | DEL
      /x

      state :root do
        # Comments can stick behind some punctuation
        rule %r/(^|[\s\(\)\}\.;])(--.*)$/ do
          groups Punctuation, Comment
        end
        rule %r/{-#/, Comment::Preproc, :pragma
        rule %r/{-/, Comment::Multiline, :comment
        rule %r/{!/, Comment::Special, :hole

        # Agda primitives (see https://agda.github.io/agda-stdlib/master/Agda.Primitive.html)
        # Do we also want to do built-ins (see https://agda.readthedocs.io/en/latest/language/built-ins.html)?
        rule %r/\b(Level|LevelUniv|lsuc|lzero)\b/, Name::Builtin
        rule %r/\b(S?Set|Prop)(ω|[₀₁₂₃₄₅₆₇₈₉]*)/, Keyword::Type

        # Keywords
        keywords %r/\w+/ do
          rule RESERVED, Keyword::Reserved
          default Name
        end

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

        # Numbers
        rule %r/-?0x\h+(_\h+)*\b/, Num::Hex
        rule %r/-?0b[01]+(_[01]+)*\b/, Num::Hex
        rule %r/-?\d+(\.\d+)?[eE][+-]?\d+\b/, Num::Float
        rule %r/-?\d+(_\d+)*\b/, Num::Integer

        # Characters and strings with escape codes
        rule %r/'/, Str::Char, :char
        rule %r/"/, Str, :string

        # Special operators with characters that could appear in regular names
        # require spaces after them to distinguish them from names
        # No name can begin with a lambda, and @ is disallowed in names
        rule %r/λ|\\|@/, Operator
        rule %r/(->|<-|[∀→←⊔=:_\|\?])(\s+)/ do
          groups Operator, Text
        end

        rule %r/[^\s\(\)\{\}\.\;\@]+/, Name
        rule %r/\s+/, Text
      end

      state :pragma do
        rule %r/#-}/, Comment::Preproc, :pop!
        rule %r/\s+/, Comment::Preproc
        keywords %r/\w+/ do
          # Agda pragmas must begin with a pragma name;
          # here, the lexer is more lax
          rule PRAGMAS, Keyword::Pseudo
          rule BUILTINS, Keyword::Pseudo
          # This could be a little more restrictive:
          # for instance, if we're in the OPTIONS pragma,
          # we enter an :options state in which we lex only flags
          default Comment::Preproc
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

      state :char do
        rule %r/\\(#{ESCAPES}|\^[@-_]|x\h+|o[0-7]+|\d+|\\|')'/, Str::Escape, :pop!
        rule %r/.'/, Str::Char, :pop!
      end

      state :string do
        rule %r/"/, Str, :pop!
        rule %r/\\(#{ESCAPES}|\^[@-_]|x\h+|o[0-7]+|\d+|\\|")/, Str::Escape
        rule %r/./, Str
      end
    end
  end
end
