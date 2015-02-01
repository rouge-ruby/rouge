# -*- coding: utf-8 -*- #

module Rouge
  module Formatters
    class HTMLTable < Formatter
      tag 'html_table'

      def initialize(opts={})
        @start_line = opts.fetch(:start_line, 1)
        @html = HTML.new(opts)
      end

      def stream(tokens, &b)
        num_lines = 0
        last_val = ''
        formatted = ''

        tokens.each do |tok, val|
          last_val = val
          num_lines += val.scan(/\n/).size
          @html.span(tok, val) { |str| formatted << str }
        end

        # add an extra line for non-newline-terminated strings
        if last_val[-1] != "\n"
          num_lines += 1
          @html.span(Token::Tokens::Text::Whitespace, "\n") { |str| formatted << str }
        end

        # generate a string of newline-separated line numbers for the gutter>
        numbers = %<<pre class="lineno">#{(@start_line..num_lines+@start_line-1)
          .to_a.join("\n")}</pre>>

        yield "<div#@css_class>" if @wrap
        yield '<table style="border-spacing: 0"><tbody><tr>'

        # the "gl" class applies the style for Generic.Lineno
        yield '<td class="gutter gl" style="text-align: right">'
        yield numbers
        yield '</td>'

        yield '<td class="code">'
        yield '<pre>'
        yield formatted
        yield '</pre>'
        yield '</td>'

        yield "</tr></tbody></table>\n"
        yield "</div>\n" if @wrap
      end
    end
  end
end
