module Rouge
  module Lexers
    class C < RegexLexer
      tag 'c'
      filenames '*.c', '*.h', '*.idc'
      mimetypes 'text/x-chdr', 'text/x-csrc'

      # optional comment or whitespace
      ws = %r((?:\s|//.*?\n|/[*].*?[*]/)+)
      id = /[a-zA-Z_][a-zA-Z0-9_]*/

      keywords = %w(
        auto break case const continue default do else enum extern
        for goto if register restricted return sizeof static struct
        switch typedef union volatile virtual while
      )

      keywords_type = %w(int long float short double char unsigned signed void)

      __reserved = %w(
        asm int8 based except int16 stdcall cdecl fastcall int32
        declspec finally int61 try leave
      )

      state :whitespace do
        rule /^#if\s+0\b/, 'Comment.Preproc', :if_0
        rule /^#/, 'Comment.Preproc', :macro
        rule /^#{ws}#if\s+0\b/, 'Comment.Preproc', :if_0
        rule /^#{ws}#/, 'Comment.Preproc', :macro
        rule /^(\s*)(#{id}:(?!:))/ do
          group 'Text'
          group 'Name.Label'
        end

        rule /\s+/m, 'Text'
        rule /\\\n/, 'Text' # line continuation
        rule %r(//(\n|(.|\n)*?[^\\]\n)), 'Comment.Single'
        rule %r(/(\\\n)?[*](.|\n)*?[*](\\\n)?/), 'Comment.Multiline'
      end

      state :statements do
        rule /L?"/, 'Literal.String', :string
        rule %r(L?'(\\.|\\[0-7]{1,3}|\\x[a-f0-9]{1,2}|[^\\'\n])')i, 'Literal.String.Char'
        rule %r((\d+\.\d*|\.\d+|\d+)[e][+-]?\d+[lu]*)i, 'Literal.Number.Float'
        rule /0x[0-9a-f]+[lu]*/i, 'Literal.Number.Hex'
        rule /0[0-7]+[lu]*/i, 'Literal.Number.Oct'
        rule /\d+[lu]*/i, 'Literal.Number.Integer'
        rule %r(\*/), 'Error'
        rule %r([~!%^&*+=\|?:<>/-]), 'Operator'
        rule /[()\[\],.]/, 'Punctuation'
        rule /\bcase\b/, 'Keyword', :case
        rule /(?:#{keywords.join('|')})\b/, 'Keyword'
        rule /(?:#{keywords_type.join('|')})\b/, 'Keyword.Type'
        rule /(?:_{0,2}inline|naked|restrict|thread|typename)\b/, 'Keyword.Reserved'
        rule /__(?:#{__reserved.join('|')})\b/, 'Keyword.Reserved'
        rule /(?:true|false|NULL)\b/, 'Name.Builtin'
        rule id, 'Name'
      end

      state :case do
        rule /:/, 'Punctuation', :pop!
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
          token 'Name.Function', m[2]
          delegate C, m[3]
          delegate C, m[4]
          token 'Punctuation', m[5]
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
          token 'Name.Function'
          delegate C, m[3]
          delegate C, m[4]
          token 'Punctuation'
          push :statement
        end

        rule(//) { push :statement }
      end

      state :statement do
        rule /;/, 'Punctuation', :pop!
        mixin :whitespace
        mixin :statements
        rule /[{}]/, 'Punctuation'
      end

      state :function do
        mixin :whitespace
        mixin :statements
        rule /;/, 'Punctuation'
        rule /{/, 'Punctuation', :function
        rule /}/, 'Punctuation', :pop!
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
