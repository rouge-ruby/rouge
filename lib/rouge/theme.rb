module Rouge
  class Theme
    class << self
      def styles
        @styles ||= {}
      end

      def main_style
        @main_style ||= {}
      end

      def style(*tokens)
        opts = {}
        opts = tokens.pop if tokens.last.is_a? Hash

        if tokens.empty?
          @main_style = opts
        end

        tokens.each do |tok|
          styles[tok.to_s] = opts
        end
      end

      def name(n=nil)
        return @name if n.nil?

        @name = n.to_s
        registry[@name] = self
      end

      def find(n)
        registry[n.to_s]
      end

      def registry
        @registry ||= {}
      end
    end
  end

  class CSSTheme < Theme
    def initialize(opts={})
      @opts = opts
    end

    def render
      out = []
      stream { |line| out << line }
      out.join("\n")
    end

    def stream(&b)
      return enum_for(:stream) unless block_given?

      self.class.styles.each do |tokname, style|
        stream_single(Token[tokname], style, &b)
      end

      render_stanza('.highlight', self.class.main_style, &b)
    end

  private
    def stream_single(tok, style, &b)
      render_stanza(css_selector(tok), style, &b)
    end

    def render_stanza(selector, style, &b)
      return if style.empty?

      yield "#{selector} {"
      yield "  color: #{style[:fg]};" if style[:fg]
      yield "  background-color: #{style[:bg]};" if style[:bg]
      yield "  font-weight: bold;" if style[:bold]
      yield "  font-style: italic;" if style[:italic]
      yield "  text-decoration: underline;" if style[:underline]

      (style[:rules] || []).each do |rule|
        yield "  #{rule};"
      end

      yield "}"
    end

    def css_selector(token)
      tokens = [token]
      parent = token.parent

      inflate_token(token).map do |tok|
        base = ".highlight"
        base << " .#{tok.shortname}" unless tok.shortname.empty?

        base
      end.join(', ')
    end

    def inflate_token(tok, &b)
      return enum_for(:inflate_token, tok) unless block_given?

      yield tok
      tok.sub_tokens.each_value do |st|
        next if self.class.styles.include? st.name

        inflate_token(st, &b)
      end
    end
  end
end
