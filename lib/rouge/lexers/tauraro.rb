# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Tauraro < RegexLexer
      title     "Tauraro"
      desc      "Tauraro — a systems-grade language with Python-style syntax and bilingual (English/Hausa) keywords (https://github.com/tauraro/tauraro-grammar)"
      tag       'tauraro'
      aliases   'tau'
      filenames '*.tr', '*.tau', '*.tauraro'
      mimetypes 'text/x-tauraro', 'application/x-tauraro'

      def self.detect?(text)
        return true if text.shebang?('tauraro')
      end

      # ── Keyword sets (single allocation) ──────────────────────────────────────

      KEYWORDS = Set.new %w[
        if elif else for while return break continue pass
        match case try except finally raise with assert
        async await spawn yield import from as in is del
        global nonlocal unsafe extern
      ]

      DECLARATION_KWS = Set.new %w[
        def class struct interface enum extend lambda
      ]

      MODIFIER_KWS = Set.new %w[
        pub mut static const abstract virtual override let
      ]

      HAUSA_KWS = Set.new %w[
        idan koidan sai ga yayinda dawo tsaya ci_gaba wuce
        duba hali gwada kama karshe jefa
        ba_jira jira bayar dan_aiki shigo daga kamar a_cikin
        tare tabbatar fito
        aiki aji tsari
      ]

      OPERATOR_WORDS = Set.new %w[and da or ko not ba]

      CONSTANTS = Set.new %w[true false none null gaskiya karya babu]

      BUILTIN_FUNCTIONS = Set.new %w[
        print buga len range input abs min max sum round pow
        enumerate zip map filter sorted reversed any all
        chr ord hex bin oct isinstance type callable
        hasattr getattr setattr id hash repr format
        iter next open super vars dir eval exec
      ]

      BUILTIN_TYPES = Set.new %w[
        str int i8 i16 i32 i64 i128 u8 u16 u32 u64 u128 f32 f64
        bool char void List Dict Tuple Set Option Result
        Box Vec String Bytes Any Never Self Map Pointer
      ]

      BUILTIN_EXCEPTIONS = Set.new %w[
        Exception ValueError TypeError RuntimeError IOError OSError
        NameError KeyError IndexError AttributeError ImportError
        MemoryError RecursionError NotImplementedError StopIteration
        SystemExit KeyboardInterrupt ZeroDivisionError OverflowError
        FileNotFoundError PermissionError TimeoutError
      ]

      # ── States ────────────────────────────────────────────────────────────────

      state :root do
        rule %r/\n+/,     Text
        rule %r/\s+/,     Text::Whitespace

        rule %r/#.*$/,    Comment::Single

        rule %r/"""/,     Str::Doc,    :docstring_dq
        rule %r/'''/,     Str::Doc,    :docstring_sq

        rule %r/f"/,      Str::Interpol, :fstring_dq
        rule %r/f'/,      Str::Interpol, :fstring_sq

        rule %r/r"/,      Str::Other,  :raw_dq
        rule %r/r'/,      Str::Other,  :raw_sq

        rule %r/b"/,      Str::Other,  :bytes_dq
        rule %r/b'/,      Str::Other,  :bytes_sq

        rule %r/"/,       Str::Double, :string_dq
        rule %r/'/,       Str::Single, :string_sq

        rule %r/0[xX][0-9a-fA-F][0-9a-fA-F_]*/,  Num::Hex
        rule %r/0[bB][01][01_]*/,                  Num::Bin
        rule %r/0[oO][0-7][0-7_]*/,               Num::Oct
        rule %r/[0-9][0-9_]*\.[0-9][0-9_]*(?:[eE][+-]?[0-9]+)?(?:f32|f64)?\b/, Num::Float
        rule %r/[0-9][0-9_]*[eE][+-]?[0-9][0-9_]*(?:f32|f64)?\b/,              Num::Float
        rule %r/[0-9][0-9_]*(?:i8|i16|i32|i64|i128|u8|u16|u32|u64|u128)?\b/,   Num::Integer

        rule %r/@[A-Za-z_][\w.]*/,   Name::Decorator

        rule %r/[A-Za-z_]\w*/ do |m|
          word = m[0]
          if    HAUSA_KWS.include?(word)         then token Keyword::Reserved
          elsif DECLARATION_KWS.include?(word)   then token Keyword::Declaration
          elsif MODIFIER_KWS.include?(word)      then token Keyword::Declaration
          elsif KEYWORDS.include?(word)          then token Keyword
          elsif OPERATOR_WORDS.include?(word)    then token Operator::Word
          elsif CONSTANTS.include?(word)         then token Keyword::Constant
          elsif word == 'self'                   then token Name::Builtin::Pseudo
          elsif BUILTIN_TYPES.include?(word)     then token Name::Builtin::Type
          elsif BUILTIN_EXCEPTIONS.include?(word) then token Name::Exception
          elsif BUILTIN_FUNCTIONS.include?(word) then token Name::Builtin
          elsif word =~ /\A[A-Z]/               then token Name::Class
          else                                        token Name
          end
        end

        rule %r/->/,                  Operator
        rule %r/=>/,                  Operator
        rule %r/\?\?|!!/,             Operator
        rule %r/\.\.\./,              Operator
        rule %r/\.\./,                Operator
        rule %r/==|!=|<=|>=|<(?!<)|>(?!>)/, Operator
        rule %r/\+=|-=|\*\*=|\*=|\/\/=|\/=|%=|&=|\|=|\^=|<<=|>>=/, Operator
        rule %r/:=|<-|~>|=/,          Operator
        rule %r/\*\*|\/\/|[+\-*\/%@]/, Operator
        rule %r/<<|>>|[&|^~]/,        Operator

        rule %r/[(){}\[\]:,;\.]/,     Punctuation
      end

      state :docstring_dq do
        rule %r/"""/,      Str::Doc, :pop!
        rule %r/[^"]+/,    Str::Doc
        rule %r/"/,        Str::Doc
      end

      state :docstring_sq do
        rule %r/'''/,      Str::Doc, :pop!
        rule %r/[^']+/,    Str::Doc
        rule %r/'/,        Str::Doc
      end

      state :fstring_dq do
        rule %r/"/,            Str::Interpol, :pop!
        rule %r/\\./,          Str::Escape
        rule %r/\{\{/,         Str::Interpol
        rule %r/\{/,           Str::Interpol, :fstring_interp
        rule %r/[^"{\\]+/,     Str::Interpol
      end

      state :fstring_sq do
        rule %r/'/,            Str::Interpol, :pop!
        rule %r/\\./,          Str::Escape
        rule %r/\{\{/,         Str::Interpol
        rule %r/\{/,           Str::Interpol, :fstring_interp
        rule %r/[^'{\\]+/,     Str::Interpol
      end

      state :fstring_interp do
        rule %r/\}/, Str::Interpol, :pop!
        mixin :root
      end

      state :raw_dq do
        rule %r/"/, Str::Other, :pop!
        rule %r/[^"]+/, Str::Other
      end

      state :raw_sq do
        rule %r/'/, Str::Other, :pop!
        rule %r/[^']+/, Str::Other
      end

      state :bytes_dq do
        rule %r/"/, Str::Other, :pop!
        rule %r/\\./, Str::Escape
        rule %r/[^"\\]+/, Str::Other
      end

      state :bytes_sq do
        rule %r/'/, Str::Other, :pop!
        rule %r/\\./, Str::Escape
        rule %r/[^'\\]+/, Str::Other
      end

      state :string_dq do
        rule %r/"/, Str::Double, :pop!
        rule %r/\\./, Str::Escape
        rule %r/[^"\\]+/, Str::Double
      end

      state :string_sq do
        rule %r/'/, Str::Single, :pop!
        rule %r/\\./, Str::Escape
        rule %r/[^'\\]+/, Str::Single
      end
    end
  end
end
