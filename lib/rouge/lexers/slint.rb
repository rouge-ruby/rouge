# frozen_string_literal: true

module Rouge
  module Lexers
    class Slint < RegexLexer
      title 'Slint'
      desc 'The Slint language for declarative GUI design'
      tag 'slint'

      # Recognize ".slint" as Slint files
      filenames '*.slint'

      # ------------------------------------------------
      # 1) Define keywords (based on the Kate XML lists)
      # ------------------------------------------------
      def self.keywords
        @keywords ||= Set.new(%w[
          import from export global struct enum component inherits
          property in out in-out function private public callback animate
          states transitions if for return changed pure
          @tr @children @image-url @linear-gradient @radial-gradient
        ])
      end

      # ------------------------------------------------
      # 2) Define built-in types (based on the Kate XML lists)
      # ------------------------------------------------
      def self.builtins
        @builtins ||= Set.new(%w[
          int bool float duration angle string image brush color
          length physical-length relative-font-size
        ])
      end

      # ------------------------------------------------
      # 3) Token definitions
      # ------------------------------------------------
      state :root do
        # Match whitespace characters
        rule %r/\s+/m, Text::Whitespace

        # Single-line comment (// ...)
        rule %r{//.*?$}, Comment::Single

        # Multi-line comment (/* ... */)
        rule %r{/\*.*?\*/}m, Comment::Multiline

        # Strings starting with a double quote
        rule %r/"/, Str::Double, :string_double

        # Color literal (#abc, #abc123, etc.)
        # You can refine the regex to something like /#[0-9A-Fa-f]{3,8}/ if needed
        rule %r/#[0-9A-Fa-f]+/, Name::Constant

        # Property pattern (e.g., "foo:"), based on the Kate rule [a-zA-Z_][a-zA-Z_\-0-9]*:
        rule %r/[a-zA-Z_][a-zA-Z0-9_\-]*:/, Name::Property

        # Check if an identifier is a keyword, a built-in type, or just a regular name
        rule %r/[A-Za-z_]\w*/ do |m|
          name = m[0]
          if self.class.keywords.include?(name)
            token Keyword
          elsif self.class.builtins.include?(name)
            token Name::Builtin
          else
            token Name
          end
        end

        # Numeric patterns (e.g., 123, 3.14, 3.14px, 100%)
        # Based on [0-9]+\.?[0-9]*[a-z%]*
        rule %r/[0-9]+\.?[0-9]*[a-z%]*/, Num::Float

        # Symbols/operators (inspired by the <AnyChar> rule in Kate XML)
        # Escape special characters for Ruby regex: +, -, /, *, (, ), [, ], etc.
        rule %r/[!%&\(\)\+\,\-\/\*\<=\>?\[\]&\|\;]+/, Punctuation
      end

      # ------------------------------------------------
      # 4) State for double-quoted strings
      # ------------------------------------------------
      state :string_double do
        # Escape sequences like \" \\ \n \t
        rule %r/\\["\\nrt0]/, Str::Escape
        # End of string on an unescaped double quote
        rule %r/"/, Str::Double, :pop!
        # Everything else inside the string
        rule %r/[^"\\]+/, Str::Double
      end
    end
  end
end

