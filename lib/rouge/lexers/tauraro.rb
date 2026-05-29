# -*- coding: utf-8 -*- #
# frozen_string_literal: true

# Rouge lexer for the Tauraro programming language.

module Rouge
  module Lexers
    class Tauraro < RegexLexer
      title     "Tauraro"
      desc      "The Tauraro programming language (tauraro-lang.org)"
      tag       'tauraro'
      aliases   'tau', 'tr'
      filenames '*.tr', '*.tau', '*.tauraro'
      mimetypes 'text/x-tauraro', 'application/x-tauraro'

      def self.detect?(text)
        return true if text.shebang?('tauraro')
        # Hausa-specific keywords are a strong signal
        return true if text =~ /\b(aiki|aji|idan|koidan|sai|yayinda|dawo|gwada|kama|karshe)\b/
      end

      # ── Keyword sets ──────────────────────────────────────────────────────────

      CONTROL_KEYWORDS = %w[
        if elif else for while return break continue pass
        match case try except finally raise with assert
        async await spawn yield import from as in is del
        global nonlocal unsafe extern
      ].freeze

      DECLARATION_KEYWORDS = %w[
        def class struct interface enum extend lambda
      ].freeze

      MODIFIER_KEYWORDS = %w[
        pub mut static const abstract virtual override let
      ].freeze

      HAUSA_KEYWORDS = %w[
        idan koidan sai ga yayinda dawo tsaya ci_gaba wuce
        duba hali gwada kama karshe jefa
        marasa_jira jira bayar dan_aiki
        aiki aji tsari
      ].freeze

      OPERATOR_WORDS = %w[and da or ko not ba].freeze

      CONSTANTS = %w[true false none null gaskiya karya babu].freeze

      BUILTIN_FUNCTIONS = %w[
        print buga len range input abs min max sum round pow
        enumerate zip map filter sorted reversed any all
        chr ord hex bin oct isinstance type callable
        hasattr getattr setattr id hash repr format
        iter next open super vars dir eval exec assert
      ].freeze

      BUILTIN_TYPES = %w[
        str int i8 i16 i32 i64 i128 u8 u16 u32 u64 u128 f32 f64
        bool char void List Dict Tuple Set Option Result
        Box Vec String Bytes Any Never Self Map Pointer
      ].freeze

      BUILTIN_EXCEPTIONS = %w[
        Exception ValueError TypeError RuntimeError IOError OSError
        NameError KeyError IndexError AttributeError ImportError
        MemoryError RecursionError NotImplementedError StopIteration
        SystemExit KeyboardInterrupt ZeroDivisionError OverflowError
        FileNotFoundError PermissionError TimeoutError
      ].freeze

      def self.keywords;          @keywords          ||= Set.new CONTROL_KEYWORDS    end
      def self.declaration_kws;   @declaration_kws   ||= Set.new DECLARATION_KEYWORDS end
      def self.modifier_kws;      @modifier_kws      ||= Set.new MODIFIER_KEYWORDS   end
      def self.hausa_kws;         @hausa_kws         ||= Set.new HAUSA_KEYWORDS      end
      def self.operator_words;    @operator_words    ||= Set.new OPERATOR_WORDS      end
      def self.constants;         @constants         ||= Set.new CONSTANTS           end
      def self.builtin_functions; @builtin_functions ||= Set.new BUILTIN_FUNCTIONS   end
      def self.builtin_types;     @builtin_types     ||= Set.new BUILTIN_TYPES       end
      def self.builtin_exceptions;@builtin_exceptions||= Set.new BUILTIN_EXCEPTIONS  end

      # ── States ────────────────────────────────────────────────────────────────

      state :root do
        rule %r/\n+/,     Text
        rule %r/\s+/,     Text::Whitespace

        # Comments
        rule %r/#.*$/,    Comment::Single

        # Docstrings (triple-quoted)
        rule %r/"""/,     Str::Doc,    :docstring_dq
        rule %r/'''/,     Str::Doc,    :docstring_sq

        # F-strings
        rule %r/f"/,      Str::Interpol, :fstring_dq
        rule %r/f'/,      Str::Interpol, :fstring_sq

        # Raw strings
        rule %r/r"/,      Str::Other,  :raw_dq
        rule %r/r'/,      Str::Other,  :raw_sq

        # Byte strings
        rule %r/b"/,      Str::Other,  :bytes_dq
        rule %r/b'/,      Str::Other,  :bytes_sq

        # Regular strings
        rule %r/"/,       Str::Double, :string_dq
        rule %r/'/,       Str::Single, :string_sq

        # Numbers
        rule %r/0[xX][0-9a-fA-F][0-9a-fA-F_]*/,  Num::Hex
        rule %r/0[bB][01][01_]*/,                  Num::Bin
        rule %r/0[oO][0-7][0-7_]*/,               Num::Oct
        rule %r/[0-9][0-9_]*\.[0-9][0-9_]*(?:[eE][+-]?[0-9]+)?(?:f32|f64)?\b/, Num::Float
        rule %r/[0-9][0-9_]*[eE][+-]?[0-9][0-9_]*(?:f32|f64)?\b/,              Num::Float
        rule %r/[0-9][0-9_]*(?:i8|i16|i32|i64|i128|u8|u16|u32|u64|u128)?\b/,   Num::Integer

        # Decorators
        rule %r/@[A-Za-z_][\w.]*/,   Name::Decorator

        # Identifiers and keywords
        rule %r/[A-Za-z_]\w*/ do |m|
          word = m[0]
          if    self.class.hausa_kws.include?(word)         then token Keyword::Reserved
          elsif self.class.declaration_kws.include?(word)   then token Keyword::Declaration
          elsif self.class.modifier_kws.include?(word)      then token Keyword::Declaration
          elsif self.class.keywords.include?(word)          then token Keyword
          elsif self.class.operator_words.include?(word)    then token Operator::Word
          elsif self.class.constants.include?(word)         then token Keyword::Constant
          elsif word == 'self'                              then token Name::Builtin::Pseudo
          elsif self.class.builtin_types.include?(word)     then token Name::Builtin::Type
          elsif self.class.builtin_exceptions.include?(word) then token Name::Exception
          elsif self.class.builtin_functions.include?(word) then token Name::Builtin
          elsif word =~ /\A[A-Z]/                           then token Name::Class
          else                                                   token Name
          end
        end

        # Operators (order: longer patterns first)
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

        # Punctuation
        rule %r/[(){}\[\]:,;\.]/,     Punctuation
      end

      # ── String states ─────────────────────────────────────────────────────────

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
        rule %r/\{\{/,         Str::Interpol       # escaped brace
        rule %r/\{/,           Str::Interpol, :fstring_interp
        rule %r/[^"{\\{]+/,    Str::Interpol
      end

      state :fstring_sq do
        rule %r/'/,            Str::Interpol, :pop!
        rule %r/\\./,          Str::Escape
        rule %r/\{\{/,         Str::Interpol
        rule %r/\{/,           Str::Interpol, :fstring_interp
        rule %r/[^'{\\{]+/,    Str::Interpol
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
