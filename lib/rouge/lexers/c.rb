module Rouge
  module Lexers
    class C < RegexLexer
      tag 'c'
      filenames '*.c', '*.h', '*.idc'
      mimetypes 'text/x-chdr', 'text/x-csrc'

      desc "The C programming language"

      # optional comment or whitespace
      ws = %r((?:\s|//.*?\n|/[*].*?[*]/)+)
      id = /[a-zA-Z_][a-zA-Z0-9_]*/

      def self.keywords
        @keywords ||= Set.new %w(
          auto break case const continue default do else enum extern
          for goto if register restricted return sizeof static struct
          switch typedef union volatile virtual while
        )
      end

      def self.keywords_type
        @keywords_type ||= Set.new %w(
          int long float short double char unsigned signed void

          jmp_buf FILE DIR div_t ldiv_t mbstate_t sig_atomic_t fpos_t
          clock_t time_t va_list size_t ssize_t off_t wchar_t ptrdiff_t
          wctrans_t wint_t wctype_t

          _Bool _Complex int8_t int16_t int32_t int64_t
          uint8_t uint16_t uint32_t uint64_t int_least8_t
          int_least16_t int_least32_t int_least64_t
          uint_least8_t uint_least16_t uint_least32_t
          uint_least64_t int_fast8_t int_fast16_t int_fast32_t
          int_fast64_t uint_fast8_t uint_fast16_t uint_fast32_t
          uint_fast64_t intptr_t uintptr_t intmax_t
          uintmax_t
        )
      end

      def self.reserved
        @reserved ||= Set.new %w(
          __asm __int8 __based __except __int16 __stdcall __cdecl
          __fastcall __int32 __declspec __finally __int61 __try __leave
          inline _inline __inline naked _naked __naked restrict _restrict
          __restrict thread _thread __thread typename _typename __typename
        )
      end

      start { push :bol }

      state :bol do
        mixin :inline_whitespace

        rule /#if\s0/, Comment, :if_0
        rule /#/, Comment::Preproc, :macro

        rule /#{id}:(?!:)/, Name::Label

        rule(//) { pop! }
      end

      state :inline_whitespace do
        rule /[ \t\r]+/, Text
        rule /\\\n/, Text # line continuation
        rule %r(/(\\\n)?[*].*?[*](\\\n)?/)m, Comment::Multiline
      end

      state :whitespace do
        rule /\n+/, Text, :bol
        rule %r(//(\\.|.)*?\n), Comment::Single, :bol
        mixin :inline_whitespace
      end

      state :statements do
        mixin :whitespace

        rule /L?"/, Str, :string
        rule %r(L?'(\\.|\\[0-7]{1,3}|\\x[a-f0-9]{1,2}|[^\\'\n])')i, Str::Char
        rule %r((\d+\.\d*|\.\d+|\d+)[e][+-]?\d+[lu]*)i, Num::Float
        rule /0x[0-9a-f]+[lu]*/i, Num::Hex
        rule /0[0-7]+[lu]*/i, Num::Oct
        rule /\d+[lu]*/i, Num::Integer
        rule %r(\*/), Error
        rule %r([~!%^&*+=\|?:<>/-]), Operator
        rule /[()\[\],.]/, Punctuation
        rule /\bcase\b/, Keyword, :case
        rule /(?:true|false|NULL)\b/, Name::Builtin
        rule id do |m|
          name = m[0]

          if self.class.keywords.include? name
            token Keyword
          elsif self.class.keywords_type.include? name
            token Keyword::Type
          elsif self.class.reserved.include? name
            token Keyword::Reserved
          else
            token Name
          end
        end
      end

      state :case do
        rule /:/, Punctuation, :pop!
        mixin :statements
      end

      state :root do
        mixin :whitespace

        # functions
        rule %r(
          ([\w*\s]+?[\s*]) # return arguments
          (#{id})          # function name
          (\s*\([^;]*?\))  # signature
          (#{ws})({)         # open brace
        )mx do |m|
          # TODO: do this better.
          recurse m[1]
          token Name::Function, m[2]
          recurse m[3]
          recurse m[4]
          token Punctuation, m[5]
          push :function
        end

        # function declarations
        rule %r(
          ([\w*\s]+?[\s*]) # return arguments
          (#{id})          # function name
          (\s*\([^;]*?\))  # signature
          (#{ws})(;)       # semicolon
        )mx do |m|
          # TODO: do this better.
          recurse m[1]
          token Name::Function
          recurse m[3]
          recurse m[4]
          token Punctuation
          push :statement
        end

        rule(//) { push :statement }
      end

      state :statement do
        rule /;/, Punctuation, :pop!
        mixin :whitespace
        mixin :statements
        rule /[{}]/, Punctuation
      end

      state :function do
        mixin :whitespace
        mixin :statements
        rule /;/, Punctuation
        rule /{/, Punctuation, :function
        rule /}/, Punctuation, :pop!
      end

      state :string do
        rule /"/, Str, :pop!
        rule /\\([\\abfnrtv"']|x[a-fA-F0-9]{2,4}|[0-7]{1,3})/, Str::Escape
        rule /[^\\"\n]+/, Str
        rule /\\\n/, Str
        rule /\\/, Str # stray backslash
      end

      state :macro do
        # NB: pop! goes back to :bol
        rule /\n/, Comment::Preproc, :pop!
        rule %r([^/\n\\]+), Comment::Preproc
        rule /\\./m, Comment::Preproc
        mixin :inline_whitespace
        rule %r(/), Comment::Preproc
      end

      state :if_0 do
        rule /^\s*#if\b.*?(?<!\\)\n/, Comment, :if_0
        rule /^\s*#\s*el(?:se|if)/, Comment::Preproc, :pop!
        rule /^\s*#\s*endif\b.*?(?<!\\)\n/m, Comment, :pop!
        rule /.*?\n/, Comment
      end
    end
  end
end
