# -*- coding: utf-8 -*- #

# stdlib
require 'cgi'

module Rouge
  module Formatters
    # Transforms a token stream into HTML output.
    class HTML < Formatter
      tag 'html'

      formatter_option :css_class, String, 'highlight'
      formatter_option :line_numbers, Symbol, false
      formatter_option :line_css_class, String, 'line'
      formatter_option :start_line, Fixnum, 1
      formatter_option :inline_theme, CSSTheme, nil
      formatter_option :wrap, TrueClass, true

      # @option opts [String] :css_class ('highlight')
      # @option opts [true/false/:table/:csscounters] :line_numbers (false)
      # @option opts [String] :line_css_class ('line')
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
      # Content will be wrapped in a tag (`div` if tableized, `pre` if
      # not) with the given `:css_class` unless `:wrap` is set to `false`.
      #
      # If `:line_numbers` is `true` (for compatibility) or `:table`,
      # line numbers are output as a table with two cells, one containing
      # the line numbers, the other the whole code. With `:csscounters`,
      # each line is wrapped into a `<span>` tag to allow line numbering
      # to be handled by CSS3 counters like this (SASS):
      #
      #   pre {
      #     padding-left: 2.5em;
      #     counter-reset: code;
      #     span.line {
      #       display: block;
      #       counter-increment: code;
      #       white-space: pre;
      #       &:before {
      #         content: counter(code);
      #         float: left;
      #         margin-left: -2.5em;
      #         width: 2em;
      #         text-align: right;
      #       }
      #     }
      #   }
      #
      # For later case, the default CSS class for the `span` tag is
      # `'line'` but can be freely redefined by `:line_css_class` option.
      # Default (`:line_numbers` to any other value) is to not display
      # any line number.
      def initialize(opts={})
        super
        @css_class = " class=\"#{@css_class}\"" if @css_class
      end

      # @yield the html output.
      def stream(tokens, &b)
        case @line_numbers
        when true, :table
          stream_tableized(tokens, &b)
        when :csscounters
          stream_lineized(tokens, &b)
        else
          stream_untableized(tokens, &b)
        end
      end

    private
      def stream_lineized(tokens, &b)
        formatted = ''
        yield '<pre>' if @wrap
        yield "<span class=\"#{@line_css_class}\">"
        tokens.each{ |tok, val| span(tok, val, &b) }
        yield formatted
        yield '</span>'
        yield '</pre>' if @wrap
      end

      def stream_untableized(tokens, &b)
        yield "<pre#@css_class><code>" if @wrap
        tokens.each{ |tok, val| span(tok, val, &b) }
        yield "</code></pre>\n" if @wrap
      end

      def stream_tableized(tokens)
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

        # generate a string of newline-separated line numbers for the gutter>
        numbers = %<<pre class="lineno">#{(@start_line..num_lines+@start_line-1)
          .to_a.join("\n")}</pre>>

        yield "<div#@css_class>" if @wrap
        yield '<table style="border-spacing: 0"><tbody><tr>'

        # the "gl" class applies the style for Generic.Lineno
        yield '<td class="gutter gl" style="text-align: right">'
        yield numbers
        yield '</td>'

        yield '<td class="code">'
        yield '<pre>'
        yield formatted
        yield '</pre>'
        yield '</td>'

        yield "</tr></tbody></table>\n"
        yield "</div>\n" if @wrap
      end

      TABLE_FOR_ESCAPE_HTML = {
        '&' => '&amp;',
        '<' => '&lt;',
        '>' => '&gt;',
      }

      def span(tok, val)
        val = val.gsub(/[&<>]/, TABLE_FOR_ESCAPE_HTML)
        shortname = tok.shortname or raise "unknown token: #{tok.inspect} for #{val.inspect}"

        if shortname.empty?
          yield :csscounters == @line_numbers ? val.gsub("\n", "\n</span><span class=\"#{@line_css_class}\">") : val
        else
          if @inline_theme
            rules = @inline_theme.get_style(tok).rendered_rules.to_a.join ';'

            yield "<span style=\"#{rules}\">"
            yield :csscounters == @line_numbers ? val.gsub("\n", "\n</span></span><span class=\"#{@line_css_class}\"><span class=\"#{rules}\">") : val
          else
            yield "<span class=\"#{shortname}\">"
            yield :csscounters == @line_numbers ? val.gsub("\n", "\n</span></span><span class=\"#{@line_css_class}\"><span class=\"#{shortname}\">") : val
          end
          yield '</span>'
        end
      end
    end
  end
end
