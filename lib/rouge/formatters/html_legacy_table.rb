# -*- coding: utf-8 -*- #
# frozen_string_literal: true

# [jneen] This is an example implementation only. You may use it as-is, but please do
# not submit patches that alter the behaviour or options of this formatter for the
# convenience of your application. You are highly encouraged to write your own
# formatter for your application instead.

module Rouge
  module Formatters
    class HTMLLegacyTable < Formatter
      def initialize(inner, opts={})
        warn '[DEPRECATED] using a wrapped or line-managed delegator for HTMLTable is deprecated, and will be removed soon. Please use HTML, HTMLInline, or HTMLDebug, or write your own formatter.'

        @inner = inner
        @start_line = opts.fetch(:start_line, 1)
        @line_format = opts.fetch(:line_format, '%i')
        @table_class = opts.fetch(:table_class, 'rouge-table')
        @gutter_class = opts.fetch(:gutter_class, 'rouge-gutter')
        @code_class = opts.fetch(:code_class, 'rouge-code')
      end

      def style(scope)
        yield "#{scope} .#{@table_class} { border-spacing: 0 }"
        yield "#{scope} .#{@gutter_class} { text-align: right }"
      end

      def stream(tokens, &b)
        last_val = nil
        num_lines = tokens.reduce(0) {|count, (_, val)| count + (last_val = val).count("\n") }
        formatted = @inner.format(tokens)

        unless last_val && last_val.end_with?("\n")
          num_lines += 1
          formatted << "\n" unless formatted.end_with?("\n")
        end

        # generate a string of newline-separated line numbers for the gutter
        formatted_line_numbers = (@start_line..(@start_line + num_lines - 1)).map do |i|
          sprintf(@line_format, i)
        end.join("\n") << "\n"

        buffer = [%(<table class="#@table_class"><tbody><tr>)]
        # the "gl" class applies the style for Generic.Lineno
        buffer << %(<td class="#@gutter_class gl" aria-hidden="true">)
        buffer << %(<pre class="lineno">#{formatted_line_numbers}</pre>)
        buffer << '</td>'
        buffer << %(<td class="#@code_class"><pre><code>)
        buffer << formatted
        buffer << '</code></pre></td>'
        buffer << '</tr></tbody></table>'

        yield buffer.join
      end
    end
  end
end
