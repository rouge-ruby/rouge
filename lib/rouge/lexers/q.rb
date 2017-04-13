module Rouge
  module Lexers
    class Q < RegexLexer
      desc 'q'
      tag 'q'
      aliases 'q'
      filenames '*.???'

      mimetypes 'text/x-q', 'application/x-q'

      def self.analyze_text(text)
        return 0
      end

      state :root do
      end
    end
  end
end

