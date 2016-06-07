module Rouge
  module Guessers
    # This class allows for custom behavior
    # with glob -> lexer name mappings
    class GlobMapping < Guesser
      def self.by_pairs(mapping)
        glob_map = {}
        mapping.each do |(glob, lexer_name)|
          lexer = Lexer.find(lexer_name)

          # ignore unknown lexers and canonicalize
          # the name
          glob_map[lexer.name] = glob if lexer
        end

        new(glob_map)
      end

      attr_reader :glob_map, :filename
      def initialize(glob_map, filename)
        @glob_map = glob_map
        @filename = filename
      end

      def filter(lexers)
        basename = File.basename(filename)

        collect_best(lexers) do |lexer|
          score = (@glob_map[lexer.name] || []).map do |pattern|
            if File.fnmatch?(pattern, basename, File::FNM_DOTMATCH)
              # specificity is better the fewer wildcards there are
              -pattern.scan(/[*?\[]/).size
            end
          end.compact.min
        end
      end
    end
  end
end
