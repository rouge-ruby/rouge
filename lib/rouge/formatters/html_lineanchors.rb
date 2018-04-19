# -*- coding: utf-8 -*- #

module Rouge
  module Formatters
    class HTMLLineanchors < Formatter
      def initialize(formatter, opts={})
        @formatter = formatter
        @class_format = opts.fetch(:class, 'line-%i')
      end

      def stream(tokens, &b)
        token_lines(tokens) do |line|
          yield "<a name=#{next_line_class}></a>"
          line.each do |tok, val|
            yield @formatter.span(tok, val)
          end
          yield "\n"
        end
      end

      def next_line_class
        @lineno ||= 0
        sprintf(@class_format, @lineno += 1).inspect
      end
    end
  end
end
