# stdlib
require 'cgi'

module Rouge
  module Formatters
    # Transforms a token stream into HTML output.
    class HTML < Formatter
      tag 'html'

      # @option opts :css_class
      # A css class to be used for the generated <pre> tag.
      def initialize(opts={})
        @css_class = opts[:css_class] || 'highlight'
      end

      # @yield the html output.
      def stream(tokens, &b)
        yield "<pre class=#{@css_class.inspect}>"
        tokens.each do |tok, val|
          # TODO: properly html-encode val
          val = CGI.escape_html(val)

          case tok.shortname
          when ''
            yield val
          when nil
            raise "unknown token: #{tok.inspect}"
          else
            yield '<span class='
            yield tok.shortname.inspect
            yield '>'
            yield val
            yield '</span>'
          end
        end
        yield '</pre>'
      end
    end
  end
end
