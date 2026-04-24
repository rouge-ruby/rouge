# -*- coding: utf-8 -*- #
# frozen_string_literal: true

# For Haskell::ASCII_ESCAPE
require_relative 'haskell'

module Rouge
  module Lexers
    class Idris < RegexLexer
      title "Idris"
      desc "The Idris programming language (idris-lang.org)"

      tag 'idris'
      aliases 'idr'
      filenames '*.idr'
      mimetypes 'text/x-idris'

      RESERVED = Set.new %w(
        _ data class instance namespace
        infixl infixr let where of with type
        do if then else case in
      )

      PRELUDE_FUNCTIONS = Set.new %w(
        abs acos all and any asin atan atan2 break ceiling compare concat
        concatMap const cos cosh curry cycle div drop dropWhile elem
        encodeFloat enumFrom enumFromThen enumFromThenTo enumFromTo exp
        fail filter flip floor foldl foldl1 foldr foldr1 fromInteger fst
        gcd getChar getLine head id init iterate last lcm length lines log
        lookup map max maxBound maximum maybe min minBound minimum mod
        negate not null or pi pred print product putChar putStr putStrLn
        readFile recip repeat replicate return reverse scanl scanl1 sequence
        sequence_ show sin sinh snd span splitAt sqrt succ sum tail take
        takeWhile tan tanh uncurry unlines unwords unzip unzip3 words
        writeFile zip zip3 zipWith zipWith3
      )

      CONSTANTS = Set.new %w(Just Nothing Left Right True False LT LTE EQ GT GTE)

      KEYWORD_TYPE = Set.new %w(
        Type Exists World IO IntTy FTy File Mode Dec Bool Ordering Either IsJust
        List Maybe Nat Stream StrM Not Lazy Inf
      )

      NAME_CLASS = Set.new %w(
        Eq Ord Num MinBound MaxBound Integral Applicative Alternative Cast Foldable
        Functor Monad Traversable Uninhabited Semigroup Monoid
      )

      state :basic do
        rule %r/\s+/m, Text
        rule %r/{-#/, Comment::Preproc, :comment_preproc
        rule %r/{-/, Comment::Multiline, :comment
        rule %r/^\|\|\|.*$/, Comment::Doc
        rule %r/--(?![!#\$\%&*+.\/<=>?@\^\|_~]).*?$/, Comment::Single
      end

      # nested commenting
      state :comment do
        rule %r/-}/, Comment::Multiline, :pop!
        rule %r/{-/, Comment::Multiline, :comment
        rule %r/[^-{}]+/, Comment::Multiline
        rule %r/[-{}]/, Comment::Multiline
      end

      state :comment_preproc do
        rule %r/-}/, Comment::Preproc, :pop!
        rule %r/{-/, Comment::Preproc, :comment
        rule %r/[^-{}]+/, Comment::Preproc
        rule %r/[-{}]/, Comment::Preproc
      end

      state :directive do
        rule %r/\%(default)\s+(total|partial)/, Keyword  # totality
        rule %r/\%(access)\s+(public|abstract|private|export)/, Keyword  # export
        rule %r/\%(language)\s+(.*)/, Keyword  # language
        rule %r/\%(provide)\s+.*\s+(with)\s+/, Keyword  # type
      end

      state :root do
        mixin :basic
        mixin :directive

        # function signature
        # Special since you can override names defined in Prelude
        rule %r/^[\w']+\s*:/, Name::Function

        keywords %r/[_a-z][\w']*/i do
          rule Set['import'], Keyword::Reserved, :import
          rule Set['module'], Keyword::Reserved, :module
          rule Set['public', 'export', 'partial'], Keyword::Namespace
          rule RESERVED, Keyword::Reserved
          rule CONSTANTS, Keyword::Constant
          rule KEYWORD_TYPE, Keyword::Type
          rule NAME_CLASS, Name::Class
          rule PRELUDE_FUNCTIONS, Name::Builtin

          default do |m|
            if m[0].match?(/\A'?[A-Z]/o)
              token Keyword::Type
            else
              token Name
            end
          end
        end

        # lambda operator
        rule %r(\\(?![:!#\$\%&*+.\\/<=>?@^\|~-]+)), Name::Function
        # special operators
        rule %r((<-|::|->|=>|=)(?![:!#\$\%&*+.\\/<=>?@^\|~-]+)), Operator
        # constructor/type operators
        rule %r(:[:!#\$\%&*+.\\/<=>?@^\|~-]*), Operator
        # other operators
        rule %r([:!#\$\%&*+.\\/<=>?@^\|~-]+), Operator

        rule %r/\d+(\.\d+)?(e[+-]?\d+)?/i, Num::Float
        rule %r/0o[0-7]+/i, Num::Oct
        rule %r/0x[\da-f]+/i, Num::Hex
        rule %r/\d+/, Num::Integer

        rule %r/'/, Str::Char, :character
        rule %r/"/, Str, :string

        rule %r/\[\s*\]/, Keyword::Type
        rule %r/\(\s*\)/, Name::Builtin

        # Quasiquotations
        rule %r/(\[)([_a-z][\w']*)(\|)/ do |m|
          token Operator, m[1]
          token Name, m[2]
          token Operator, m[3]
          push :quasiquotation
        end

        rule %r/[\[\](),;`{}]/, Punctuation
      end

      state :import do
        rule %r/\s+/, Text
        rule %r/"/, Str, :string
        # import X as Y
        rule %r/([A-Z][\w.]*)(\s+)(as)(\s+)([A-Z][a-zA-Z0-9_.]*)/ do
          groups(
            Name::Namespace, # X
            Text, Keyword, # as
            Text, Name # Y
          )
          pop!
        end

        # import X (functions)
        rule %r/([A-Z][\w.]*)(\s+)(\()/ do
          groups(
            Name::Namespace, # X
            Text,
            Punctuation # (
          )
          goto :funclist
        end

        rule %r/[\w.]+/, Name::Namespace, :pop!
      end

      state :module do
        rule %r/\s+/, Text
        # module X
        rule %r/([A-Z][\w.]*)/, Name::Namespace, :pop!
      end

      state :funclist do
        mixin :basic
        rule %r/[A-Z]\w*/, Keyword::Type
        rule %r/(_[\w\']+|[a-z][\w\']*)/, Name::Function
        rule %r/,/, Punctuation
        rule %r/[:!#\$\%&*+.\\\/<=>?@^\|~-]+/, Operator
        rule %r/\(/, Punctuation, :funclist
        rule %r/\)/, Punctuation, :pop!
      end

      state :character do
        rule %r/\\/ do
          token Str::Escape
          goto :character_end
          push :escape
        end

        rule %r/./ do
          token Str::Char
          goto :character_end
        end
      end

      state :character_end do
        rule %r/'/, Str::Char, :pop!
        rule %r/./, Error, :pop!
      end

      state :quasiquotation do
        rule %r/\|\]/, Operator, :pop!
        rule %r/[^\|]+/m, Text
        rule %r/\|/, Text
      end

      state :string do
        rule %r/"/, Str, :pop!
        rule %r/\\/, Str::Escape, :escape
        rule %r/[^\\"]+/, Str
      end

      state :escape do
        rule %r/[abfnrtv"'&\\]/, Str::Escape, :pop!
        rule %r/\^[\]\[A-Z@\^_]/, Str::Escape, :pop!
        rule Haskell::ASCII_ESCAPE, Str::Escape, :pop!
        rule %r/o[0-7]+/i, Str::Escape, :pop!
        rule %r/x[\da-fA-F]+/i, Str::Escape, :pop!
        rule %r/\d+/, Str::Escape, :pop!
        rule %r/\s+\\/, Str::Escape, :pop!
      end
    end
  end
end
