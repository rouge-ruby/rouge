module Rouge
  class Guesser
    def self.guess(guessers, lexers)
      original_size = lexers.size

      guessers.each do |g|
        new_lexers = g.filter(lexers)
        lexers = new_lexers.any? ? new_lexers : lexers
      end

      # if we haven't filtered the input at *all*,
      # then we have no idea what language it is,
      # so we bail and return [].
      lexers.size < original_size ? lexers : []
    end

    def filter(lexers)
      raise 'abstract'
    end
  end
end
