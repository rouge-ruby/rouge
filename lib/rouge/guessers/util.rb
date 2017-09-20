module Rouge
  module Guessers
    module Util
      module SourceNormalizer
        UTF8_BOM = "\xEF\xBB\xBF"
        UTF8_BOM_RE = /\A#{UTF8_BOM}/

        # @param [String,nil] source
        # @return [String,nil]
        def self.normalize(source)
          return nil unless source
          source.sub(UTF8_BOM_RE, '').gsub(/\r\n/, "\n")
        end
      end

      def test_glob(pattern, path)
        File.fnmatch?(pattern, path, File::FNM_DOTMATCH | File::FNM_CASEFOLD)
      end

      def get_source(source)
        case source
        when String
          SourceNormalizer.normalize(source)
        when ->(s){ s.respond_to? :read }
          SourceNormalizer.normalize(source.read)
        else
          raise 'invalid source'
        end
      end
    end
  end
end
