# -*- coding: utf-8 -*- #
# frozen_string_literal: true

# [jneen] This is an example implementation only. You may use it as-is, but please do
# not submit patches that alter the behaviour or options of this formatter for the
# convenience of your application. You are highly encouraged to write your own
# formatter for your application instead.

module Rouge
  module Formatters
    class HTMLLineHighlighter < Formatter
      tag 'html_line_highlighter'

      def initialize(delegate, opts = {})
        @delegate = HTML.assert_html_formatter!(delegate)
        @highlight_line_class = opts.fetch(:highlight_line_class, 'hll')
        @highlight_lines = opts[:highlight_lines] || []
      end

      def stream(tokens)
        token_lines(tokens).with_index(1) do |line_tokens, lineno|
          should_highlight = @highlight_lines.include?(lineno)
          yield %(<span class=#{@highlight_line_class.inspect}>) if should_highlight
          line_tokens.each { |tok, val| yield @delegate.span(tok, val) }
          yield "\n"
          yield %(</span>) if should_highlight
        end
      end
    end
  end
end
