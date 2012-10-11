module Rouge
  module Lexers
    class XML < RegexLexer
      desc %q(<desc for="this-lexer">XML</desc>)
      tag 'xml'
      filenames *%w(*.xml *.xsl *.rss *.xslt *.xsd *.wsdl)
      mimetypes *%w(
        text/xml
        application/xml
        image/svg+xml
        application/rss+xml
        application/atom+xml
      )

      def self.analyze_text(text)
        return 0.5 if text.doctype?
        return 0.5 if text[0..1000] =~ %r(<.+?>.*?</.+?>)m
        return 0.8 if text =~ /\A<\?xml\b/
      end

      state :root do
        rule /[^<&]+/, 'Text'
        rule /&\S*?;/, 'Name.Entity'
        rule /<!\[CDATA\[.*?\]\]\>/, 'Comment.Preproc'
        rule /<!--/, 'Comment', :comment
        rule /<\?.*?\?>/, 'Comment.Preproc'
        rule /<![^>]*>/, 'Comment.Preproc'

        # open tags
        rule %r(<\s*[\w:.-]+)m, 'Name.Tag', :tag

        # self-closing tags
        rule %r(<\s*/\s*[\w:.-]+\s*>)m, 'Name.Tag'
      end

      state :comment do
        rule /[^-]+/m, 'Comment'
        rule /-->/, 'Comment', :pop!
        rule /-/, 'Comment'
      end

      state :tag do
        rule /\s+/m, 'Text'
        rule /[\w.:-]+\s*=/m, 'Name.Attribute', :attr
        rule %r(/?\s*>), 'Name.Tag', :pop!
      end

      state :attr do
        rule /\s+/m, 'Text'
        rule /".*?"|'.*?'|[^\s>]+/, 'Literal.String', :pop!
      end
    end
  end
end
