module Rouge
  module Lexers
    class Text < Lexer
      desc "A boring lexer that doesn't highlight anything"

      tag 'text'
      filenames '*.txt'
      mimetypes 'text/plain'

      default_options :token => 'Text'

      def token
        @token ||= Token[option :token]
      end

      def stream_tokens(string, &b)
        yield self.token, string
      end
    end
  end
end
