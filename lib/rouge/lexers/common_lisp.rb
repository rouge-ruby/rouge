# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class CommonLisp < RegexLexer
      title "Common Lisp"
      desc "The Common Lisp variant of Lisp (common-lisp.net)"
      tag 'common_lisp'
      aliases 'cl', 'common-lisp', 'elisp', 'emacs-lisp', 'lisp'

      filenames '*.cl', '*.lisp', '*.asd', '*.el' # used for Elisp too
      mimetypes 'text/x-common-lisp'

      lazy { require_relative 'common_lisp/builtins' }

      nonmacro = /\\.|[a-zA-Z0-9!$%&*+-\/<=>?@\[\]^_{}~]/
      constituent = /#{nonmacro}|[#.:]/
      terminated = /(?=[ "'()\n,;`])/ # whitespace or terminating macro chars
      symbol = /(\|[^\|]+\||#{nonmacro}#{constituent}*)/

      state :root do
        rule %r/\s+/m, Text
        rule %r/;.*$/, Comment::Single
        rule %r/#\|/, Comment::Multiline, :multiline_comment

        # encoding comment
        rule %r/#\d*Y.*$/, Comment::Special
        rule %r/"(\\.|[^"\\])*"/, Str

        rule %r/[:']#{symbol}/, Str::Symbol
        rule %r/['`]/, Operator

        # numbers
        rule %r/[-+]?\d+\.?#{terminated}/, Num::Integer
        rule %r([-+]?\d+/\d+#{terminated}), Num::Integer
        rule %r(
          [-+]?
          (\d*\.\d+([defls][-+]?\d+)?
          |\d+(\.\d*)?[defls][-+]?\d+)
          #{terminated}
        )x, Num::Float

        # sharpsign strings and characters
        rule %r/#\\.#{terminated}/, Str::Char
        rule %r/#\\#{symbol}/, Str::Char

        rule %r/#\(/, Operator, :root

        # bitstring
        rule %r/#\d*\*[01]*/, Other

        # uninterned symbol
        rule %r/#:#{symbol}/, Str::Symbol

        # read-time and load-time evaluation
        rule %r/#[.,]/, Operator

        # function shorthand
        rule %r/#'/, Name::Function

        # binary rational
        rule %r/#b[+-]?[01]+(\/[01]+)?/i, Num

        # octal rational
        rule %r/#o[+-]?[0-7]+(\/[0-7]+)?/i, Num::Oct

        # hex rational
        rule %r/#x[+-]?[0-9a-f]+(\/[0-9a-f]+)?/i, Num

        # complex
        rule %r/(#c)(\()/i do
          groups Num, Punctuation
          push :root
        end

        # arrays and structures
        rule %r/(#(?:\d+a|s))(\()/i do
          groups Str::Other, Punctuation
          push :root
        end

        # path
        rule %r/#p?"(\\.|[^"])*"/i, Str::Symbol

        # reference
        rule %r/#\d+[=#]/, Operator

        # read-time comment
        rule %r/#+nil#{terminated}\s*\(/, Comment, :commented_form

        # read-time conditional
        rule %r/#[+-]/, Operator

        # special operators that should have been parsed already
        rule %r/(,@|,|\.)/, Operator

        # special constants
        rule %r/(t|nil)#{terminated}/, Name::Constant

        # functions and variables
        # note that these get filtered through in stream_tokens
        rule %r/\*#{symbol}\*/, Name::Variable::Global

        keywords symbol do
          rule BUILTIN_FUNCTIONS, Name::Builtin
          rule SPECIAL_FORMS, Keyword
          rule MACROS, Name::Builtin
          rule LAMBDA_LIST_KEYWORDS, Keyword
          rule DECLARATIONS, Keyword
          rule BUILTIN_TYPES, Keyword
          rule BUILTIN_CLASSES, Keyword
          default Name
        end

        rule %r/\(/, Punctuation, :root
        rule %r/\)/ do
          if stack.size == 1
            token Error
          else
            token Punctuation
            pop!
          end
        end
      end

      state :multiline_comment do
        rule %r/#\|/, Comment::Multiline, :multiline_comment
        rule %r/\|#/, Comment::Multiline, :pop!
        rule %r/[^\|#]+/, Comment::Multiline
        rule %r/[\|#]/, Comment::Multiline
      end

      state :commented_form do
        rule %r/\(/, Comment, :commented_form
        rule %r/\)/, Comment, :pop!
        rule %r/[^()]+/, Comment
      end
    end
  end
end
