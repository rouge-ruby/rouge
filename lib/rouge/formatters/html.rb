# -*- coding: utf-8 -*- #

# stdlib
require 'cgi'

module Rouge
  module Formatters
    # Transforms a token stream into HTML output.
    class HTML < Formatter
      tag 'html'

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
        @inline_theme = opts.fetch(:inline_theme, nil)
        @inline_theme = Theme.find(@inline_theme).new if @inline_theme.is_a? String
      end

      # @yield the html output.
      def stream(tokens, &b)
        tokens.each { |tok, val| yield span(tok, val) }
      end

      def span(tok, val)
        safe_span(tok, val.gsub(/[&<>]/, TABLE_FOR_ESCAPE_HTML))
      end

      def safe_span(tok, safe_val)
        if tok == Token::Tokens::Text
          safe_val
        elsif @inline_theme
          rules = @inline_theme.style_for(tok).rendered_rules

          "<span style=\"#{rules.to_a.join(';')}\">#{safe_val}</span>"
        else
          shortname = tok.shortname \
            or raise "unknown token: #{tok.inspect} for #{safe_val.inspect}"

          "<span class=\"#{shortname}\">#{safe_val}</span>"
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
