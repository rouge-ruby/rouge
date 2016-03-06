# -*- coding: utf-8 -*- #

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
      # @option opts [Array] :highlight_lines (nil)
      # @option opts [true/false] :anchors (false)
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
      def initialize(opts={})
        @css_class = opts.fetch(:css_class, 'highlight')
        @css_class = " class=#{@css_class.inspect}" if @css_class

        @line_numbers = opts.fetch(:line_numbers, false)
        @start_line = opts.fetch(:start_line, 1)
        @inline_theme = opts.fetch(:inline_theme, nil)
        @inline_theme = Theme.find(@inline_theme).new if @inline_theme.is_a? String
        @anchors = opts.fetch(:anchors, false)
        @highlight_lines = opts.fetch(:highlight_lines, nil)
        if @highlight_lines
          @highlight_lines = @highlight_lines.map { |s| s.to_i }
        end

        @wrap = opts.fetch(:wrap, true)
      end

      # @yield the html output.
      def stream(tokens, &b)
        if @anchors
          stream_anchored(tokens, &b)
        elsif @line_numbers
          stream_tableized(tokens, &b)
        else
          stream_untableized(tokens, &b)
        end
      end

    private
      def stream_untableized(tokens, &b)
        yield "<pre#@css_class><code>" if @wrap
        tokens.each{ |tok, val| span(tok, val, &b) }
        yield "</code></pre>\n" if @wrap
      end

      def stream_anchored(tokens)
        formatted = ''

        tokens.each do |tok, val|
          span(tok, val) { |str| formatted << str }
        end

        formatted_lines = formatted.split("\n")
        formatted = formatted_lines.each_with_index.map { |str, i|
          if @highlight_lines && @highlight_lines.include?(i+1)
            "<a name=\"#{@anchors}-#{i+1}\"></a><span class=\"hll\">#{str}\n</span>"
          else
            "<a name=\"#{@anchors}-#{i+1}\"></a>#{str}\n"
          end
        }.join("")

        yield "<pre#@css_class><code>" if @wrap
        yield formatted
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

        numbers = (@start_line..num_lines+@start_line-1).to_a

        if @highlight_lines
          formatted_lines = formatted.split("\n")
          formatted = formatted_lines.each_with_index.map { |str, i|
            @highlight_lines.include?(i+1) ? "<span class=\"hll\">#{str}\n</span>" : "#{str}"
          }.join("")

          numbers = numbers.map { |a| @highlight_lines.include?(a) ? "<span class=\"hll\">#{a}\n</span>" : "#{a}\n" }.join("")
        end

        # generate a string of newline-separated line numbers for the gutter>
        numbers = %<<pre class="lineno">#{numbers}</pre>>

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
          yield val
        else
          if @inline_theme
            rules = @inline_theme.style_for(tok).rendered_rules

            yield "<span style=\"#{rules.to_a.join(';')}\">#{val}</span>"
          else
            yield "<span class=\"#{shortname}\">#{val}</span>"
          end
        end
      end
    end
  end
end
