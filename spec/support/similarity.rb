module Similarity
  def self.test(lexer_class)
    state_names = Set.new(lexer_class.state_definitions.keys)

    candidates = Rouge::Lexer.all.select do |x|
      next false if x == lexer_class
      next false unless x < Rouge::RegexLexer
      next false if x < lexer_class || lexer_class < x
      true
    end

    max_score = 1
    matches = []
    candidates.each do |candidate|
      score = (state_names & candidate.state_definitions.keys).size
      if score > max_score
        max_score = score
        matches = [candidate]
      elsif score == max_score
        matches << candidate
      end
    end

    [max_score, matches]
  end
end
