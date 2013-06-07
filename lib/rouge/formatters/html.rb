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
        @line_numbers = opts.fetch(:line_numbers) { false }
        @wrap = opts.fetch(:wrap, true)
      end

      # @yield the html output.
      def stream(tokens, &b)
        if @line_numbers
          stream_tableized(tokens, &b)
        else
          stream_untableized(tokens, &b)
        end
      end

      def stream_untableized(tokens, &b)
        yield "<pre class=#{@css_class.inspect}>" if @wrap
        tokens.each do |tok, val|
          span(tok, val, &b)
        end
        yield '</pre>' if @wrap
      end

      def stream_tableized(tokens, &b)
        num_lines = 0
        code = ''

        tokens.each do |tok, val|
          num_lines += val.scan(/\n/).size
          span(tok, val) { |str| code << str }
        end

        # add an extra line number for non-newline-terminated strings
        num_lines += 1 if code[-1] != "\n"

        # generate a string of newline-separated line numbers for the gutter
        numbers = num_lines.times.map do |x|
          %<<div class="lineno">#{x+1}</div>>
        end.join

        yield "<pre class=#{@css_class.inspect}>" if @wrap
        yield "<table><tbody><tr>"

        # the "gl" class applies the style for Generic.Lineno
        yield '<td class="gutter gl">'
        yield numbers
        yield '</td>'

        yield '<td class="code">'
        yield code
        yield '</td>'

        yield '</tr></tbody></table>'
        yield '</pre>' if @wrap
      end

    private
      def span(tok, val, &b)
        # TODO: properly html-encode val
        val = CGI.escape_html(val)

        case tok.shortname
        when ''
          yield val
        when nil
          raise "unknown token: #{tok.inspect} for #{val.inspect}"
        else
          yield '<span class='
          yield tok.shortname.inspect
          yield '>'
          yield val
          yield '</span>'
        end
      end
    end
  end
end
