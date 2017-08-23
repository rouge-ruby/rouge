module Rouge
  module Guessers
    class Disambiguation < Guesser
      include Util

      def initialize(filename, source)
        @filename = File.basename(filename)
        @source = source
      end

      def filter(lexers)
        return lexers if lexers.size == 1
        return lexers if lexers.size == Lexer.all.size

        @analyzer = TextAnalyzer.new(get_source(@source))

        self.class.disambiguators.each do |disambiguator|
          next unless disambiguator.match?(@filename)

          filtered = disambiguator.decide!(self)
          return filtered if filtered
        end

        return lexers
      end

      def contains?(text)
        return @analyzer.include?(text)
      end

      def matches?(re)
        return !!(@analyzer =~ re)
      end

      @disambiguators = []
      def self.disambiguate(pattern, &decider)
        @disambiguators << Disambiguator.new(pattern, &decider)
      end

      def self.disambiguators
        @disambiguators
      end

      class Disambiguator
        include Util

        def initialize(pattern, &decider)
          @pattern = pattern
          @decider = decider
        end

        def decide!(guesser)
          out = guesser.instance_eval(&@decider)
          case out
          when Array then out
          when nil then nil
          else [out]
          end
        end

        def match?(filename)
          test_glob(@pattern, filename)
        end
      end

      disambiguate '*.pl' do
        next Lexers::Perl if contains?('my $')
        next Lexers::Prolog if contains?(':-')
        next Lexers::Prolog if matches?(/\A\w+(\(\w+\,\s*\w+\))*\./)
      end
    end
  end
end
