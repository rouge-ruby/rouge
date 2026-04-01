module Rouge
  module Formatters
    class HTMLDebug < HTML
      tag 'html_debug'

      def safe_span(tok, safe_val)
        safer_val = safe_val.gsub('"', '&quot;')

        title = "#{tok.qualname}(#{safer_val})"
        shortname = tok.shortname

        %(<span title="#{title}" class="#{shortname}">#{safe_val}</span>)
      end
    end
  end
end
