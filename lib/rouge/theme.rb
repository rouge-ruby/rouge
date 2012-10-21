module Rouge
  class Theme
    class Style < Hash
      def initialize(theme, hsh={})
        super()
        @theme = theme
        merge!(hsh)
      end

      [:fg, :bg].each do |mode|
        define_method mode do
          return self[mode] unless @theme
          @theme.palette(self[mode]) if self[mode]
        end
      end

      def render(selector, &b)
        return enum_for(:render, selector).to_a.join("\n") unless b

        return if empty?

        yield "#{selector} {"
        yield "  color: #{fg};" if fg
        yield "  background-color: #{bg};" if bg
        yield "  font-weight: bold;" if self[:bold]
        yield "  font-style: italic;" if self[:italic]
        yield "  text-decoration: underline;" if self[:underline]

        (self[:rules] || []).each do |rule|
          yield "  #{rule};"
        end

        yield "}"
      end

    end

    def styles
      @styles ||= self.class.styles.dup
    end

    @palette = {}
    def self.palette(arg={})
      @palette ||= InheritableHash.new(superclass.palette)

      if arg.is_a? Hash
        @palette.merge! arg
        @palette
      else
        case arg
        when /#[0-9a-f]+/i
          arg
        else
          @palette[arg] or raise "not in palette: #{arg.inspect}"
        end
      end
    end

    @styles = {}
    def self.styles
      @styles ||= InheritableHash.new(superclass.styles)
    end

    def self.render(opts={}, &b)
      new(opts).render(&b)
    end

    class << self
      def style(*tokens)
        style = tokens.last.is_a?(Hash) ? tokens.pop : {}

        style = Style.new(self, style)

        tokens.each do |tok|
          styles[tok.to_s] = style
        end
      end

      def get_own_style(token)
        token.ancestors do |anc|
          return styles[anc.name] if styles[anc.name]
        end
      end

      def get_style(token)
        get_own_style(token) || style['Text']
      end

      def name(n=nil)
        return @name if n.nil?

        @name = n.to_s
        Theme.registry[@name] = self
      end

      def find(n)
        registry[n.to_s]
      end

      def registry
        @registry ||= {}
      end
    end
  end

  module HasModes
    def mode(arg=:absent)
      return @mode if arg == :absent

      @modes ||= {}
      @modes[arg] ||= get_mode(arg)
    end

    def get_mode(mode)
      return self if self.mode == mode

      new_name = "#{self.name}.#{mode}"
      Class.new(self) { name(new_name); mode!(mode) }
    end

    def mode!(arg)
      @mode = arg
      send("make_#{arg}!")
    end
  end

  class CSSTheme < Theme
    def initialize(opts={})
      @scope = opts[:scope] || '.highlight'
    end

    def render(&b)
      return enum_for(:render).to_a.join("\n") unless b

      # shared styles for tableized line numbers
      yield "#{@scope} table { border-spacing: 0; }"
      yield "#{@scope} table td { padding: 5px; }"
      yield "#{@scope} table .gutter { text-align: right; }"

      styles.each do |tokname, style|
        style.render(css_selector(Token[tokname]), &b)
      end
    end

  private
    def css_selector(token)
      tokens = [token]
      parent = token.parent

      inflate_token(token).map do |tok|
        raise "unknown token: #{tok.inspect}" if tok.shortname.nil?

        single_css_selector(tok)
      end.join(', ')
    end

    def single_css_selector(token)
      return @scope if token == Token['Text']

      "#{@scope} .#{token.shortname}"
    end

    # yield all of the tokens that should be styled the same
    # as the given token.  Essentially this recursively all of
    # the subtokens, except those which are more specifically
    # styled.
    def inflate_token(tok, &b)
      return enum_for(:inflate_token, tok) unless block_given?

      yield tok
      tok.sub_tokens.each do |(_, st)|
        next if styles[st.name]

        inflate_token(st, &b)
      end
    end
  end
end
