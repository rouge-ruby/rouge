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
        rule %r/[^{#$]+/, Other

        rule %r/(#)(\*.*?\*)(#)/m do
          groups Comment::Preproc, Comment, Comment::Preproc
        end

        rule %r/(##)(.*?$)/ do
          groups Comment::Preproc, Comment
        end

        rule %r/(#\{?)(#{id})(\}?)(\s?\()/m do
          groups Punctuation, Name::Function, Punctuation, Punctuation do
            goto :directiveparams
          end
        end

        rule %r/(#\{?)(#{id})(\}|\b)/m do
          groups Punctuation, Name::Function, Punctuation
        end

        rule %r/\$\{?/, Punctuation, :variable
      end

      state :variable do
        rule %r/#{id}/, Name::Variable
        rule %r/\(/, Punctuation, :funcparams
        rule %r/(\.)(#{id})/ do
          groups Punctuation, Name::Variable do
            goto :push
          end
        end
        rule %r/\}/, Punctuation, :pop!
        rule %r/./, Str::Char, :pop!
      end

      state :directiveparams do
        rule %r/(&&|\|\||==?|!=?|[-<>+*%&|^\/])|\b(eq|ne|gt|lt|ge|le|not|in)\b/, Operator
        rule %r/\[/, Operator, :rangeoperator
        rule %r/\b#{id}\b/, Name::Function
        mixin :funcparams
      end

      state :rangeoperator do
        rule %r/\.\./, Operator
        mixin :funcparams
        rule %r/\]/, Operator, :pop!
      end

      state :funcparams do
        rule %r/\$\{?/, Punctuation, :variable
        rule %r/\s+/, Text
        rule %r/,/, Punctuation
        rule %r/"(\\\\|\\"|[^"])*"/, Str::Double
        rule %r/'(\\\\|\\'|[^'])*'/, Str::Single
        rule %r/0[xX][0-9a-fA-F]+[Ll]?/, Literal::Number
        rule %r/\b[0-9]+\b/, Literal::Number
        rule %r/(true|false|null)\b/, Keyword::Constant
        rule %r/\(/, Punctuation, :push
        rule %r/\)/, Punctuation, :push
        rule %r/\[/, Punctuation, :push
        rule %r/\]/, Punctuation, :push
        rule %r/\}/, Punctuation, :pop!
      end

    end
  end
end
