# -*- coding: utf-8 -*- #
# frozen_string_literal: true

# stdlib
require 'pathname'
require 'set'
require 'strscan'
require 'uri'

# The containing module for Rouge
module Rouge
  # cache value in a constant since `__dir__` allocates a new string
  # on every call.
  LIB_DIR = __dir__.freeze

  class << self
    # @deprecated This method of reloading is incompatible with modern Ruby's
    # expectations around global caching of `require`. It is deprecated with no
    # replacement - consider reloading the entire process instead with something
    # like Guard. This method will be removed in rouge 5.0.
    def reload!
      Kernel::warn "Rouge.reload! is deprecated, with no replacement, and will be removed in 5.0. Use a reloading system like Guard instead."
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

    def eager_load!
      Rouge::Lexer.all.each(&:eager_load!)
    end
  end
end

require_relative 'rouge/version'
require_relative 'rouge/util'
require_relative 'rouge/text_analyzer'
require_relative 'rouge/token'

require_relative 'rouge/lexer'
require_relative 'rouge/regex_lexer'
require_relative 'rouge/template_lexer'

Dir.glob('rouge/lexers/*.rb', base: __dir__).each do |file|
  require_relative file
end

require_relative 'rouge/guesser'
require_relative 'rouge/guessers/util'
require_relative 'rouge/guessers/glob_mapping'
require_relative 'rouge/guessers/modeline'
require_relative 'rouge/guessers/filename'
require_relative 'rouge/guessers/mimetype'
require_relative 'rouge/guessers/source'
require_relative 'rouge/guessers/disambiguation'

require_relative 'rouge/formatter'
require_relative 'rouge/formatters/html'
require_relative 'rouge/formatters/html_table'
require_relative 'rouge/formatters/html_pygments'
require_relative 'rouge/formatters/html_legacy'
require_relative 'rouge/formatters/html_linewise'
require_relative 'rouge/formatters/html_line_highlighter'
require_relative 'rouge/formatters/html_line_table'
require_relative 'rouge/formatters/html_inline'
require_relative 'rouge/formatters/terminal256'
require_relative 'rouge/formatters/terminal_truecolor'
require_relative 'rouge/formatters/tex'
require_relative 'rouge/formatters/null'

require_relative 'rouge/theme'
require_relative 'rouge/tex_theme_renderer'
require_relative 'rouge/themes/thankful_eyes'
require_relative 'rouge/themes/colorful'
require_relative 'rouge/themes/base16'
require_relative 'rouge/themes/github'
require_relative 'rouge/themes/igor_pro'
require_relative 'rouge/themes/monokai'
require_relative 'rouge/themes/molokai'
require_relative 'rouge/themes/monokai_sublime'
require_relative 'rouge/themes/gruvbox'
require_relative 'rouge/themes/tulip'
require_relative 'rouge/themes/pastie'
require_relative 'rouge/themes/bw'
require_relative 'rouge/themes/magritte'
