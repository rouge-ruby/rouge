# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Crystal < RegexLexer
      tag 'crystal'
      aliases 'cr'
      filenames '*.cr'
      mimetypes 'text/x-crystal'

      def self.keywords
        @keywords ||= Set.new %w(
          abstract as as? asm begin break case
          do else elsif end ensure extend for
          if in include instance_sizeof is_a?
          next nil? of out pointerof private protected require
          rescue responds_to? return select sizeof struct super
          then typeof undef union uninitialized unless until
          when while with yield
        )
      end

      def self.constants
        @constants ||= Set.new %w(
          true false nil self
        )
      end

      def self.builtins
        # https://crystal-lang.org/api/0.23.1/toplevel.html
        @builtins ||= Set.new %w(
          abort at_exit caller delay exit fork future gets lazy loop
          p print printf puts raise rand read_line sleep spawn sprintf
          system
          debugger parallel pp
          assert
        )
      end

      def self.builtin_macros
        # https://crystal-lang.org/api/0.23.1/Object.html
        @builtin_macros ||= Set.new %w(
          record
          class_getter class_getter? class_getter!
          class_setter class_setter? class_setter?
          class_property class_property? class_property!
          def_clone def_equals def_hash def_equals_and_hash
          delegate forward_missing_to
          getter getter? getter!
          setter setter? setter!
          property property? property!
        )
      end

      def self.builtin_classes
        @builtin_classes ||= Set.new %w(
          ArgumentError Array Atomic Bool Box Bytes Channnel Char Class
          Crystal Deque Dir Enum Enumerable Errno Exception Fiber File
          Float Float32 Float64 GC Hash Indexable IndexError Int Int8 Int16
          Int32 Int64 Int128 InvalidByteSequenceError IO Iterable Iterator
          KeyError Math Mutex NamedTuple Nil Number Object PartialComparable
          Pointer PrettyPrinter Proc Process Random Range Reference Reflect
          Regex SecureRandom Set Signal Slice StaticArray String Struct Symbol
          System Tuple TypeCastError UInt8 UInt16 UInt64 UInt128 Unicode Union
          Value WeakRef
        )
      end

      def self.builtin_constants
        @builtin_constants ||= Set.new %w(
          ARGF ARGV PROGRAM_NAME STDIN STDOUT STDERR
        )
      end

      id_regexp = /[a-z_]\w*[!?]?/

      state :root do
        rule /\n/, Text, :follow_literal
        rule /[ \r\t]+/m, Text
        rule /#.*?$/m, Comment::Single, :follow_literal

        # names and keywords
        rule /(module|lib)(\s+)([A-Z]\w*(?:::[A-Z]\w*)*)/ do
          groups(Keyword, Text, Name::Namespace)
        end
        rule /(def|fun|macro)(\s+)((?:[A-Z]\w*::)*)/ do
          groups(Keyword, Text, Name::Namespace)
          push :def
        end
        rule /def(?=[*%&^`~+-\/\[<>=])/, Keyword, :def
        rule /(class|struct|union|type|alias|enum)(\s+)((?:[A-Z_]\w*::)*)([A-Z]\w*)/ do
          groups(Keyword, Text, Name::Namespace, Name::Class)
        end
        rule /#{id_regexp}:/, Str::Symbol
        rule id_regexp do |m|
          id = m[0]
          if self.class.keywords.include? id
            token Keyword
            case id
            when 'end'
              # nothing
            when 'do'
              push :begin_block_arg
            else
              push :follow_literal
            end
          elsif self.class.constants.include? id
            if id == 'self'
              token Keyword::Pseudo
            else
              token Keyword::Constant
            end
          elsif self.class.builtins.include? id
            token Name::Builtin
            push :follow_literal
          elsif self.class.builtin_macros.include? id
            token Name::Builtin::Pseudo
            push :follow_literal
          else
            token Name::Variable
            push :follow_literal
          end
        end
        rule /@@[a-z]\w*/, Name::Variable::Class
        rule /@[a-z]\w*/, Name::Variable::Instance
        rule /\$[a-z]\w*/, Name::Variable::Global
        rule /\$(?:[?~]|[1-9]\??)/, Name::Variable::Global
        rule /[A-Z]\w*/ do |m|
          name = m[0]
          if name =~ /\A[A-Z_]+\z/
            if self.class.builtin_constants.include? name
              token Name::Builtin
            else
              token Name::Constant
            end
          else
            if self.class.builtin_classes.include? name
              token Name::Builtin
            else
              token Name::Class
            end
          end
        end

        # heredoc
        rule /(<<-)('?)(\w*)(\2)(\s*?\n)/m do |m|
          token Operator, m[1]
          token Name::Constant, "#{m[2]}#{m[3]}#{m[4]}"
          token Str::Heredoc, m[5]

          heredoc_name = m[3]
          has_interpolation = m[2] != '\''

          push do
            rule /^(\s*)(\w+)/m do |n|
              if n[2] == heredoc_name
                groups Str::Heredoc, Name::Constant
                pop!
              else
                token Str::Heredoc
              end
            end

            mixin :has_interpolation if has_interpolation

            rule /.*?(?:\n|\z)/, Str::Heredoc
          end
        end

        rule /"/, Str::Double, :string
        rule /'(?:\\U\{[0-9a-fA-F]+\}|\\u[0-9a-fA-F]+|\\.|.)'/, Str::Single
        rule /:(?:#{id_regexp}|(?:[-+\/%!~^]|\*\*?|\|\|?|&&?|<=>|<<?|>>?|==?|!~)|"(?:\\.|.)*?")/, Str::Symbol
          rule /`/, Str::Backtick, :backtick

        rule /[0-9][0-9_]*\.[0-9_]+(?:[eE][-+]?[0-9]+)?(?:f32|f64)?/, Num::Float
        rule /0b[01_]+(?:[iu](?:8|16|32|64|128))?/, Num::Bin
        rule /0o[0-7_]+(?:[iu](?:8|16|32|64|128))?/, Num::Oct
        rule /0x[0-9a-fA-F_]+(?:[iu](?:8|16|32|64|128))?/, Num::Hex
        rule /[0-9][0-9_]*(?:[eE][-+]?[0-9]+(?:f32|f64)?|f32|f64)/, Num::Float
        rule /[0-9][0-9_]*(?:[iu](?:8|16|32|64|128))?/, Num::Integer

        rule /@\[/, Punctuation
        rule /\=>/, Punctuation, :follow_literal

        rule /(&?)(\.)(#{id_regexp})/ do |m|
          case m[3]
          when 'is_a?', 'nil?', 'as', 'as?'
            groups Punctuation, Punctuation, Keyword
          else
            groups Punctuation, Punctuation, Name::Function
          end
          push :follow_literal
        end

        rule /\.{2,3}/, Operator, :follow_literal
        rule /(?:[-+\/%!~^]|\*\*?|\|\|?|&&?|<=>|<<?|>>?|==?)=?|!~/, Operator, :follow_literal

        rule /{/ do
          token Punctuation
          push :root
          push :begin_block_arg
        end
        rule /}/ do |m|
          token Punctuation
          pop! if stack.size > 1
        end
        rule /[,;,?:\\({\[]/, Punctuation, :follow_literal
        rule /[\])}]/, Punctuation
      end

      state :follow_literal do
        rule /\s+/, Text

        rule /\/(?=[^ ])/, Str::Regex, :regex

        rule /(%)([iqQrxw]?)(\S)/ do |m|
          type = m[2]
          has_interpolation = true
          case type
          when 'i'
            type = Str::Symbol
          when 'q'
            type = Str::Single
            has_interpolation = false
          when 'Q'
            type = Str::Double
          when 'r'
            type = Str::Regex
          when 'x'
            type = Str::Backtick
          when 'w'
            type = Str::Other
          else # only ''
            type = Str::Double
          end

          token type

          open = m[3]
          case open
          when '('
            close = ')'
          when '['
            close = ']'
          when '{'
            close = '}'
          when '<'
            close = '>'
          else
            close = open
          end

          open = Regexp.escape(open)
          close = Regexp.escape(close)

          push do
            if type == Str::Regex
              rule /#{close}[imx]*/, type, :pop!
            else
              rule /#{close}/, type, :pop!
            end
            rule /#{open}/, type, :push if open != close
            mixin :has_interpolation if has_interpolation
            rule /[^#{open}#{close}\\#]+|\\./, type
            rule /[#{open}#{close}#]/, type
          end
        end

        rule //, Text, :pop!
      end

      state :string do
        rule /"/, Str::Double, :pop!
        rule /\\./, Str::Double
        mixin :has_interpolation
        rule /[^"\\#]+/, Str::Double
        rule /["\\#]/, Str::Double
      end

      state :backtick do
        rule /`/, Str::Backtick, :pop!
        rule /\\./, Str::Backtick
        mixin :has_interpolation
        rule /[^`\\#]+/, Str::Backtick
        rule /[`\\#]/, Str::Backtick
      end

      state :regex do
        rule /\/[imx]*/, Str::Regex, :pop!
        rule /\\./, Str::Regex
        mixin :has_interpolation
        rule /[^\/\\#]+/, Str::Regex
        rule /[\/\\#]/, Str::Regex
      end

      state :has_interpolation do
        rule /\#{/, Str::Interpol, :interpolation
      end

      state :interpolation do
        rule /}/, Str::Interpol, :pop!
        mixin :root
      end

      state :def do
        rule /\s+/, Text

        rule %r(
          (?:([a-zA-Z_][\w_]*)(\.))?
            (
              #{id_regexp} |
              (?:[-+/%~^]|\*\*?|\||&|<=>|<[<=]?|>[>=]?|===?|=~|![=~]?) |
          \[\][?=]?
          )
        )x do
          groups Name::Class, Operator, Name::Function
          pop!
        end

        rule //, :pop!
      end

      state :begin_block_arg do
        rule /\|/, Punctuation, :in_block_arg
        mixin :follow_literal
      end

      state :in_block_arg do
        rule /\|/, Punctuation, :pop!
        rule /\s+/, Text
        rule /[(),]/, Punctuation
        rule /[a-z_]\w*/, Name::Variable
        rule //, Text, :pop!
      end
    end
  end
end
