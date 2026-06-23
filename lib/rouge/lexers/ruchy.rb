# -*- coding: utf-8 -*- #
# frozen_string_literal: true

#
# Rouge Lexer for Ruchy Programming Language
# RSYN-0404: Rouge grammar for GitHub/GitLab syntax highlighting
#
# @fileoverview Ruchy language support for Rouge (GitHub/GitLab highlighter)
# @version 1.0.0
# @license MIT
#
# Quality Requirements:
# - Test Coverage: ≥80%
# - Cyclomatic Complexity: ≤20
# - Performance: <25ms for 50K lines
#

module Rouge
  module Lexers
    # Rouge lexer for the Ruchy programming language
    # 
    # Ruchy is a systems programming language with built-in actor model support
    # and pipeline operators for functional programming.
    class Ruchy < RegexLexer
      title "Ruchy"
      desc "The Ruchy programming language (ruchy-lang.org)"
      
      tag 'ruchy'
      aliases 'rhy'
      filenames '*.rhy', '*.ruchy'
      mimetypes 'text/x-ruchy', 'application/x-ruchy'

      # Define keyword categories for better organization
      KEYWORDS = %w[
        fn let mut const static struct enum trait impl type mod use
        if else match case for while loop break continue return
        pub async await unsafe extern move ref box
        actor spawn send
        self Self super crate as in where
      ].freeze

      BUILTIN_TYPES = %w[
        bool char str
        i8 i16 i32 i64 i128 isize
        u8 u16 u32 u64 u128 usize
        f32 f64
        String Vec HashMap HashSet Result Option Box Rc Arc
        Some None Ok Err
      ].freeze

      LITERALS = %w[true false].freeze

      # Main tokenization state
      state :root do
        rule %r/\s+/, Text

        # Shebang line
        rule %r/^#!.*$/, Comment::Hashbang

        # Documentation comments (/// or /** */)
        rule %r{///.*$}, Comment::Doc
        rule %r{/\*\*.*?\*/}m, Comment::Doc

        # Regular comments with SATD detection
        rule %r{//.*$} do |m|
          if m[0] =~ /\b(?:TODO|FIXME|NOTE|HACK|XXX|BUG|DEBT|WORKAROUND)\b/
            token Comment::Special
          else
            token Comment::Single
          end
        end

        rule %r{/\*} do
          token Comment::Multiline
          push :comment
        end

        # Attributes (#[...] or #![...])
        rule %r{#!?\[[^\]]*\]}, Comment::Preproc

        # Lifetimes ('static, 'a, etc.)
        rule %r{'[a-z_]\w*}, Name::Label

        # Raw strings (r"..." or r#"..."#)
        rule %r{r#*"} do |m|
          @string_delim = m[0]
          @hash_count = m[0].count('#')
          token Str::Other
          push :raw_string
        end

        # Regular strings with interpolation support
        rule %r{"} do
          token Str::Double
          push :string
        end

        # Character literals
        rule %r{'(?:[^'\\]|\\.)'}, Str::Char

        # Numeric literals
        # Binary literals
        rule %r{0b[01_]+(?:[iu](?:8|16|32|64|128|size))?}, Num::Bin

        # Octal literals  
        rule %r{0o[0-7_]+(?:[iu](?:8|16|32|64|128|size))?}, Num::Oct

        # Hexadecimal literals
        rule %r{0x[0-9a-fA-F_]+(?:[iu](?:8|16|32|64|128|size))?}, Num::Hex

        # Float literals
        rule %r{\d[\d_]*\.[\d_]*(?:[eE][+-]?[\d_]+)?(?:f32|f64)?}, Num::Float
        rule %r{\d[\d_]*(?:[eE][+-]?[\d_]+)(?:f32|f64)?}, Num::Float
        rule %r{\d[\d_]*(?:f32|f64)}, Num::Float

        # Integer literals with type suffixes
        rule %r{\d[\d_]*(?:[iu](?:8|16|32|64|128|size))?}, Num::Integer

        # Pipeline operator (Ruchy-specific)
        rule %r{>>}, Operator

        # Actor operators (Ruchy-specific)  
        rule %r{<-|<\?}, Operator

        # Other operators
        rule %r{[=!<>+\-*/%&|^~:?]+}, Operator
        rule %r{\.\.=?}, Operator
        rule %r{=>}, Operator
        rule %r{->}, Operator
        rule %r{::}, Operator

        # Macro invocations (identifier!)
        rule %r{[a-zA-Z_]\w*!} do |m|
          token Name::Builtin
        end

        # Function definitions
        rule %r{(fn)\s+([a-zA-Z_]\w*)} do |m|
          groups Keyword, Name::Function
        end

        # Actor definitions (Ruchy-specific)
        rule %r{(actor)\s+([A-Z]\w*)} do |m|
          groups Keyword, Name::Class
        end

        # Type definitions
        rule %r{(struct|enum|trait|type)\s+([A-Z]\w*)} do |m|
          groups Keyword, Name::Class
        end

        # Keywords
        rule %r{\b(?:#{KEYWORDS.join('|')})\b}, Keyword

        # Built-in types
        rule %r{\b(?:#{BUILTIN_TYPES.join('|')})\b}, Keyword::Type

        # Literals
        rule %r{\b(?:#{LITERALS.join('|')})\b}, Keyword::Constant

        # Type names (PascalCase identifiers)
        rule %r{[A-Z]\w*}, Name::Class

        # Regular identifiers
        rule %r{[a-z_]\w*}, Name

        # Delimiters
        rule %r{[{}()\[\];,.]}, Punctuation

        # Generic brackets
        rule %r{<}, Punctuation, :generic
        rule %r{>}, Error # Unmatched >
      end

      # Comment state for nested block comments
      state :comment do
        rule %r{/\*}, Comment::Multiline, :comment
        rule %r{\*/}, Comment::Multiline, :pop!
        
        # SATD keyword detection in comments
        rule %r{\b(?:TODO|FIXME|NOTE|HACK|XXX|BUG|DEBT|WORKAROUND)\b}, Comment::Special
        rule %r{[^/*]+}, Comment::Multiline
        rule %r{[/*]}, Comment::Multiline
      end

      # Raw string state
      state :raw_string do
        rule %r{"#{Regexp.escape('#' * @hash_count)}} do
          token Str::Other
          pop!
        end
        rule %r{[^"]+}, Str::Other
        rule %r{"}, Str::Other
      end

      # Regular string state with interpolation
      state :string do
        rule %r{"}, Str::Double, :pop!
        rule %r{\\[\\'"nrt0]}, Str::Escape
        rule %r{\\x[0-9a-fA-F]{2}}, Str::Escape
        rule %r{\\u\{[0-9a-fA-F]{1,6}\}}, Str::Escape
        rule %r{\\.}, Str::Escape # Invalid escape

        # String interpolation (${...})
        rule %r{\$\{} do
          token Str::Interpol
          push :interpolation
        end

        rule %r{[^"\\$]+}, Str::Double
        rule %r{\$}, Str::Double
      end

      # String interpolation state
      state :interpolation do
        rule %r{\}}, Str::Interpol, :pop!
        
        # Nested braces tracking
        rule %r{\{}, Punctuation, :interpolation
        
        # Include most root rules inside interpolation
        rule %r{[a-zA-Z_]\w*}, Name
        rule %r{\d+}, Num::Integer
        rule %r{[+\-*/]}, Operator
        rule %r{[()]}, Punctuation
        rule %r{\s+}, Text
        rule %r{[^}]+}, Text
      end

      # Generic type parameters state
      state :generic do
        rule %r{>}, Punctuation, :pop!
        rule %r{<}, Punctuation, :generic
        rule %r{[A-Z]\w*}, Name::Class
        rule %r{[a-z_]\w*}, Name
        rule %r{'[a-z_]\w*}, Name::Label # lifetimes
        rule %r{,\s*}, Punctuation
        rule %r{\s+}, Text
        rule %r{::}, Operator
        rule %r{where\b}, Keyword
        rule %r{[+]}, Operator
        rule %r{[^<>,+]+}, Name
      end

      # Preprocessing step for better tokenization
      def self.analyze_text(text)
        # Look for Ruchy-specific constructs
        return 0.3 if text.include?('actor ')
        return 0.2 if text.include?('spawn ')
        return 0.2 if text.include?(' >> ')
        return 0.1 if text.include?(' <- ')
        return 0.1 if text =~ /fn\s+\w+/
        return 0.1 if text.include?('#[')
        return 0.0
      end
    end
  end
end