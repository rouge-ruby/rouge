# -*- coding: utf-8 -*- #
# frozen_string_literal: true

# stdlib
require 'pathname'
require 'monitor'

# The containing module for Rouge
module Rouge
  # cache value in a constant since `__dir__` allocates a new string
  # on every call.
  LIB_DIR = __dir__.freeze

  LOAD_LOCK = Monitor.new
  ROOT = File.dirname(LIB_DIR).freeze

  class << self
    def reload!
      Object::send :remove_const, :Rouge
      Kernel::load __FILE__
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

    # Load a file relative to the `lib/rouge` path.
    #
    # @api private
    def load_file(path)
      Kernel::load File.join(LIB_DIR, "rouge/#{path}.rb")
    end
  end

  load_file 'version'
  load_file 'util'
  load_file 'text_analyzer'
  load_file 'token'

  load_file 'lexer'
  load_file 'regex_lexer'
  load_file 'template_lexer'

  load_file 'langspec'
  load_file 'langspec_cache'

  load_file 'guesser'
  load_file 'guessers/util'
  load_file 'guessers/glob_mapping'
  load_file 'guessers/modeline'
  load_file 'guessers/filename'
  load_file 'guessers/mimetype'
  load_file 'guessers/source'
  load_file 'guessers/disambiguation'

  load_file 'formatter'
  load_file 'formatters/html'
  load_file 'formatters/html_table'
  load_file 'formatters/html_pygments'
  load_file 'formatters/html_legacy'
  load_file 'formatters/html_linewise'
  load_file 'formatters/html_line_highlighter'
  load_file 'formatters/html_line_table'
  load_file 'formatters/html_inline'
  load_file 'formatters/terminal256'
  load_file 'formatters/terminal_truecolor'
  load_file 'formatters/tex'
  load_file 'formatters/null'

  load_file 'theme'
  load_file 'tex_theme_renderer'
  load_file 'themes/thankful_eyes'
  load_file 'themes/colorful'
  load_file 'themes/base16'
  load_file 'themes/github'
  load_file 'themes/igor_pro'
  load_file 'themes/monokai'
  load_file 'themes/molokai'
  load_file 'themes/monokai_sublime'
  load_file 'themes/gruvbox'
  load_file 'themes/tulip'
  load_file 'themes/pastie'
  load_file 'themes/bw'
  load_file 'themes/magritte'
end unless defined?(Rouge::ROOT)
