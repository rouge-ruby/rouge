module Rouge
  module Lexers
    class Text < Lexer
      desc "A boring lexer that doesn't highlight anything"

      tag 'text'
      filenames '*.txt'
      mimetypes 'text/plain'

      def stream_tokens(stream, &b)
        yield Token['Text'], stream.string
      end
    end
  end
end
