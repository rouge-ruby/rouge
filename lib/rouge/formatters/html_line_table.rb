# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Formatters
    class HTMLLineTable < Formatter
      tag 'html_line_table'

      def initialize(formatter, opts={})
        @formatter    = formatter
        @start_line   = opts.fetch :start_line,   1
        @table_class  = opts.fetch :table_class,  'rouge-line-table'
        @gutter_class = opts.fetch :gutter_class, 'rouge-gutter'
        @code_class   = opts.fetch :code_class,   'rouge-code'
        @line_class   = opts.fetch :line_class,   'lineno'
        @line_id      = opts.fetch :line_id,      'line-%i'
      end

      def stream(tokens, &b)
        lineno = @start_line - 1
        buffer = [%(<table class="#@table_class"><tbody>)]
        token_lines(tokens) do |line_tokens|
          lineno += 1
          buffer << %(<tr id="#{sprintf @line_id, lineno}" class="#@line_class">)
          buffer << %(<td class="#@gutter_class gl">)
          buffer << %(<pre>#{lineno}</pre></td>)
          buffer << %(<td class="#@code_class"><pre>)
          @formatter.stream(line_tokens) { |formatted| buffer << formatted }
          buffer << "\n</pre></td></tr>"
        end
        buffer << %(</tbody></table>)
        yield buffer.join
      end
    end
  end
end
