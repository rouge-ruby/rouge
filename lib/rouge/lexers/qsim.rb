module Rouge
  module Lexers
    class QSim < RegexLexer
      title 'QSim'
      desc 'Q-Architecture simulator'
      tag 'qsim'
      filenames '*.qsim'

      # high priority for filename matches
      def self.analyze_text(*)
        0.3
      end
    end
  end
end
