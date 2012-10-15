module Rouge
  module Lexers
    class Smalltalk < RegexLexer
      desc 'The Smalltalk programming language'

      tag 'smalltalk'
      aliases 'st', 'squeak'
      filenames '*.st'
      mimetypes 'text/x-smalltalk'

      ops = %r([-+*/\\~<>=|&!?,@%])

      state :root do
        rule /(<)(\w+:)(.*?)(>)/ do
          group 'Punctuation'; group 'Keyword'; group 'Text'; group 'Punctuation'
        end

        # mixin :squeak_fileout
        mixin :whitespaces
        mixin :method_definition
        rule /([|])([\w\s]*)([|])/ do
          group 'Punctuation'; group 'Name.Variable'; group 'Punctuation'
        end
        mixin :objects
        rule /\^|:=|_/, 'Operator'

        rule /[)}\]]/, 'Punctuation', :after_object
        rule /[({\[!]/, 'Punctuation'
      end

      state :method_definition do
        rule /([a-z]\w*:)(\s*)(\w+)/i do
          group 'Name.Function'; group 'Text'; group 'Name.Variable'
        end

        rule /^(\s*)(\b[a-z]\w*\b)(\s*)$/i do
          group 'Text'; group 'Name.Function'; group 'Text'
        end

        rule %r(^(\s*)(#{ops}+)(\s*)(\w+)(\s*)$) do
          group 'Text'; group 'Name.Function';
          group 'Text'; group 'Name.Variable'; group 'Text';
        end
      end

      state :block_variables do
        mixin :whitespaces
        rule /(:)(\s*)(\w+)/ do
          group 'Operator'; group 'Text'; group 'Name.Variable'
        end

        rule /[|]/, 'Punctuation', :pop!

        rule(//) { pop! }
      end

      state :literals do
        rule /'(''|.)*?'/m, 'Literal.String', :after_object
        rule /[$]./, 'Literal.String.Char', :after_object
        rule /#[(]/, 'Literal.String.Symbol', :parenth
        rule /(\d+r)?-?\d+(\.\d+)?(e-?\d+)?/,
          'Literal.Number', :after_object
        rule /#("[^"]*"|#{ops}+|[\w:]+)/,
          'Literal.String.Symbol', :after_object
      end

      state :parenth do
        rule /[)]/ do
          token 'Literal.String.Symbol'
          pop!; push :after_object
        end

        mixin :inner_parenth
      end

      state :inner_parenth do
        rule /#[(]/, 'Literal.String.Symbol', :inner_parenth
        rule /[)]/, 'Literal.String.Symbol', :pop!
        mixin :whitespaces
        mixin :literals
        rule /(#{ops}|[\w:])+/, 'Literal.String.Symbol'
      end

      state :whitespaces do
        rule /! !$/, 'Keyword' # squeak chunk delimiter
        rule /\s+/m, 'Text'
        rule /".*?"/m, 'Comment'
      end

      state :objects do
        rule /\[/, 'Punctuation', :block_variables
        rule /(self|super|true|false|nil|thisContext)\b/,
          'Name.Builtin.Pseudo', :after_object
        rule /[A-Z]\w*(?!:)\b/, 'Name.Class', :after_object
        rule /[a-z]\w*(?!:)\b/, 'Name.Variable', :after_object
        mixin :literals
      end

      state :after_object do
        mixin :whitespaces
        rule /(ifTrue|ifFalse|whileTrue|whileFalse|timesRepeat):/,
          'Name.Builtin', :pop!
        rule /new(?!:)\b/, 'Name.Builtin'
        rule /:=|_/, 'Operator', :pop!
        rule /[a-z]+\w*:/i, 'Name.Function', :pop!
        rule /[a-z]+\w*/i, 'Name.Function'
        rule /#{ops}+/, 'Name.Function', :pop!
        rule /[.]/, 'Punctuation', :pop!
        rule /;/, 'Punctuation'
        rule(//) { pop! }
      end
    end
  end
end
