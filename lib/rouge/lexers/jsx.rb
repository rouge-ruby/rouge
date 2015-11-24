# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    load_lexer 'javascript.rb'
    load_lexer 'xml.rb'

    class JSX < Javascript
      title "JSX"
      desc "JSX is a JavaScript syntax extension that looks similar to XML"

      tag 'jsx'
      aliases 'jsx', 'reactjs'
      filenames '*.jsx'
      mimetypes 'text/jsx'

      id = /[$a-zA-Z_][a-zA-Z0-9_]*/

      prepend :expr_start do
        rule /\A\s*#!.*?\n/m, Comment::Preproc, :statement
        rule /\n/, Text, :statement

        mixin :component
      end

      state :component do
        rule %r{<\s*([\w:.-]+).*?<\s*/\1\s*>\s*(?=[;\n$])}m do
          delegate ReactComponent
        end
        rule %r{<\s*([\w:.-]+).*?\s*/?>}m do
          delegate ReactComponent
        end
      end
    end

    class ReactComponent < XML
      assignment = /(\{)(\{.*?\}|.*?)(\})/

      prepend :root do
        rule /[^<&{]+/, Text
        rule assignment do |m|
          parse_assignment(m)
        end
      end

      prepend :attr do
        rule assignment do |m|
          parse_assignment(m)
          pop!
        end
      end

      def parse_assignment(m)
        token Comment::Preproc, m[1]
        delegate JSX, m[2]
        token Comment::Preproc, m[3]
      end
    end
  end
end
