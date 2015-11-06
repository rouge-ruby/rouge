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

      prepend :root do
        rule /\A\s*#!.*?\n/m, Comment::Preproc, :statement
        rule /\n/, Text, :statement

        mixin :component
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
