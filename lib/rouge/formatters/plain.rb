module Rouge
  module Formatters
    class Plain < Formatter
      tag 'plain'

      def initialize(*)
      end

      def stream(tokens)
        tokens.each do |_, val|
          yield val
        end
      end
    end
  end
end
