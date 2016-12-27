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

      operators = %w(ADD SUB MUL DIV MOV OR NOT AND RET CMP CALL JMP JE)

      registers = (0..15)
                      .map { |n| "R#{n}\\b" }

      state :root do

        def any(expressions)
          /#{expressions.join('|')}/
        end

        rule any(operators), Keyword
        rule any(registers), Name::Attribute

        # label definition
        rule /[a-z]+[a-zA-Z0-9]*/, Name::Label

        # Hexa number expressed like 0XFF12, constraint to 16 bits
        rule /\b0x[0-9A-F]{4}\b/, Literal::Number::Hex

        # Commas, square brackets and colons
        rule /[:,\[\]]/, Punctuation

        rule /--.*$/, Comment::Single
        rule /\s+/, Text::Whitespace
      end
    end
  end
end
