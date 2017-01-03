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

      operators = %w(MUL MOV ADD  SUB AND OR CMP DIV CALL RET
                     JMP JE JNE JLE JG JL JGE JLEU JGU JCS JNEG JVS)

      registers = (0..7).map { |n| "R#{n}\\b" }

      state :root do
        def any(expressions)
          /#{expressions.join('|')}/
        end

        rule any(operators), Keyword
        rule any(registers), Name::Attribute
        rule /[a-z]+[a-zA-Z0-9]*/, Name::Label
        rule /\b0x[0-9A-F]{4}\b/, Literal::Number::Hex
        rule /[:,\[\]]/, Punctuation
        rule /--.*$/, Comment::Single
        rule /\s+/, Text::Whitespace
      end
    end
  end
end
