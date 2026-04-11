# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Python < RegexLexer
      title "Python"
      desc "The Python programming language (python.org)"
      tag 'python'
      aliases 'py'
      filenames '*.py', '*.pyi', '*.pyw', '*.sc', 'SConstruct', 'SConscript',
                '*.tac', '*.bzl', 'BUCK', 'BUILD', 'BUILD.bazel', 'WORKSPACE'
      mimetypes 'text/x-python', 'application/x-python'

      def self.detect?(text)
        return true if text.shebang?(/pythonw?(?:[23](?:\.\d+)?)?/)
      end

      def self.keywords
        @keywords ||= Set.new %w(
          assert break continue del elif else except exec
          finally for global if lambda pass print raise
          return try while yield as with from import
          async await nonlocal
        )
      end

      def self.builtins
        @builtins ||= Set.new %w(
          __import__ abs aiter all anext any apply ascii
          basestring bin bool buffer breakpoint bytearray bytes
          callable chr classmethod cmp coerce compile complex
          delattr dict dir divmod enumerate eval exec execfile exit
          file filter float format frozenset getattr globals
          hasattr hash help hex
          id input int intern isinstance issubclass iter len list locals long
          map max memoryview min next object oct open ord pow print property
          range raw_input reduce reload repr reversed round set setattr slice
          sorted staticmethod str sum super tuple type unichr unicode vars
          xrange zip
        )
      end

      def self.builtins_pseudo
        @builtins_pseudo ||= Set.new %w(None Ellipsis NotImplemented False True)
      end

      def self.exceptions
        @exceptions ||= Set.new %w(
          ArithmeticError AssertionError AttributeError BaseException
          BaseExceptionGroup BlockingIOError BrokenPipeError BufferError
          BytesWarning ChildProcessError ConnectionAbortedError ConnectionError
          ConnectionRefusedError ConnectionResetError DeprecationWarning
          EOFError EnvironmentError EncodingWarning Exception ExceptionGroup
          FileExistsError FileNotFoundError FloatingPointError FutureWarning
          GeneratorExit IOError ImportError ImportWarning IndentationError
          IndexError InterruptedError IsADirectoryError
          KeyError KeyboardInterrupt LookupError
          MemoryError ModuleNotFoundError
          NameError NotADirectoryError NotImplemented NotImplementedError
          OSError OverflowError OverflowWarning PendingDeprecationWarning
          PermissionError ProcessLookupError PythonFinalizationError
          RecursionError ReferenceError ResourceWarning RuntimeError RuntimeWarning
          StandardError StopAsyncIteration StopIteration SyntaxError SyntaxWarning
          SystemError SystemExit TabError TimeoutError TypeError
          UnboundLocalError UnicodeDecodeError UnicodeEncodeError UnicodeError
          UnicodeTranslateError UnicodeWarning UserWarning ValueError VMSError
          Warning WindowsError
          ZeroDivisionError
        )
      end

      identifier =        /[[:alpha:]_][[:alnum:]_]*/
      dotted_identifier = /[[:alpha:]_.][[:alnum:]_.]*/
      inline_ws = /(?:[ \t]|\\\n)*?/
      inline_content = /(?:[^\\\n]|\\[\n.])*?/

      def current_string
        @current_string ||= StringRegister.new
      end

      operator_words = %r/(in|is|and|or|not)\b/
      operators = %r{(<<|>>|//|[*][*])=?|!=|[-~+\/*%=<>&^|@]=?|!=}

      start do
        push :newline
      end

      state :inline_whitespace do
        rule %r/[ \t]+/, Text
        rule %r/\\\n/, Str::Escape
      end

      state :root do
        rule %r/\n+/m, Text, :newline
        rule %r/^(:)(\s*)([ru]{,2}""".*?""")/mi do
          groups Punctuation, Text, Str::Doc
        end

        rule %r/\.\.\.\B$/, Name::Builtin::Pseudo

        mixin :inline_whitespace

        rule %r(#(.*)?\n?), Comment::Single, :newline
        rule %r/[\[\]{}:(),;]/, Punctuation
        rule %r/[.]/, Punctuation, :post_dot
        rule %r/\\/, Str::Escape

        rule %r/@#{dotted_identifier}/i, Name::Decorator

        rule operator_words, Operator::Word
        rule operators, Operator

        rule %r/def\b/, Keyword, :funcname

        rule %r/class\b/, Keyword, :classname

        rule %r/`.*?`/, Str::Backtick
        rule %r/([rtfbu]{0,2})('''|"""|['"])/i do |m|
          groups Str::Affix, Str::Heredoc
          current_string.register type: m[1].downcase, delim: m[2]
          push :generic_string
        end

        # using negative lookbehind so we don't match property names
        keywords %r/(?<!\.)#{identifier}/ do |m|
          rule :keywords, Keyword
          rule :exceptions, Name::Exception
          rule :builtins, Name::Builtin
          rule :builtins_pseudo, Name::Builtin::Pseudo
          default Name
        end

        rule identifier, Name

        digits = /[0-9](_?[0-9])*/
        decimal = /((#{digits})?\.#{digits}|#{digits}\.)/
        exponent = /e[+-]?#{digits}/i
        rule %r/#{decimal}(#{exponent})?j?/i, Num::Float
        rule %r/#{digits}#{exponent}j?/i, Num::Float
        rule %r/#{digits}j/i, Num::Float

        rule %r/0b(_?[0-1])+/i, Num::Bin
        rule %r/0o(_?[0-7])+/i, Num::Oct
        rule %r/0x(_?[a-f0-9])+/i, Num::Hex
        rule %r/\d+L/, Num::Integer::Long
        rule %r/([1-9](_?[0-9])*|0(_?0)*)/, Num::Integer
      end

      state :import do
        mixin :inline_whitespace
        rule dotted_identifier, Name::Namespace, :pop!
        rule(//) { pop! }
      end

      state :from do
        mixin :inline_whitespace

        rule dotted_identifier do
          token Name::Namespace
          goto :from_import
        end

        rule(//) { pop! }
      end

      # import after from, meaning we don't push the :import state
      state :from_import do
        mixin :inline_whitespace
        rule %r/import\b/, Keyword::Namespace, :pop!
        rule(//) { pop! }
      end

      state :post_dot do
        mixin :inline_whitespace
        rule %r/([A-Z]\w*)(?=#{inline_ws}[(])/m, Name::Class
        rule %r/(#{identifier})(?=#{inline_ws}[(])/m, Name::Function
        rule(//) { pop! }
      end

      state :newline do
        mixin :inline_whitespace

        rule %r/from\b/, Keyword::Namespace, :from
        rule %r/import\b/, Keyword::Namespace, :import

        # [jneen] This lookahead is a best-effort hack, since soft keywords are
        # technically not possible to detect in the lexing stage. If we see an
        # operator like `and`, `or`, inline `if`, etc which would expect an
        # expression beforehand, we know that it is almost certainly not a keyword.
        inline_ops = /#{operator_words}|if\b|#{operators}/
        rule %r/(?:case|match)(?=#{inline_ws}#{inline_ops})/, Name::Other, :pop!

        rule %r/(?:case|match)(?=#{inline_content}:#{inline_ws}[#\n])/ do |m|
          token Keyword
          if m[0] == 'case'
            goto :case_pattern
          else
            pop!
          end
        end

        rule(//) { pop! }
      end

      state :funcname do
        mixin :inline_whitespace
        rule identifier, Name::Function, :pop!
      end

      state :classname do
        mixin :inline_whitespace
        rule identifier, Name::Class, :pop!
      end

      state :case_pattern do
        rule %r/\n/ do
          token Text
          goto :newline
        end

        rule %r/_\b/, Keyword
        mixin :root
      end

      state :raise do
        rule %r/from\b/, Keyword
        rule %r/raise\b/, Keyword
        rule %r/yield\b/, Keyword
        rule %r/\n/, Text, :pop!
        rule %r/;/, Punctuation, :pop!
        mixin :root
      end

      state :yield do
        mixin :raise
      end

      state :generic_string do
        rule %r/\n/, Str, :generic_string_newline
        rule %r/[^'"\\{\n]+/, Str
        rule %r/{{/, Str

        rule %r/'''|"""|['"]/ do |m|
          token Str::Heredoc
          if current_string.delim? m[0]
            current_string.remove
            pop!
          end
        end

        rule %r/(?=\\)/, Str, :generic_escape

        rule %r/{/ do |m|
          if current_string.type? "f"
            token Str::Interpol
            push :generic_interpol
          else
            token Str
          end
        end
      end

      state :generic_string_newline do
        rule %r/[ \t]+/, Str
        rule %r/(>>>|\.\.\.)\B/ do
          token Generic::Prompt
          goto :doctest
        end
        rule(//) { pop! }
      end

      state :generic_escape do
        rule %r(\\
          ( [\\abfnrtv"']
          | \n
          | newline
          | N{[a-zA-Z][a-zA-Z ]+[a-zA-Z]}
          | u[a-fA-F0-9]{4}
          | U[a-fA-F0-9]{8}
          | x[a-fA-F0-9]{2}
          | [0-7]{1,3}
          )
        )x do
          current_string.type?("r") ? token(Str) : token(Str::Escape)
          pop!
        end

        rule %r/\\./, Str, :pop!
      end

      state :doctest do
        rule %r/\n\n/, Text, :pop!

        rule %r/'''|"""/ do
          token Str::Heredoc
          pop!(2) if in_state?(:generic_string) # pop :doctest and :generic_string
        end

        mixin :root
      end

      state :generic_interpol do
        rule %r/[^{}!:]+/ do |m|
          recurse m[0]
        end
        rule %r/![asr]/, Str::Interpol
        rule %r/:/, Str::Interpol
        rule %r/{/, Str::Interpol, :generic_interpol
        rule %r/}/, Str::Interpol, :pop!
      end

      class StringRegister < Array
        def delim?(delim)
          self.last[1] == delim
        end

        def register(type: "u", delim: "'")
          self.push [type, delim]
        end

        def remove
          self.pop
        end

        def type?(type)
          self.last[0].include? type
        end
      end

      private_constant :StringRegister
    end
  end
end
