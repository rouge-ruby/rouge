# -*- coding: utf-8 -*- #
# frozen_string_literal: true

# [jneen] This is an example implementation only. You may use it as-is, but please do
# not submit patches that alter the behaviour or options of this formatter for the
# convenience of your application. You are highly encouraged to write your own
# formatter for your application instead.

module Rouge
  module Formatters
    class HTMLTable < Formatter
      tag 'html_table'

      def self.new(inner, opts={})
        if !inner.is_a?(HTML) && inner.is_a?(Formatter)
          require_relative 'html_legacy_table'
          return HTMLLegacyTable.new(inner, opts)
        end

        super(inner, opts)
      end

      def initialize(inner, opts={})
        @inner = HTML.assert_html_formatter!(inner)
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
        num_lines = 0
        last_val = ''
        formatted = String.new('')

        tokens.each do |tok, val|
          last_val = val
          num_lines += val.scan(/\n/).size
          formatted << @inner.span(tok, val)
        end

        # add an extra line for non-newline-terminated strings
        if last_val[-1] != "\n"
          num_lines += 1
          yield @inner.span(Token::Tokens::Text::Whitespace, "\n")
        end

        # generate a string of newline-separated line numbers for the gutter>
        last_line = num_lines + @start_line
        formatted_line_numbers = (@start_line...last_line).map do |i|
          sprintf("#{@line_format}", i) << "\n"
        end.join('')

        numbers = %(<pre class="lineno">#{formatted_line_numbers}</pre>)

        yield %(<table class="#@table_class"><tbody><tr>)

        # the "gl" class applies the style for Generic.Lineno
        yield %(<td class="#@gutter_class gl" aria-hidden="true">)
        yield numbers
        yield '</td>'

        yield %(<td class="#@code_class"><pre>)
        yield formatted
        yield '</pre></td>'

        yield "</tr></tbody></table>"
      end
    end
  end
end
