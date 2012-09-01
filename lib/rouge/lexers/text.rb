module Rouge
  module Lexers
    class Text < Lexer
      tag 'text'

      def stream_tokens(stream, &b)
        yield Token['Text'], stream
      end
    end
  end
end
