module Rouge
  class Formatter
    def render(tokens)
      enum_for(:stream, tokens).to_a.join
    end

    def stream(tokens, &b)
      raise 'abstract'
    end
  end
end
