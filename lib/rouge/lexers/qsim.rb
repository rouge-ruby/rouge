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

      operators = %w(ADD SUB MUL DIV MOV OR NOT AND CALL RET JMP JE CMP)

      #Reverse helps matching first R15 instead of R1
      registers = (0..15)
                      .map { |n| "R#{n}" }
                      .reverse


      state :root do

        def any(expressions)
          /#{expressions.join('|')}/
        end


        rule any(operators), Keyword
        rule any(registers), Name::Attribute

        rule /\w+:/, Name::Label

        rule /\b0x[0-9A-F]{4}\b/, Literal::Number::Hex
        rule /\b[01]+\b/, Literal::Number

        rule /,/, Punctuation

        rule /\s+/, Text::Whitespace
      end
    end
  end
end
