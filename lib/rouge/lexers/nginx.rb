module Rouge
  module Lexers
    class Nginx < RegexLexer
      desc 'configuration files for the nginx web server (nginx.org)'
      tag 'nginx'
      mimetypes 'text/x-nginx-conf'
      filenames 'nginx.conf'

      id = /[^\s$;{}()#]+/

      state :root do
        rule /(include)(\s+)([^\s;]+)/ do
          group 'Keyword'; group 'Text'; group 'Name'
        end

        rule id, 'Keyword', :statement

        mixin :base
      end

      state :block do
        rule /}/, 'Punctuation', :pop!
        rule id, 'Keyword.Namespace', :statement
        mixin :base
      end

      state :statement do
        rule /{/ do
          token 'Punctuation'; pop!; push :block
        end

        rule /;/, 'Punctuation', :pop!

        mixin :base
      end

      state :base do
        rule /\s+/, 'Text'

        rule /#.*?\n/, 'Comment.Single'
        rule /(?:on|off)\b/, 'Name.Constant'
        rule /[$][\w-]+/, 'Name.Variable'

        # host/port
        rule /([a-z0-9.-]+)(:)([0-9]+)/i do
          group 'Name.Function'; group 'Punctuation'
          group 'Literal.Number.Integer'
        end

        # mimetype
        rule %r([a-z-]+/[a-z-]+)i, 'Name.Class'

        rule /[0-9]+[kmg]?\b/i, 'Literal.Number.Integer'
        rule /(~)(\s*)([^\s{]+)/ do
          group 'Punctuation'; group 'Text'; group 'Literal.String.Regex'
        end

        rule /[:=~]/, 'Punctuation'

        # pathname
        rule %r(/#{id}?), 'Name'

        rule /[^#\s;{}$\\]+/, 'Literal.String' # catchall

        rule /[$;]/, 'Text'
      end
    end
  end
end
