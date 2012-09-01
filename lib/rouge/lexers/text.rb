module Rouge
  module Lexers
    # TODO: fix the class/instance mess here, this is pretty awful
    Text = Lexer.create do
      name 'text'

      def self.stream_tokens(stream, &b)
        yield Token['Text'], stream
      end
    end
  end
end
