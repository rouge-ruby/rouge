# this file is not require'd from the root.  To use this plugin, run:
#
#    require 'rouge/plugins/redcarpet'

# this plugin depends on redcarpet
require 'redcarpet'

module Rouge
  module Plugins
    module Redcarpet
      def block_code(code, language)
        lexer = Lexer.find(language) || Lexers::Text
        formatter = Formatters::HTML.new(:css_class => "highlight #{lexer.tag}")

        Rouge.highlight(code, lexer, formatter)
      end
    end
  end
end
