# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Velocity < TemplateLexer
      title 'Velocity'
      desc 'Generic `Velocity <http://velocity.apache.org/>`_ template lexer.'
      tag 'velocity'
      filenames '*.vm', '*.velocity', '*.fhtml'
      mimetypes 'text/html+velocity'

      id = /[a-zA-Z_]\w*/

      def self.analyze_text(text)
        rv = 0.0
        if text =~ /#\{?macro\}?\(.*?\).*?#\{?end\}?/
          rv += 0.25
        end

        if text =~ /#\{?if\}?\(.+?\).*?#\{?end\}?/
          rv += 0.15
        end

        if text =~ /#\{?foreach\}?\(.+?\).*?#\{?end\}?/
          rv += 0.15
        end

        if text =~ /\$\{?[a-zA-Z_]\w*(\([^)]*\))?(\.\w+(\([^)]*\))?)*\}?/
          rv += 0.01
        end

        rv
      end

      state :root do
        rule /[^{#$]+/, Other

        rule /(#)(\*.*?\*)(#)/m do
          groups Comment::Preproc, Comment, Comment::Preproc
        end

        rule /(##)(.*?$)/ do
          groups Comment::Preproc, Comment
        end

        rule /(#\{?)(#{id})(\}?)(\s?\()/m do
          groups Punctuation, Name::Function, Punctuation, Punctuation do
            goto :directiveparams
          end
        end

        rule /(#\{?)(#{id})(\}|\b)/m do
          groups Punctuation, Name::Function, Punctuation
        end

        rule /\$\{?/, Punctuation, :variable
      end

      state :variable do
        rule /#{id}/, Name::Variable
        rule /\(/, Punctuation, :funcparams
        rule /(\.)(#{id})/ do
          groups Punctuation, Name::Variable do
            goto :push
          end
        end
        rule /\}/, Punctuation, :pop!
        rule /./, Str::Char, :pop!
      end

      state :directiveparams do
        rule /(&&|\|\||==?|!=?|[-<>+*%&|^\/])|\b(eq|ne|gt|lt|ge|le|not|in)\b/, Operator
        rule /\[/, Operator, :rangeoperator
        rule /\b#{id}\b/, Name::Function
        mixin :funcparams
      end

      state :rangeoperator do
        rule /\.\./, Operator
        mixin :funcparams
        rule /\]/, Operator, :pop!
      end

      state :funcparams do
        rule /\$\{?/, Punctuation, :variable
        rule /\s+/, Text
        rule /,/, Punctuation
        rule /"(\\\\|\\"|[^"])*"/, Str::Double
        rule /'(\\\\|\\'|[^'])*'/, Str::Single
        rule /0[xX][0-9a-fA-F]+[Ll]?/, Literal::Number
        rule /\b[0-9]+\b/, Literal::Number
        rule /(true|false|null)\b/, Keyword::Constant
        rule /\(/, Punctuation, :push
        rule /\)/, Punctuation, :push
        rule /\[/, Punctuation, :push
        rule /\]/, Punctuation, :push
        rule /\}/, Punctuation, :pop!
      end

    end
  end
end
