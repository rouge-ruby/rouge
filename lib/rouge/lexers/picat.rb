# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Picat < RegexLexer
      title "Picat"
      desc "The Picat programming language (picat-lang.org)"

      tag 'picat'
      filenames '*.pi'
      mimetypes 'text/x-picat'

      def self.keywords
        @keywords ||= Set.new %w(
          module import private table index
          if else elseif end foreach while do
          not fail true false
          catch try in
          repeat once var throw
        )
      end

      def self.builtins
        @builtins ||= Set.new %w(
          append write writeln print println member length
          solve solve_all new_array new_map new_set
          min max sum prod floor ceiling round
          abs sqrt sin cos tan log exp
          open close printf get_heap_map get_global_map
          get_table_map instance final action solve
        )
      end

      state :root do
        rule %r/\s+/m, Text
        rule %r/%.*$/, Comment::Single
        rule %r/\/\*/, Comment::Multiline, :multiline_comment

        # Module declaration
        rule %r/(module)(\s+)([a-z][a-zA-Z0-9_]*)/m do
          groups Keyword::Namespace, Text::Whitespace, Name::Namespace
        end

        # Import declaration
        rule %r/(import)(\s+)([a-z][a-zA-Z0-9_]*)/m do
          groups Keyword::Namespace, Text::Whitespace, Name::Namespace
          push :import_list
        end

        # Handle bare 'import' without immediate module name
        rule %r/(import)(\s*$)/ do
          groups Keyword::Namespace, Text::Whitespace
          push :import_list
        end

        # Numbers with underscore separators (must come before regular integers)
        rule %r/\d+(_\d+)+/, Num::Integer

        # Other numbers
        rule %r/0[xX][0-9a-fA-F]+/, Num::Hex
        rule %r/0[oO][0-7]+/, Num::Oct
        rule %r/0[bB][01]+/, Num::Bin
        rule %r/[0-9]+\.[0-9]+([eE][+-]?[0-9]+)?/, Num::Float
        rule %r/[0-9]+/, Num::Integer

        # Strings and Atoms
        rule %r/"(\\.|[^"])*"/, Str::Double
        rule %r/'(\\.|[^'])*'/, Str::Symbol         # Quoted atoms

        # Variables
        rule %r/[A-Z_][A-Za-z0-9_]*/, Name::Variable

        # Keywords and builtins (moved before other identifier patterns)
        rule %r/[a-z][a-zA-Z0-9_]*(?=[^a-zA-Z0-9_])/ do |m|
          if self.class.keywords.include? m[0]
            token Keyword
          elsif self.class.builtins.include? m[0]
            token Name::Builtin
          else
            token Name
          end
        end

        # Module-qualified names
        rule %r/([a-z][a-zA-Z0-9_]*)(\.)([a-z][a-zA-Z0-9_]*)/ do
          groups Name::Namespace, Punctuation, Name::Function
        end

        # Structure notation
        rule %r/\$[a-z][a-zA-Z0-9_]*/, Name::Class

        # Other identifiers
        rule %r/[a-z][a-zA-Z0-9_]*/, Name

        # Import items (commas and periods)
        rule %r/,|\./, Punctuation

        # Constraint operators
        rule %r/#=>|#<=>|#\/\\|#\\\/|#\^|#~|#=|#!=|#<|#=<|#<=|#>|#>=/, Operator

        # Term comparison operators
        rule %r/@<|@=<|@<=|@>|@>=/, Operator

        # DCG notation
        rule %r/-->/, Operator

        # List comprehension separator
        rule %r/\s+:\s+/, Punctuation

        # Range notation
        rule %r/\.\./, Operator

        # List cons operator (|)
        rule %r/\|/, Punctuation

        # Other operators and punctuation
        rule %r/=>|:=|\?=>|==|!=|=<|>=|::|\+\+|--|!|;|:|\.|=|<|>|\+|-|\*|\/|\[|\]|\{|\}|\(|\)|\$|@/, Operator

        # Table/index declarations
        rule %r/(\+|-)(?=[\s,\)])/, Operator
      end

      state :multiline_comment do
        rule %r/[^*\/]+/m, Comment::Multiline
        rule %r/\*\//, Comment::Multiline, :pop!
        rule %r/[\*\/]/, Comment::Multiline
      end

      state :import_list do
        rule %r/\s+/m, Text::Whitespace
        rule %r/[a-z][a-zA-Z0-9_]*/, Name::Namespace
        rule %r/,/, Punctuation
        rule %r/\./, Punctuation, :pop!
      end
    end
  end
end
