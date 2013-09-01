# stdlib
require 'cgi'

module Rouge
  module Formatters
    # Transforms a token stream into HTML output.
    class HTML < Formatter
      tag 'html'

      # @option opts [String] :css_class ('highlight')
      # @option opts [true/false] :line_numbers (false)
      # @option opts [Rouge::CSSTheme] :inline_theme (nil)
      # @option opts [true/false] :wrap (true)
      #
      # Initialize with options.
      #
      # If `:inline_theme` is given, then instead of rendering the
      # tokens as <span> tags with CSS classes, the styles according to
      # the given theme will be inlined in "style" attributes.  This is
      # useful for formats in which stylesheets are not available.
      #
      # Content will be wrapped in a `<pre>` tag with the given
      # `:css_class` unless `:wrap` is set to `false`.
      def initialize(opts={})
        @css_class = opts.fetch(:css_class, 'highlight')
        @line_numbers = opts.fetch(:line_numbers, false)
        @inline_theme = opts.fetch(:inline_theme, nil)
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

    private
      def stream_untableized(tokens, &b)
        yield "<pre class=#{@css_class.inspect}>" if @wrap
        tokens.each do |tok, val|
          span(tok, val, &b)
        end
        yield '</pre>' if @wrap
      end

      def stream_tableized(tokens, &b)
        num_lines = 0
        last_val = ''
        formatted = ''

        tokens.each do |tok, val|
          last_val = val
          num_lines += val.scan(/\n/).size
          span(tok, val) { |str| formatted << str }
        end

        # add an extra line for non-newline-terminated strings
        if last_val[-1] != "\n"
          num_lines += 1
          span(Token::Tokens::Text::Whitespace, "\n") { |str| formatted << str }
        end

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
        yield formatted
        yield '</td>'

        yield '</tr></tbody></table>'
        yield '</pre>' if @wrap
      end

      def span(tok, val, &b)
        # TODO: properly html-encode val
        val = CGI.escape_html(val)

        case tok.shortname
        when ''
          yield val
        when nil
          raise "unknown token: #{tok.inspect} for #{val.inspect}"
        else
          if @inline_theme
            rules = @inline_theme.style_for(tok).rendered_rules

            yield '<span style='
            yield rules.to_a.join(';').inspect
            yield '>'
          else
            yield '<span class='
            yield tok.shortname.inspect
            yield '>'
          end

          yield val
          yield '</span>'
        end
      end
    end
  end
end
