module Rouge
  module Lexers
    class Markdown < RegexLexer
      desc "Markdown, a light-weight markup language for authors"

      tag 'markdown'
      aliases 'md', 'mkd'
      filenames '*.markdown', '*.md', '*.mkd'
      mimetypes 'text/x-markdown'

      def html
        @html ||= HTML.new(options)
      end

      start { html.reset! }

      edot = /\\.|[^\\\n]/

      state :root do
        # YAML frontmatter
        rule(/\A(---\s*\n.*?\n?)^(---\s*$\n?)/m) { delegate YAML }

        rule /\\./, 'Literal.String.Escape'

        rule /^[\S ]+\n(?:---*)\n/, 'Generic.Heading'
        rule /^[\S ]+\n(?:===*)\n/, 'Generic.Subheading'

        rule /^#(?=[^#]).*?$/, 'Generic.Heading'
        rule /^##*.*?$/, 'Generic.Subheading'

        # TODO: syntax highlight the code block, github style
        rule /(\n[ \t]*)(```|~~~)(.*?)(\n.*?)(\2)/m do |m|
          sublexer = Lexer.find_fancy(m[3].strip, m[4])
          sublexer ||= Text.new(:token => 'Literal.String.Backtick')

          token 'Text', m[1]
          token 'Punctuation', m[2]
          token 'Name.Label', m[3]
          delegate sublexer, m[4]
          token 'Punctuation', m[5]
        end

        rule /\n\n((    |\t).*?\n|\n)+/, 'Literal.String.Backtick'

        rule /(`+)#{edot}*\1/, 'Literal.String.Backtick'

        # various uses of * are in order of precedence

        # line breaks
        rule /^(\s*[*]){3,}\s*$/, 'Punctuation'
        rule /^(\s*[-]){3,}\s*$/, 'Punctuation'

        # bulleted lists
        rule /^\s*[*+-](?=\s)/, 'Punctuation'

        # numbered lists
        rule /^\s*\d+\./, 'Punctuation'

        # blockquotes
        rule /^\s*>.*?$/, 'Generic.Traceback'

        # link references
        # [foo]: bar "baz"
        rule %r(^
          (\s*) # leading whitespace
          (\[) (#{edot}+?) (\]) # the reference
          (\s*) (:) # colon
        )x do
          group 'Text'
          group 'Punctuation'; group 'Literal.String.Symbol'; group 'Punctuation'
          group 'Text'; group 'Punctuation'

          push :title
          push :url
        end

        # links and images
        rule /(!?\[)(#{edot}+?)(\])/ do
          group 'Punctuation'
          group 'Name.Variable'
          group 'Punctuation'
          push :link
        end

        rule /[*][*]#{edot}*?[*][*]/, 'Generic.Strong'
        rule /__#{edot}*?__/, 'Generic.Strong'

        rule /[*]#{edot}*?[*]/, 'Generic.Emph'
        rule /_#{edot}*?_/, 'Generic.Emph'

        # Automatic links
        rule /<.*?@.+[.].+>/, 'Name.Variable'
        rule %r[<(https?|mailto|ftp)://#{edot}*?>], 'Name.Variable'


        rule /[^\\`\[*\n&<]+/, 'Text'

        # inline html
        rule(/&\S*;/) { delegate html }
        rule(/<#{edot}*?>/) { delegate html }
        rule /[&<]/, 'Text'

        rule /\n/, 'Text'
      end

      state :link do
        rule /(\[)(#{edot}*?)(\])/ do
          group 'Punctuation'
          group 'Literal.String.Symbol'
          group 'Punctuation'
          pop!
        end

        rule /[(]/ do
          token 'Punctuation'
          push :inline_title
          push :inline_url
        end

        rule /[ \t]+/, 'Text'

        rule(//) { pop! }
      end

      state :url do
        rule /[ \t]+/, 'Text'

        # the url
        rule /(<)(#{edot}*?)(>)/ do
          group 'Name.Tag'
          group 'Literal.String.Other'
          group 'Name.Tag'
          pop!
        end

        rule /\S+/, 'Literal.String.Other', :pop!
      end

      state :title do
        rule /"#{edot}*?"/, 'Name.Namespace'
        rule /'#{edot}*?'/, 'Name.Namespace'
        rule /[(]#{edot}*?[)]/, 'Name.Namespace'
        rule /\s*(?=["'()])/, 'Text'
        rule(//) { pop! }
      end

      state :inline_title do
        rule /[)]/, 'Punctuation', :pop!
        mixin :title
      end

      state :inline_url do
        rule /[^<\s)]+/, 'Literal.String.Other', :pop!
        rule /\s+/m, 'Text'
        mixin :url
      end
    end
  end
end
