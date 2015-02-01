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

        @inline_theme = opts.fetch(:inline_theme, nil)
        @inline_theme = Theme.find(@inline_theme).new if @inline_theme.is_a? String

        @wrap = opts.fetch(:wrap, true)
      end

      # @yield the html output.
      def stream(tokens, &b)
        yield "<pre#@css_class><code>" if @wrap
        tokens.each{ |tok, val| span(tok, val, &b) }
        yield "</code></pre>\n" if @wrap
      end

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

    private
      TABLE_FOR_ESCAPE_HTML = {
        '&' => '&amp;',
        '<' => '&lt;',
        '>' => '&gt;',
      }
    end
  end
end
