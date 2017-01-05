module Rouge
  module Lexers
    class Gobstones < RegexLexer
      title 'Gobstones'
      desc 'Gobstones language'
      tag 'gobstones'
      filenames *%w(*.gbs)

      def self.analyze_text(_text)
        0.3
      end

      state :root do
        rule /\s|\S/, Text
      end
    end
  end
end