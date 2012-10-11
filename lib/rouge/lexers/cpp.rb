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

      keywords = %w(
        asm auto break case catch const const_cast continue
        default delete do dynamic_cast else enum explicit export
        extern for friend goto if mutable namespace new operator
        private protected public register reinterpret_cast return
        restrict sizeof static static_cast struct switch template
        this throw throws try typedef typeid typename union using
        volatile virtual while
      )

      keywords_type = %w(
        bool int long float short double char unsigned signed void wchar_t
      )

      __reserved = %w(
        asm int8 based except int16 stdcall cdecl fastcall int32 declspec
        finally int64 try leave wchar_t w64 virtual_inheritance uuidof
        unaligned super single_inheritance raise noop multiple_inheritance
        m128i m128d m128 m64 interface identifier forceinline event assume
      )

      # optional comments or whitespace
      ws = %r((?:\s|//.*?\n|/[*].*?[*]/)+)
      id = /[a-zA-Z_][a-zA-Z0-9]*/

      state :whitespace do
        rule /^#if\s+0/, 'Comment.Preproc', :if_0
        rule /^#/, 'Comment.Preproc', :macro
        rule /^#{ws}#if\s+0\b/, 'Comment.Preproc', :if_0
        rule /^#{ws}#/, 'Comment.Preproc', :macro
        rule /\s+/m, 'Text'
        rule /\\\n/, 'Text'
        rule %r(/(\\\n)?/(\n|(.|\n)*?[^\\]\n)), 'Comment.Single'
        rule %r(/(\\\n)?[*](.|\n)*?[*](\\\n)?/), 'Comment.Multiline'
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

        rule /(?:#{keywords.join('|')})\b/, 'Keyword'
        rule /class\b/, 'Keyword', :classname
        rule /(?:#{keywords_type.join('|')})\b/, 'Keyword.Type'
        rule /(?:_{0,2}inline|naked|thread)\b/, 'Keyword.Reserved'
        rule /__(?:#{__reserved.join('|')})\b/, 'Keyoword.Reserved'
        # Offload C++ extensions, http://offload.codeplay.com/
        rule /(?:__offload|__blockingoffload|__outer)\b/, 'Keyword.Pseudo'

        rule /(true|false)\b/, 'Keyword.Constant'
        rule /NULL\b/, 'Name.Builtin'
        rule /#{id}:(?!:)/, 'Name.Label'
        rule id, 'Name'
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
        rule /\n/, 'Comment.Preproc', :pop!
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
