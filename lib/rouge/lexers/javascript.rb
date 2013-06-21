module Rouge
  module Lexers
    class Javascript < RegexLexer
      desc "JavaScript, the browser scripting language"

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
        )x, 'Literal.String.Regex', :pop!

        # if it's not matched by the above r.e., it's not
        # a valid expression, so we use :bad_regex to eat until the
        # end of the line.
        rule %r(/), 'Literal.String.Regex', :bad_regex
        rule //, 'Text', :pop!
      end

      state :bad_regex do
        rule /[^\n]+/, 'Error', :pop!
      end

      def self.keywords
        @keywords ||= Set.new %w(
          for in while do break return continue switch case default
          if else throw try catch finally new delete typeof instanceof
          void this
        )
      end

      def self.declarations
        @declarations ||= Set.new %w(var let with function)
      end

      def self.reserved
        @reserved ||= Set.new %w(
          abstract boolean byte char class const debugger double enum
          export extends final float goto implements import int interface
          long native package private protected public short static
          super synchronized throws transient volatile
        )
      end

      def self.constants
        @constants ||= Set.new %w(true false null NaN Infinity undefined)
      end

      def self.builtins
        @builtins ||= %w(
          Array Boolean Date Error Function Math netscape
          Number Object Packages RegExp String sun decodeURI
          decodeURIComponent encodeURI encodeURIComponent
          Error eval isFinite isNaN parseFloat parseInt document this
          window
        )
      end

      id = /[$a-zA-Z_][a-zA-Z0-9_]*/

      state :root do
        rule /\A\s*#!.*?\n/m, 'Comment.Preproc'
        rule %r((?<=\n)(?=\s|/|<!--)), 'Text', :slash_starts_regex
        mixin :comments_and_whitespace
        rule %r(\+\+ | -- | ~ | && | \|\| | \\(?=\n) | << | >>>? | ===
               | !== )x,
          'Operator', :slash_starts_regex
        rule %r([-<>+*%&|\^/!=]=?), 'Operator', :slash_starts_regex
        rule /[(\[;,]/, 'Punctuation', :slash_starts_regex
        rule /[)\].]/, 'Punctuation'

        rule /[?]/ do
          token 'Punctuation'
          push :ternary
          push :slash_starts_regex
        end

        rule /[{](?=\s*(#{id}|"[^\n]*?")\s*:)/, 'Punctuation', :object

        rule /[{]/ do
          token 'Punctuation'
          push :block
          push :slash_starts_regex
        end

        rule id do |m|
          if self.class.keywords.include? m[0]
            token 'Keyword'
            push :slash_starts_regex
          elsif self.class.declarations.include? m[0]
            token 'Keyword.Declaration'
            push :slash_starts_regex
          elsif self.class.reserved.include? m[0]
            token 'Keyword.Reserved'
          elsif self.class.constants.include? m[0]
            token 'Keyword.Constant'
          elsif self.class.builtins.include? m[0]
            token 'Name.Builtin'
          else
            token 'Name.Other'
          end
        end

        rule /[0-9][0-9]*\.[0-9]+([eE][0-9]+)?[fd]?/, 'Literal.Number.Float'
        rule /0x[0-9a-fA-F]+/, 'Literal.Number.Hex'
        rule /[0-9]+/, 'Literal.Number.Integer'
        rule /"(\\\\|\\"|[^"])*"/, 'Literal.String.Double'
        rule /'(\\\\|\\'|[^'])*'/, 'Literal.String.Single'
      end

      # braced parts that aren't object literals
      state :block do
        rule /(#{id})(\s*)(:)/ do
          group 'Name.Label'; group 'Text'
          group 'Punctuation'
        end

        rule /[}]/, 'Punctuation', :pop!
        mixin :root
      end

      # object literals
      state :object do
        rule /[}]/, 'Punctuation', :pop!
        rule /(#{id})(\s*)(:)/ do
          group 'Name.Attribute'; group 'Text'
          group 'Punctuation'
        end
        mixin :root
      end

      # ternary expressions, where <id>: is not a label!
      state :ternary do
        rule /:/, 'Punctuation', :pop!
        mixin :root
      end
    end

    class JSON < RegexLexer
      desc "JavaScript Object Notation (json.org)"
      tag 'json'
      filenames '*.json'
      mimetypes 'application/json'

      # TODO: is this too much of a performance hit?  JSON is quite simple,
      # so I'd think this wouldn't be too bad, but for large documents this
      # could mean doing two full lexes.
      def self.analyze_text(text)
        return 0.8 if text =~ /\A\s*{/m && text.lexes_cleanly?(self)
      end

      state :root do
        mixin :whitespace
        # special case for empty objects
        rule /(\{)(\s*)(\})/ do
          group 'Punctuation'
          group 'Text.Whitespace'
          group 'Punctuation'
        end
        rule /true|false/, 'Keyword.Constant'
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
