module Rouge
  module Lexers
    class HTML < RegexLexer
      desc "HTML, the markup language of the web"
      tag 'html'
      filenames '*.htm', '*.html', '*.xhtml'
      mimetypes 'text/html', 'application/xhtml+xml'

      def self.analyze_text(text)
        return 1 if text.doctype?(/\bhtml\b/i)
        return 1 if text =~ /<\s*html\b/
      end

      state :root do
        rule /[^<&]+/m, 'Text'
        rule /&\S*?;/, 'Name.Entity'
        rule /<!DOCTYPE .*?>/i, 'Comment.Preproc'
        rule /<!\[CDATA\[.*?\]\]>/m, 'Comment.Preproc'
        rule /<!--/, 'Comment', :comment
        rule /<\?.*?\?>/m, 'Comment.Preproc' # php? really?

        rule /<\s*script\s*/m do
          token 'Name.Tag'
          push :script_content
          push :tag
        end

        rule /<\s*style\s*/m do
          token 'Name.Tag'
          push :style_content
          push :tag
        end

        rule %r(<\s*[a-zA-Z0-9:]+), 'Name.Tag', :tag # opening tags
        rule %r(<\s*/\s*[a-zA-Z0-9:]+\s*>), 'Name.Tag' # closing tags
      end

      state :comment do
        rule /[^-]+/, 'Comment'
        rule /-->/, 'Comment', :pop!
        rule /-/, 'Comment'
      end

      state :tag do
        rule /\s+/m, 'Text'
        rule /[a-zA-Z0-9_:-]+\s*=/m, 'Name.Attribute', :attr
        rule /[a-zA-Z0-9_:-]+/, 'Name.Attribute'
        rule %r(/?\s*>)m, 'Name.Tag', :pop!
      end

      state :attr do
        # TODO: are backslash escapes valid here?
        rule /"/ do
          token 'Literal.String'
          pop!; push :dq
        end

        rule /'/ do
          token 'Literal.String'
          pop!; push :sq
        end

        rule /[^\s>]+/, 'Literal.String', :pop!
      end

      state :dq do
        rule /"/, 'Literal.String', :pop!
        rule /[^"]+/, 'Literal.String'
      end

      state :sq do
        rule /'/, 'Literal.String', :pop!
        rule /[^']+/, 'Literal.String'
      end

      state :script_content do
        rule %r(<\s*/\s*script\s*>)m, 'Name.Tag', :pop!
        rule %r(.*?(?=<\s*/\s*script\s*>))m do
          delegate Javascript
        end
      end

      state :style_content do
        rule %r(<\s*/\s*style\s*>)m, 'Name.Tag', :pop!
        rule %r(.*(?=<\s*/\s*style\s*>))m do
          delegate CSS
        end
      end
    end
  end
end
