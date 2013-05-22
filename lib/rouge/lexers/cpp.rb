module Rouge
  module Lexers
    class Cpp < RegexLexer
      desc "The C++ programming language"

      tag 'cpp'
      aliases 'c++'
      # the many varied filenames of c++ source files...
      filenames '*.cpp', '*.hpp',
                '*.c++', '*.h++',
                '*.cc',  '*.hh',
                '*.cxx', '*.hxx'
      mimetypes 'text/x-c++hdr', 'text/x-c++src'

      def self.keywords
        @keywords ||= Set.new %w(
          asm auto break case catch const const_cast continue
          default delete do dynamic_cast else enum explicit export
          extern for friend goto if mutable namespace new operator
          private protected public register reinterpret_cast return
          restrict sizeof static static_cast struct switch template
          this throw throws try typedef typeid typename union using
          volatile virtual while
        )
      end

      def self.keywords_type
        @keywords_type ||= Set.new %w(
          bool int long float short double char unsigned signed void wchar_t
        )
      end

      def self.reserved
        @reserved ||= Set.new %w(
          __asm __int8 __based __except __int16 __stdcall __cdecl
          __fastcall __int32 __declspec __finally __int64 __try
          __leave __wchar_t __w64 __virtual_inheritance __uuidof
          __unaligned __super __single_inheritance __raise __noop
          __multiple_inheritance __m128i __m128d __m128 __m64 __interface
          __identifier __forceinline __event __assume
          inline _inline __inline
          naked _naked __naked
          thread _thread __thread
        )
      end

      # optional comments or whitespace
      ws = %r((?:\s|//.*?\n|/[*].*?[*]/)+)
      id = /[a-zA-Z_][a-zA-Z0-9]*/

      start { push :bol }

      state :bol do
        mixin :inline_whitespace
        rule /#if\s+0/ do
          token 'Comment.Preproc'
          pop!; push :if_0
        end

        rule /#/ do
          token 'Comment.Preproc'
          pop!; push :macro
        end

        rule(//) { pop! }
      end

      state :inline_whitespace do
        rule /[ \t\r]+/, 'Text'
        rule /\\\n/, 'Text'
        rule %r(/(\\\n)?[*].*?[*](\\\n)?/)m, 'Comment.Multiline'
      end

      state :whitespace do
        mixin :inline_whitespace
        rule %r(/(\\\n)?/(\n|(.|\n)*?[^\\]\n)), 'Comment.Single', :bol
        rule /\n/, 'Text', :bol
      end

      state :multiline_comment do
        rule %r([*](\\\n)?/), 'Comment.Multiline', :pop!
        rule %r([*]), 'Comment.Multiline'
        rule %r([^*]+), 'Comment.Multiline'
      end

      state :root do
        mixin :whitespace

        rule /L?"/, 'Literal.String', :string
        rule %r(L?'(\\.|\\[0-7]{1,3}|\\x[a-f0-9]{1,2}|[^\\'\n])')i, 'Literal.String.Char'
        rule %r((\d+\.\d*|\.\d+|\d+)[e][+-]?\d+[lu]*)i, 'Literal.Number.Float'
        rule /0x[0-9a-f]+[lu]*/i, 'Literal.Number.Hex'
        rule /0[0-7]+[lu]*/i, 'Literal.Number.Oct'
        rule /\d+[lu]*/i, 'Literal.Number.Integer'
        rule %r(\*/), 'Error'
        rule %r([~!%^&*+=\|?:<>/-]), 'Operator'
        rule /[()\[\],.;{}]/, 'Punctuation'

        rule /class\b/, 'Keyword', :classname

        # Offload C++ extensions, http://offload.codeplay.com/
        rule /(?:__offload|__blockingoffload|__outer)\b/, 'Keyword.Pseudo'

        rule /(true|false)\b/, 'Keyword.Constant'
        rule /NULL\b/, 'Name.Builtin'
        rule /#{id}:(?!:)/, 'Name.Label'
        rule id do |m|
          name = m[0]

          if self.class.keywords.include? name
            token 'Keyword'
          elsif self.class.keywords_type.include? name
            token 'Keyword.Type'
          elsif self.class.reserved.include? name
            token 'Keyword.Reserved'
          else
            token 'Name'
          end
        end
      end

      state :classname do
        rule id, 'Name.Class', :pop!

        # template specification
        rule /\s*(?=>)/m, 'Text', :pop!
        mixin :whitespace
      end

      state :string do
        rule /"/, 'Literal.String', :pop!
        rule /\\([\\abfnrtv"']|x[a-fA-F0-9]{2,4}|[0-7]{1,3})/, 'Literal.String.Escape'
        rule /[^\\"\n]+/, 'Literal.String'
        rule /\\\n/, 'Literal.String'
        rule /\\/, 'Literal.String' # stray backslash
      end

      state :macro do
        rule %r([^/\n]+), 'Comment.Preproc'
        rule %r(/[*].*?[*]/)m, 'Comment.Multiliine'
        rule %r(//.*$), 'Comment.Single'
        rule %r(/), 'Comment.Preproc'
        rule /(?<=\\)\n/, 'Comment.Preproc'
        rule /\n/ do
          token 'Comment.Preproc'
          pop!; push :bol
        end
      end

      state :if_0 do
        rule /^\s*#if.*?(?<!\\)\n/, 'Comment.Preproc', :if_0
        rule /^\s*#el(?:se|if).*\n/, 'Comment.Preproc', :pop!
        rule /^\s*#endif.*?(?<!\\)\n/, 'Comment.Preproc', :pop!
        rule /.*?\n/, 'Comment'
      end
    end
  end
end
