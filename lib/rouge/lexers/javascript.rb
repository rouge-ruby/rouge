module Rouge
  module Lexers
    class Javascript < RegexLexer
      tag 'javascript'
      aliases 'js'
      filenames '*.js'
      mimetypes 'application/javascript', 'application/x-javascript',
                'text/javascript', 'text/x-javascript'

      def self.analyze_text(text)
        return 1 if text.shebang?('node')
        return 1 if text.shebang?('jsc')
        # TODO: rhino, spidermonkey, etc
      end

      state :comments_and_whitespace do
        rule /\s+/, 'Text'
        rule /<!--/, 'Comment' # really...?
        rule %r(//.*?\n), 'Comment.Single'
        rule %r(/\*.*?\*/), 'Comment.Multiline'
      end

      state :slash_starts_regex do
        mixin :comments_and_whitespace

        rule %r(
          / # opening slash
          ( \\. # escape sequences
          | [^/\\\n] # regular characters
          | \[ (\\. | [^\]\\\n])* \] # character classes
          )+
          / # closing slash
          (?:[gim]+\b|\B) # flags
        )x, 'Literal.String.Regex'

        # if it's not matched by the above r.e., it's not
        # a valid expression, so we use :bad_regex to eat until the
        # end of the line.
        rule %r(/), 'Literal.String.Regex', :bad_regex
        rule //, 'Text', :pop!
      end

      state :bad_regex do
        rule /[^\n]+/, 'Error', :pop!
      end

      keywords = %w(
        for in while do break return continue switch case default if else
        throw try catch finally new delete typeof instanceof void this
      ).join('|')

      declarations = %w(var let with function).join('|')

      reserved = %w(
        abstract boolean byte char class const debugger double enum export
        extends final float goto implements import int interface long
        native package private protected public short static super
        synchronized throws transient volatile
      ).join('|')

      constants = %w(true false null NaN Infinity undefined).join('|')

      builtins = %w(
        Array Boolean Date Error Function Math netscape
        Number Object Packages RegExp String sun decodeURI
        decodeURIComponent encodeURI encodeURIComponent
        Error eval isFinite isNaN parseFloat parseInt document this
        window
      ).join('|')

      state :root do
        rule %r(^(?=\s|/|<!--)), 'Text', :slash_starts_regex
        mixin :comments_and_whitespace
        rule %r(\+\+ | -- | ~ | && | \|\| | \\(?=\n) | << | >>>? | ===
               | !== | \? | : )x,
          'Operator', :slash_starts_regex
        rule %r([-<>+*%&|\^/!=]=?), 'Operator', :slash_starts_regex
        rule /[{(\[;,]/, 'Punctuation', :slash_starts_regex
        rule /[})\].]/, 'Punctuation'
        rule /(?:#{keywords})\b/, 'Keyword', :slash_starts_regex
        rule /(?:#{declarations})\b/, 'Keyword.Declaration', :slash_starts_regex
        rule /(?:#{reserved})\b/, 'Keyword.Reserved'
        rule /(?:#{constants})\b/, 'Keyword.Constant'
        rule /(?:#{builtins})\b/, 'Name.Builtin'
        rule /[$a-zA-Z_][a-zA-Z0-9_]*/, 'Name.Other'

        rule /[0-9][0-9]*\.[0-9]+([eE][0-9]+)?[fd]?/, 'Literal.Number.Float'
        rule /0x[0-9a-fA-F]+/, 'Literal.Number.Hex'
        rule /[0-9]+/, 'Literal.Number.Integer'
        rule /"(\\\\|\\"|[^"])*"/, 'Literal.String.Double'
        rule /'(\\\\|\\'|[^'])*'/, 'Literal.String.Single'
      end
    end

    class JSON < RegexLexer
      tag 'json'
      filenames '*.json'
      mimetypes 'application/json'

      # TODO: is this too much of a performance hit?  JSON is quite simple,
      # so I'd think this wouldn't be too bad, but for large documents this
      # could mean doing two full lexes.
      def self.analyze_text(text)
        text.lexes_cleanly?(self) ? 0.8 : 0
      end

      state :root do
        mixin :whitespace
        # special case for empty objects
        rule /(\{)(\s*)(\})/ do
          group 'Punctuation'
          group 'Text.Whitespace'
          group 'Punctuation'
        end
        rule /{/,  'Punctuation', :object_key
        rule /\[/, 'Punctuation', :array
        rule /-?(?:0|[1-9]\d*)\.\d+(?:e[+-]\d+)?/i, 'Literal.Number.Float'
        rule /-?(?:0|[1-9]\d*)(?:e[+-]\d+)?/i, 'Literal.Number.Integer'
        mixin :has_string
      end

      state :whitespace do
        rule /\s+/m, 'Text.Whitespace'
      end

      state :has_string do
        rule /"(\\.|[^"])*"/, 'Literal.String.Double'
      end

      state :object_key do
        mixin :whitespace
        rule /:/, 'Punctuation', :object_val
        rule /}/, 'Error', :pop!
        mixin :has_string
      end

      state :object_val do
        rule /,/, 'Punctuation', :pop!
        rule(/}/) { token 'Punctuation'; pop!; pop! }
        mixin :root
      end

      state :array do
        rule /\]/, 'Punctuation', :pop!
        rule /,/, 'Punctuation'
        mixin :root
      end
    end
  end
end
