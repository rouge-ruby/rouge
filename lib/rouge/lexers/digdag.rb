module Rouge
  module Lexers
    load_lexer 'yaml.rb'

    class Digdag < YAML
      title 'digdag'
      desc 'A simple, open source, multi-cloud workflow engine (https://www.digdag.io/)'
      tag 'digdag'
      filenames '*.dig'

      mimetypes 'application/x-digdag'

      def self.analyze_text(text)
        # disable YAML.analyze_text
      end
    end
  end
end
