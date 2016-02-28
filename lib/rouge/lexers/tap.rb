module Rouge
  module Lexers
    class Tap < RegexLexer
      desc 'tap'
      tag 'tap'
      aliases 'tap'
      filenames '*.???'

      mimetypes 'text/x-tap', 'application/x-tap'

      def self.analyze_text(text)
        return 0
      end

      state :root do
      end
    end
  end
end

