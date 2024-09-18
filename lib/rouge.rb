# -*- coding: utf-8 -*- #
# frozen_string_literal: true

# stdlib
require 'pathname'

# The containing module for Rouge
module Rouge
  # cache value in a constant since `__dir__` allocates a new string
  # on every call.
  LIB_DIR = __dir__.freeze

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
      warn "just use require_relative %p" % ["rouge/#{path}"]
      require_relative "rouge/#{path}"
    end

    # Load the lexers in the `lib/rouge/lexers` directory.
    #
    # @api private
    def load_lexers
      lexer_dir = Pathname.new(LIB_DIR) / "rouge/lexers"
      Pathname.glob(lexer_dir / '*.rb').each do |f|
        Lexers.load_lexer(f.relative_path_from(lexer_dir))
      end
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

Rouge.load_lexers

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
