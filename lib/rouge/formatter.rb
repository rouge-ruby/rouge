module Rouge
  # A Formatter takes a token stream and formats it for human viewing.
  class Formatter
    # @private
    REGISTRY = {}

    # Specify or get the unique tag for this formatter.  This is used
    # for specifying a formatter in `rougify`.
    def self.tag(tag=nil)
      return @tag unless tag
      REGISTRY[tag] = self

      @tag = tag
    end

    # Find a formatter class given a unique tag.
    def self.find(tag)
      REGISTRY[tag]
    end

    # Format a token stream.  Delegates to {#format}.
    def self.format(tokens, opts={}, &b)
      new(opts).format(tokens, &b)
    end

    # Format a token stream.
    def format(tokens, &b)
      return enum_for(:stream, tokens).to_a.join unless b

      stream(tokens, &b)
    end

    # @deprecated Use {#format} instead.
    def render(tokens)
      warn 'Formatter#render is deprecated, use #format instead.'
      format(tokens)
    end

    # @abstract
    # yield strings that, when concatenated, form the formatted output
    def stream(tokens, &b)
      raise 'abstract'
    end
  end
end
