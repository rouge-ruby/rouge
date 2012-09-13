module Rouge
  class Formatter
    REGISTRY = {}

    def self.tag(tag=nil)
      return @tag unless tag
      REGISTRY[tag] = self

      @tag = tag
    end

    def self.find(tag)
      REGISTRY[tag]
    end

    def render(tokens)
      enum_for(:stream, tokens).to_a.join
    end

    def stream(tokens, &b)
      raise 'abstract'
    end
  end
end
