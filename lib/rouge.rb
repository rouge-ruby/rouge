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
  end
end

load_dir = Pathname.new(__FILE__).dirname
require load_dir.join('rouge/version.rb')

require load_dir.join('rouge/util.rb')

require load_dir.join('rouge/text_analyzer.rb')
require load_dir.join('rouge/token.rb')

require load_dir.join('rouge/lexer.rb')
require load_dir.join('rouge/regex_lexer.rb')
require load_dir.join('rouge/template_lexer.rb')

Dir.glob(load_dir.join('rouge/lexers/*.rb')).each { |f| require f }

require load_dir.join('rouge/formatter.rb')
require load_dir.join('rouge/formatters/html.rb')
require load_dir.join('rouge/formatters/terminal256.rb')
require load_dir.join('rouge/formatters/null.rb')

require load_dir.join('rouge/theme.rb')
require load_dir.join('rouge/themes/thankful_eyes.rb')
require load_dir.join('rouge/themes/colorful.rb')
require load_dir.join('rouge/themes/base16.rb')
require load_dir.join('rouge/themes/github.rb')
require load_dir.join('rouge/themes/monokai.rb')
require load_dir.join('rouge/themes/molokai.rb')
require load_dir.join('rouge/themes/monokai_sublime.rb')
