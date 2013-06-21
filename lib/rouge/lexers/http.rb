module Rouge
  module Lexers
    class HTTP < RegexLexer
      tag 'http'
      desc 'http requests and responses'

      def self.methods
        @methods ||= %w(GET POST PUT DELETE HEAD OPTIONS TRACE)
      end

      start { @content_type = 'text/plain' }

      state :root do
        # request
        rule %r(
          (#{HTTP.methods.join('|')})([ ]+) # method
          ([^ ]+)([ ]+)                     # path
          (HTTPS?)(/)(1[.][01])(\r?\n|$)  # http version
        )ox do
          group 'Name.Function'; group 'Text'
          group 'Name.Namespace'; group 'Text'
          group 'Keyword'; group 'Operator'
          group 'Literal.Number'; group 'Text'
          push :headers
        end

        # response
        rule %r(
          (HTTPS?)(/)(1[.][01])([ ]+) # http version
          (\d{3})([ ]+)               # status
          ([^\r\n]+)(\r?\n|$)       # status message
        )x do
          group 'Keyword'; group 'Operator'
          group 'Literal.Number'; group 'Text'
          group 'Literal.Number'; group 'Text'
          group 'Name.Exception'; group 'Text'
          push :headers
        end
      end

      state :headers do
        rule /([^\s:]+)( *)(:)( *)([^\r\n]+)(\r?\n|$)/ do |m|
          key = m[1]
          value = m[5]
          if key.strip.downcase == 'content-type'
            @content_type = value.split(';')[0].downcase
          end

          group 'Name.Attribute'; group 'Text'
          group 'Punctuation'; group 'Text'
          group 'Literal.String'; group 'Text'
        end

        rule /([^\r\n]+)(\r?\n|$)/ do
          group 'Literal.String'; group 'Text'
        end

        rule /\r?\n/, 'Text', :content
      end

      state :content do
        rule /.+/ do |m|
          delegate Lexer.guess_by_mimetype(@content_type)
        end
      end
    end
  end
end
