# -*- coding: utf-8 -*- #

# stdlib
require 'pathname'
require_relative 'rouge/version'
require_relative 'rouge/util'
require_relative 'rouge/text_analyzer'
require_relative 'rouge/token'
require_relative 'rouge/lexer'
require_relative 'rouge/regex_lexer'
require_relative 'rouge/template_lexer'
require_relative 'rouge/formatter'
require_relative 'rouge/theme'

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
