# -*- coding: utf-8 -*- #
# frozen_string_literal: true

# stdlib
require 'pathname'

# The containing module for Rouge
module Rouge
  class << self
    def reload!
      Object.send :remove_const, :Rouge
      load __FILE__
    end

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

def rouge_relative(path)
  File.join(__dir__, "rouge/#{path}.rb")
end

def lexer_dir(path = '')
  File.join(__dir__, 'rouge/lexers', path)
end

load rouge_relative 'version'
load rouge_relative 'util'
load rouge_relative 'text_analyzer'
load rouge_relative 'token'

load rouge_relative 'lexer'
load rouge_relative 'regex_lexer'
load rouge_relative 'template_lexer'

Dir.glob(lexer_dir('*rb')).each { |f| Rouge::Lexers.load_lexer(f.sub(lexer_dir, '')) }

load rouge_relative 'guesser'
load rouge_relative 'guessers/util'
load rouge_relative 'guessers/glob_mapping'
load rouge_relative 'guessers/modeline'
load rouge_relative 'guessers/filename'
load rouge_relative 'guessers/mimetype'
load rouge_relative 'guessers/source'
load rouge_relative 'guessers/disambiguation'

load rouge_relative 'formatter'
load rouge_relative 'formatters/html'
load rouge_relative 'formatters/html_table'
load rouge_relative 'formatters/html_pygments'
load rouge_relative 'formatters/html_legacy'
load rouge_relative 'formatters/html_linewise'
load rouge_relative 'formatters/html_line_table'
load rouge_relative 'formatters/html_inline'
load rouge_relative 'formatters/terminal256'
load rouge_relative 'formatters/terminal_truecolor'
load rouge_relative 'formatters/tex'
load rouge_relative 'formatters/null'

load rouge_relative 'theme'
load rouge_relative 'tex_theme_renderer'
load rouge_relative 'themes/thankful_eyes'
load rouge_relative 'themes/colorful'
load rouge_relative 'themes/base16'
load rouge_relative 'themes/github'
load rouge_relative 'themes/igor_pro'
load rouge_relative 'themes/monokai'
load rouge_relative 'themes/molokai'
load rouge_relative 'themes/monokai_sublime'
load rouge_relative 'themes/gruvbox'
load rouge_relative 'themes/tulip'
load rouge_relative 'themes/pastie'
load rouge_relative 'themes/bw'
load rouge_relative 'themes/magritte'
