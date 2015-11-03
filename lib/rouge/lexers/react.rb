# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    load_lexer 'javascript.rb'
    load_lexer 'xml.rb'

    class ReactJS < Javascript
      title "ReactJS"

      tag 'jsx'
      aliases 'jsx'
      filenames '*.jsx'
      mimetypes 'text/jsx'

      def self.analyze_text(text)
        return 1 if text.shebang?('node')
        return 1 if text.shebang?('jsc')
        # TODO: rhino, spidermonkey, etc
      end

      id = /[$a-zA-Z_][a-zA-Z0-9_]*/

      state :root do
        rule /\A\s*#!.*?\n/m, Comment::Preproc, :statement
        rule /\n/, Text, :statement

        mixin :component

        rule %r((?<=\n)(?=\s|/|<!--)), Text, :expr_start
        mixin :comments_and_whitespace
        rule %r(\+\+ | -- | ~ | && | \|\| | \\(?=\n) | << | >>>? | ===
               | !== )x,
          Operator, :expr_start
        rule %r([-<>+*%&|\^/!=]=?), Operator, :expr_start
        rule /[(\[,]/, Punctuation, :expr_start
        rule /;/, Punctuation, :statement
        rule /[)\].]/, Punctuation

        rule /[?]/ do
          token Punctuation
          push :ternary
          push :expr_start
        end

        rule /[{}]/, Punctuation, :statement

        rule id do |m|
          if self.class.keywords.include? m[0]
            token Keyword
            push :expr_start
          elsif self.class.declarations.include? m[0]
            token Keyword::Declaration
            push :expr_start
          elsif self.class.reserved.include? m[0]
            token Keyword::Reserved
          elsif self.class.constants.include? m[0]
            token Keyword::Constant
          elsif self.class.builtins.include? m[0]
            token Name::Builtin
          else
            token Name::Other
          end
        end

        rule /[0-9][0-9]*\.[0-9]+([eE][0-9]+)?[fd]?/, Num::Float
        rule /0x[0-9a-fA-F]+/, Num::Hex
        rule /[0-9]+/, Num::Integer
        rule /"(\\\\|\\"|[^"])*"/, Str::Double
        rule /'(\\\\|\\'|[^'])*'/, Str::Single
      end

      state :component do
        rule %r{<\s*([\w:.-]+).*?<\s*/\1\s*>}m do
          delegate ReactComponent
        end
        rule %r(<\s*/\s*[\w:.-]+\s*>)m do
          delegate ReactComponent
        end
      end


    end

    class ReactComponent < XML
    end
  end
end
