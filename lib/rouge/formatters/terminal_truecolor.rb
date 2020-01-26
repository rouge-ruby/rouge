module Rouge
  module Formatters
    class TerminalTruecolor < Terminal256
      tag 'terminal_truecolor'

      class TruecolorEscapeSequence < Terminal256::EscapeSequence
        def style_string
          out = String.new('')
          out << escape(['48', '2', *get_rgb(style.bg)]) if style.bg
          out << escape(['38', '2', *get_rgb(style.fg)]) if style.fg
          out << escape(['1']) if style[:bold] || style[:italic]
        end

        def get_rgb(color)
          color = $1 if color =~ /#(\h+)/

          case color.size
          when 3 then color.chars.map { |c| c.to_i(16) * 2 }
          when 6 then color.scan(/../).map { |cc| cc.to_i(16) }
          else
            raise 'oh no'
          end
        end
      end

      # @override
      def make_escape_sequence(style)
        TruecolorEscapeSequence.new(style)
      end
    end
  end
end
