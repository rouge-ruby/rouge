module Rouge
  module Guessers
    class Filename < Guesser
      attr_reader :fname
      def initialize(filename)
        @filename = filename
        @basename = File.basename(filename)
      end

      # returns a list of lexers that match the given filename with
      # equal specificity (i.e. number of wildcards in the pattern).
      # This helps disambiguate between, e.g. the Nginx lexer, which
      # matches `nginx.conf`, and the Conf lexer, which matches `*.conf`.
      # In this case, nginx will win because the pattern has no wildcards,
      # while `*.conf` has one.
      def filter(lexers)
        out = []
        best_seen = nil
        lexers.each do |lexer|
          score = lexer.filenames.map do |pattern|
            if File.fnmatch?(pattern, @basename, File::FNM_DOTMATCH)
              # specificity is better the fewer wildcards there are
              pattern.scan(/[*?\[]/).size
            end
          end.compact.min

          next unless score

          if best_seen.nil? || score < best_seen
            best_seen = score
            out = [lexer]
          elsif score == best_seen
            out << lexer
          end
        end

        out.any? ? out : lexers
      end
    end
  end
end
