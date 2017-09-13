# -*- coding: utf-8 -*- #

# stdlib
require 'pathname'

# The containing module for Rouge
module Rouge
  class << self
    # Highlight some text with a given lexer and formatter.
    #
    # @example
    #   Rouge.highlight('@foo = 1', 'ruby', 'html')
    #   Rouge.highlight('var foo = 1;', 'js', 'terminal256')
    #
    #   # streaming - chunks become available as they are lexed
    #   Rouge.highlight(large_string, 'ruby', 'html') do |chunk|
    #     $stdout.print chunk
    #   end
    def highlight(text, lexer, formatter, &b)
      lexer = Lexer.find(lexer) unless lexer.respond_to? :lex
      raise "unknown lexer #{lexer}" unless lexer

      formatter = Formatter.find(formatter) unless formatter.respond_to? :format
      raise "unknown formatter #{formatter}" unless formatter

      formatter.format(lexer.lex(text), &b)
    end

    # @private
    def load_components(root, glob)
      root_path = Pathname.new(root)
      Dir.glob(root_path.join(glob)).each do |f|
        relative_path = Pathname.new(f).relative_path_from(root_path).to_s
        require_relative(relative_path)
      end
    end
  end
end

require_relative('rouge/version.rb')

require_relative('rouge/util.rb')

require_relative('rouge/text_analyzer.rb')
require_relative('rouge/token.rb')

require_relative('rouge/lexer.rb')
require_relative('rouge/regex_lexer.rb')
require_relative('rouge/template_lexer.rb')
Rouge.load_components(__dir__, 'rouge/lexers/*.rb')

require_relative('rouge/guesser.rb')
Rouge.load_components(__dir__, 'rouge/guessers/*.rb')

require_relative('rouge/formatter.rb')
Rouge.load_components(__dir__, 'rouge/formatters/*.rb')

require_relative('rouge/theme.rb')
Rouge.load_components(__dir__, 'rouge/themes/*.rb')
