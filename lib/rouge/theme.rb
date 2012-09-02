module Rouge
  class Theme
    class Style < Hash
      def render(selector, &b)
        return enum_for(:render, selector).to_a.join("\n") unless b

        return if empty?

        yield "#{selector} {"
        yield "  color: #{self[:fg]};" if self[:fg]
        yield "  background-color: #{self[:bg]};" if self[:bg]
        yield "  font-weight: bold;" if self[:bold]
        yield "  font-style: italic;" if self[:italic]
        yield "  text-decoration: underline;" if self[:underline]

        (self[:rules] || []).each do |rule|
          yield "  #{rule};"
        end

        yield "}"
      end
    end

    class << self
      def styles
        @styles ||= {}
      end

      def main_style
        @main_style ||= Style.new
      end

      def style(*tokens)
        style = Style.new
        style.merge!(tokens.pop) if tokens.last.is_a? Hash

        if tokens.empty?
          @main_style = style
        end

        tokens.each do |tok|
          styles[tok.to_s] = style
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

    def render(&b)
      return enum_for(:render).to_a.join("\n") unless b

      self.class.styles.each do |tokname, style|
        style.render(css_selector(Token[tokname]), &b)
      end

      self.class.main_style.render('.highlight', &b)
    end

  private
    def css_selector(token)
      tokens = [token]
      parent = token.parent

      inflate_token(token).map do |tok|
        raise "unknown token: #{tok.inspect}" if tok.shortname.nil?

        base = ".highlight"
        base << " .#{tok.shortname}" unless tok.shortname.empty?

        base
      end.join(', ')
    end

    # yield all of the tokens that should be styled the same
    # as the given token.  Essentially this recursively all of
    # the subtokens, except those which are more specifically
    # styled.
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
