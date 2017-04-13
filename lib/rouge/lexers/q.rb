module Rouge
  module Lexers
    class Q < RegexLexer
      title 'Q'
      desc 'The Q programming language (kx.com)'
      tag 'q'
      aliases 'q'
      filenames '*.q'
      mimetypes 'text/x-q', 'application/x-q'

      def self.analyze_text(text)
        return 0
      end

      state :root do
        rule(/.*\n/, Text)
      end
    end
  end
end

