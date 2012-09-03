# stdlib
require 'cgi'

module Rouge
  module Formatters
    class HTML < Formatter
      def initialize(opts={})
        @css_class = opts[:css_class] || 'highlight'
      end

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
