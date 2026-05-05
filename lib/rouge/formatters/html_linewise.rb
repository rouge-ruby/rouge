# -*- coding: utf-8 -*- #
# frozen_string_literal: true

# [jneen] This is an example implementation only. You may use it as-is, but please do
# not submit patches that alter the behaviour or options of this formatter for the
# convenience of your application. You are highly encouraged to write your own
# formatter for your application instead.

module Rouge
  module Formatters
    class HTMLLinewise < Formatter
      tag 'html_linewise'

      def initialize(formatter, opts={})
        @formatter = HTML.assert_html_formatter!(formatter)
        @tag_name = opts.fetch(:tag_name, 'div')
        @class_format = opts.fetch(:class, 'line-%i')
      end

      def stream(tokens, &b)
        token_lines(tokens).with_index(1) do |line_tokens, lineno|
          yield %(<#{@tag_name} class="#{sprintf @class_format, lineno}">)
          line_tokens.each do |tok, val|
            yield @formatter.span(tok, val)
          end
          yield %(\n</#{@tag_name}>)
        end
      end
    end
  end
end
