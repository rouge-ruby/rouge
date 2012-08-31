module Rouge
  class Formatter
    def get_output(tokens)
      out = []

      stream_output(tokens) do |result|
        out << result
      end

      out.join
    end

    def stream_output(tokens, &b)
      raise 'abstract'
    end
  end
end
