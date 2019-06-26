module Similarity
  def self.test(lexer_class)
    # state_defintions is an InheritableHash, so we use `own_keys` to
    # exclude states inherited from superclasses
    state_names = Set.new(lexer_class.state_definitions.own_keys)

    candidates = Rouge::Lexer.all.select do |x|
      # we can only compare to RegexLexers which have state_definitions
      next false unless x < Rouge::RegexLexer

      # don't compare a lexer to itself or any subclasses
      next false if x <= lexer_class

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
