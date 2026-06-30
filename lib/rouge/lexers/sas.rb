# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class SAS < RegexLexer
      title "SAS"
      desc "SAS (Statistical Analysis Software)"
      tag 'sas'
      filenames '*.sas'
      mimetypes 'application/x-sas', 'application/x-stat-sas', 'application/x-sas-syntax'

      lazy { require_relative 'sas/keywords' }

      state :basics do
        # Rules to be parsed before the keywords (which are different depending
        # on the context)

        rule %r/\s+/m, Text

        # Single-line comments (between * and ;) - these can actually go onto multiple lines
        # case 1 - where it starts a line
        rule %r/^\s*%?\*[^;]*;/m, Comment::Single
        # case 2 - where it follows the previous statement on the line (after a semicolon)
        rule %r/(;)(\s*)(%?\*[^;]*;)/m do
          groups Punctuation, Text, Comment::Single
        end

        # True multiline comments!
        rule %r(/[*].*?[*]/)m, Comment::Multiline

        # date/time constants (Language Reference pp91-2)
        rule %r/'[0-9a-z]+?'d/i, Literal::Date
        rule %r/'.+?'dt/i, Literal::Date
        rule %r/'[0-9:]+?([a|p]m)?'t/i, Literal::Date

        rule %r/'/, Str::Single, :single_string
        rule %r/"/, Str::Double, :double_string
        rule %r/&[a-z0-9_&.]+/i, Name::Variable

        # numeric constants (Language Reference p91)
        rule %r/\d[0-9a-f]*x/i, Num::Hex
        rule %r/\d[0-9e\-.]+/i, Num # scientific notation

        # auto variables from DATA step (Language Reference p46, p37)
        rule %r/\b(_n_|_error_|_file_|_infile_|_msg_|_iorc_|_cmd_)\b/i, Name::Builtin::Pseudo

        # auto variable list names
        rule %r/\b(_character_|_numeric_|_all_)\b/i, Name::Builtin

        # datalines/cards etc
        rule %r/\b(datalines|cards)(\s*)(;)/i do
          groups Keyword, Text, Punctuation
          push :datalines
        end

        rule %r/\b(datalines4|cards4)(\s*)(;)/i do
          groups Keyword, Text, Punctuation
          push :datalines4
        end

        # operators (Language Reference p96)
        rule %r(\*\*|[\*/\+-]), Operator
        rule %r/[^¬~]?=:?|[<>]=?:?/, Operator
        rule %r/\b(eq|ne|gt|lt|ge|le|in)\b/i, Operator::Word
        rule %r/[&|!¦¬∘~]/, Operator
        rule %r/\b(and|or|not)\b/i, Operator::Word
        rule %r/(<>|><)/, Operator # min/max
        rule %r/\|\|/, Operator # concatenation

        # The OF operator should also be highlighted (Language Reference p49)
        rule %r/\b(of)\b/i, Operator::Word
        rule %r/\b(like)\b/i, Operator::Word # Language Ref p181

        rule %r/\d+/, Num::Integer

        rule %r/\$/, Keyword::Type

        # Macro definitions
        rule %r/(%macro|%mend)(\s*)(\w+)/i do
          groups Keyword, Text, Name::Function
        end

        rule %r/%mend/, Keyword

        keywords %r/%\w+/ do
          transform(&:upcase)
          rule SAS_MACRO_STATEMENTS, Keyword
          rule SAS_MACRO_FUNCTIONS, Keyword
          default Name
        end
      end

      state :basics2 do
        # Rules to be parsed after the keywords (which are different depending
        # on the context)

        # Missing values (Language Reference p81)
        rule %r/\s\.[;\s]/, Keyword::Constant # missing
        rule %r/\s\.[a-z_]/, Name::Constant # user-defined missing

        rule %r/[\(\),;:\{\}\[\]\\\.]/, Punctuation

        rule %r/@/, Str::Symbol # line hold specifiers
        rule %r/\?/, Str::Symbol # used for format modifiers

        rule %r/[^\s]+/, Text # Fallback for anything we haven't matched so far
      end

      state :root do
        mixin :basics

        # PROC definitions
        rule %r!(proc)(\s+)(\w+)!ix do |m|
          @proc_name = m[3].upcase
          puts "    proc name: #{@proc_name}" if @debug
          if SAS_PROC_NAMES.include? @proc_name
            groups Keyword, Text, Keyword
          else
            groups Keyword, Text, Name
          end

          push :proc
        end

        # Data step definitions
        rule %r/(data)(\s+)([\w\.]+)/i do
          groups Keyword, Text, Name::Variable
        end
        # Libname definitions
        rule %r/(libname)(\s+)(\w+)/i do
          groups Keyword, Text, Name::Variable
        end

        keywords %r/\w+/ do
          transform(&:upcase)
          rule DATA_STEP_STATEMENTS, Keyword
          rule SAS_FUNCTIONS, Keyword
          default Name
        end

        mixin :basics2
      end

      state :single_string do
        rule %r/''/, Str::Escape
        rule %r/'/, Str::Single, :pop!
        rule %r/[^']+/, Str::Single
      end

      state :double_string do
        rule %r/&[a-z0-9_&]+\.?/i, Str::Interpol
        rule %r/""/, Str::Escape
        rule %r/"/, Str::Double, :pop!

        rule %r/[^&"]+/, Str::Double
        # Allow & to be used as character if not already matched as macro variable
        rule %r/&/, Str::Double
      end

      state :datalines do
        rule %r/[^;]/, Literal::String::Heredoc
        rule %r/;/, Punctuation, :pop!
      end

      state :datalines4 do
        rule %r/;{4}/, Punctuation, :pop!
        rule %r/[^;]/, Literal::String::Heredoc
        rule %r/;{,3}/, Literal::String::Heredoc
      end

      # PROCS
      state :proc do
        rule %r/(quit|run)/i, Keyword, :pop!

        mixin :basics

        keywords %r/\w+/ do
          rule DATA_STEP_STATEMENTS, Keyword
          rule SAS_FUNCTIONS, Keyword

          default do |m|
            if PROC_KEYWORDS[@proc_name]&.include?(m[0].upcase)
              token Keyword
            else
              token Name
            end
          end
        end

        mixin :basics2
      end
    end
  end
end
