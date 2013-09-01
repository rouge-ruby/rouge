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

        rule /#if\s0/, Comment::Preproc, :if_0

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
        rule /\s+/m, Text

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
          delegate C, m[1]
          token Name::Function, m[2]
          delegate C, m[3]
          delegate C, m[4]
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
          delegate C, m[1]
          token Name::Function
          delegate C, m[3]
          delegate C, m[4]
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
        rule %r([^/\n]+), Comment::Preproc
        rule %r(/[*].*?[*]/)m, Comment::Multiline
        rule %r(//.*$), Comment::Single
        rule %r(/), Comment::Preproc
        rule /(?<=\\)\n/, Comment::Preproc
        rule /\n/, Comment::Preproc, :pop!
      end

      state :if_0 do
        rule /^\s*#if.*?(?<!\\)\n/, Comment, :if_0
        rule /^\s*#el(?:se|if).*\n/, Comment::Preproc, :pop!
        rule /^\s*#endif.*?(?<!\\)\n/, Comment, :pop!
        rule /.*?\n/, Comment
      end
    end
  end
end
