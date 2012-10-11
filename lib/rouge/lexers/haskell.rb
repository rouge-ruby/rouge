module Rouge
  module Lexers
    class Haskell < RegexLexer
      desc "The Haskell programming language (haskell.org)"

      tag 'haskell'
      aliases 'hs'
      filenames '*.hs'
      mimetypes 'text/x-haskell'

      def self.analyze_text(text)
        return 1 if text.shebang?('runhaskell')
      end

      reserved = %w(
        _ case class data default deriving do else if in
        infix[lr]? instance let newtype of then type where
      )

      ascii = %w(
        NUL SOH [SE]TX EOT ENQ ACK BEL BS HT LF VT FF CR S[OI] DLE
        DC[1-4] NAK SYN ETB CAN EM SUB ESC [FGRU]S SP DEL
      )

      state :basic do
        rule /\s+/m, 'Text'
        rule /{-#/, 'Comment.Preproc', :comment_preproc
        rule /{-/, 'Comment.Multiline', :comment
        rule /^--\s+\|.*?$/, 'Comment.Doc'
        # this is complicated in order to support custom symbols
        # like -->
        rule /--(?![!#\$\%&*+.\/<=>?@\^\|_~]).*?$/, 'Comment.Single'
      end

      # nested commenting
      state :comment do
        rule /-}/, 'Comment.Multiline', :pop!
        rule /{-/, 'Comment.Multiline', :comment
        rule /[^-{}]+/, 'Comment.Multiline'
        rule /[-{}]/, 'Comment.Multiline'
      end

      state :comment_preproc do
        rule /-}/, 'Comment.Preproc', :pop!
        rule /{-/, 'Comment.Preproc', :comment
        rule /[^-{}]+/, 'Comment.Preproc'
        rule /[-{}]/, 'Comment.Preproc'
      end

      state :root do
        mixin :basic

        rule /\bimport\b/, 'Keyword.Reserved', :import
        rule /\bmodule\b/, 'Keyword.Reserved', :module
        rule /\berror\b/, 'Name.Exception'
        rule /\b(?:#{reserved.join('|')})\b/, 'Keyword.Reserved'
        # not sure why, but ^ doesn't work here
        # rule /^[_a-z][\w']*/, 'Name.Function'
        rule /[_a-z][\w']*/, 'Name'
        rule /[A-Z][\w']*/, 'Keyword.Type'

        # lambda operator
        rule %r(\\(?![:!#\$\%&*+.\\/<=>?@^\|~-]+)), 'Name.Function'
        # special operators
        rule %r((<-|::|->|=>|=)(?![:!#\$\%&*+.\\/<=>?@^\|~-]+)), 'Operator'
        # constructor/type operators
        rule %r(:[:!#\$\%&*+.\\/<=>?@^\|~-]*), 'Operator'
        # other operators
        rule %r([:!#\$\%&*+.\\/<=>?@^\|~-]+), 'Operator'

        rule /\d+e[+-]?\d+/i, 'Literal.Number.Float'
        rule /\d+\.\d+(e[+-]?\d+)?/i, 'Literal.Number.Float'
        rule /0o[0-7]+/i, 'Literal.Number.Oct'
        rule /0x[\da-f]+/i, 'Literal.Number.Hex'
        rule /\d+/, 'Literal.Number.Integer'

        rule /'/, 'Literal.String.Char', :character
        rule /"/, 'Literal.String', :string

        rule /\[\s*\]/, 'Keyword.Type'
        rule /\(\s*\)/, 'Name.Builtin'
        rule /[\[\](),;`{}]/, 'Punctuation'
      end

      state :import do
        rule /\s+/, 'Text'
        rule /"/, 'Literal.String', :string
        rule /\bqualified\b/, 'Keyword'
        # import X as Y
        rule /([A-Z][\w.]*)(\s+)(as)(\s+)([A-Z][a-zA-Z0-9_.]*)/ do
          group 'Name.Namespace' # X
          group 'Text'
          group 'Keyword' # as
          group 'Text'
          group 'Name' # Y
          pop!
        end

        # import X hiding (functions)
        rule /([A-Z][\w.]*)(\s+)(hiding)(\s+)(\()/ do
          group 'Name.Namespace' # X
          group 'Text'
          group 'Keyword' # hiding
          group 'Text'
          group 'Punctuation' # (
          pop!
          push :funclist
        end

        # import X (functions)
        rule /([A-Z][\w.]*)(\s+)(\()/ do
          group 'Name.Namespace' # X
          group 'Text'
          group 'Punctuation' # (
          pop!
          push :funclist
        end

        rule /[\w.]+/, 'Name.Namespace', :pop!
      end

      state :module do
        rule /\s+/, 'Text'
        # module Foo (functions)
        rule /([A-Z][\w.]*)(\s+)(\()/ do
          group 'Name.Namespace'
          group 'Text'
          group 'Punctuation'
          push :funclist
        end

        rule /\bwhere\b/, 'Keyword.Reserved', :pop!

        rule /[A-Z][a-zA-Z0-9_.]*/, 'Name.Namespace', :pop!
      end

      state :funclist do
        mixin :basic
        rule /[A-Z]\w*/, 'Keyword.Type'
        rule /(_[\w\']+|[a-z][\w\']*)/, 'Name.Function'
        rule /,/, 'Punctuation'
        rule /[:!#\$\%&*+.\\\/<=>?@^\|~-]+/, 'Operator'
        rule /\(/, 'Punctuation', :funclist
        rule /\)/, 'Punctuation', :pop!
      end

      state :character do
        rule /\\/ do
          token 'Literal.String.Escape'
          push :character_end
          push :escape
        end

        rule /./ do
          token 'Literal.String.Char'
          pop!
          push :character_end
        end
      end

      state :character_end do
        rule /'/, 'Literal.String.Char', :pop!
        rule /./, 'Error', :pop!
      end

      state :string do
        rule /"/, 'Literal.String', :pop!
        rule /\\/, 'Literal.String.Escape', :escape
        rule /[^\\"]+/, 'Literal.String'
      end

      state :escape do
        rule /[abfnrtv"'&\\]/, 'Literal.String.Escape', :pop!
        rule /\^[\]\[A-Z@\^_]/, 'Literal.String.Escape', :pop!
        rule /#{ascii.join('|')}/, 'Literal.String.Escape', :pop!
        rule /o[0-7]+/i, 'Literal.String.Escape', :pop!
        rule /x[\da-f]/i, 'Literal.String.Escape', :pop!
        rule /\d+/, 'Literal.String.Escape', :pop!
        rule /\s+\\/, 'Literal.String.Escape', :pop!
      end
    end
  end
end
