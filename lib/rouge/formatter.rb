module Rouge
  class Formatter
    def get_output(tokens)
      enum_for(:stream_output, tokens).to_a.join
    end

    def stream_output(tokens, &b)
      raise 'abstract'
    end
  end
end
