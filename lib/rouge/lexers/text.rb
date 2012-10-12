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

      def stream_tokens(stream, &b)
        yield self.token, stream.string
      end
    end
  end
end
