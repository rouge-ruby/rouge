module Rouge
  module Guessers
    module Util
      def test_glob(pattern, path)
        File.fnmatch?(pattern, path, File::FNM_DOTMATCH | File::FNM_CASEFOLD)
      end

      def get_source(source)
        case source
        when String
          source
        when ->(s){ s.respond_to? :read }
          source.read
        else
          raise 'invalid source'
        end
      end
    end
  end
end
