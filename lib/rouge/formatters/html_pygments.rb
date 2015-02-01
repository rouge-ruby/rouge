module Rouge
  module Formatters
    class HTMLPygments < HTML
      def initialize(opts)
        @css_class = opts.fetch(:css_class, 'codehilite')
        super
      end

      def stream(tokens, &b)
        yield %<<pre class="#@css_class"><code>>
        super
        yield "</code></pre>"
      end
    end
  end
end
