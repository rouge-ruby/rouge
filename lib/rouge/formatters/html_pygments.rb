# frozen_string_literal: true

# [jneen] This is an example implementation only. You may use it as-is, but please do
# not submit patches that alter the behaviour or options of this formatter for the
# convenience of your application. You are highly encouraged to write your own
# formatter for your application instead.

module Rouge
  module Formatters
    class HTMLPygments < Formatter
      def initialize(inner, css_class='codehilite')
        @inner = HTML.assert_html_formatter!(inner)
        @css_class = css_class
      end

      def stream(tokens, &b)
        yield %(<div class="highlight"><pre class="#{@css_class}"><code>)
        @inner.stream(tokens, &b)
        yield "</code></pre></div>"
      end
    end
  end
end
