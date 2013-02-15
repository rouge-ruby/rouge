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
load load_dir.join('rouge/version.rb')

load load_dir.join('rouge/util.rb')

load load_dir.join('rouge/text_analyzer.rb')
load load_dir.join('rouge/token.rb')

load load_dir.join('rouge/lexer.rb')
load load_dir.join('rouge/regex_lexer.rb')
load load_dir.join('rouge/template_lexer.rb')

load load_dir.join('rouge/lexers/text.rb')
load load_dir.join('rouge/lexers/diff.rb')
load load_dir.join('rouge/lexers/tex.rb')
load load_dir.join('rouge/lexers/markdown.rb')
load load_dir.join('rouge/lexers/yaml.rb')

load load_dir.join('rouge/lexers/sql.rb')

load load_dir.join('rouge/lexers/make.rb')
load load_dir.join('rouge/lexers/shell.rb')
load load_dir.join('rouge/lexers/viml.rb')
load load_dir.join('rouge/lexers/nginx.rb')
load load_dir.join('rouge/lexers/conf.rb')
load load_dir.join('rouge/lexers/sed.rb')
load load_dir.join('rouge/lexers/puppet.rb')

load load_dir.join('rouge/lexers/javascript.rb')
load load_dir.join('rouge/lexers/css.rb')
load load_dir.join('rouge/lexers/html.rb')
load load_dir.join('rouge/lexers/xml.rb')
load load_dir.join('rouge/lexers/php.rb')

load load_dir.join('rouge/lexers/haml.rb')
load load_dir.join('rouge/lexers/sass.rb')
load load_dir.join('rouge/lexers/scss.rb')
load load_dir.join('rouge/lexers/coffeescript.rb')

load load_dir.join('rouge/lexers/erb.rb')
load load_dir.join('rouge/lexers/handlebars.rb')

load load_dir.join('rouge/lexers/tcl.rb')
load load_dir.join('rouge/lexers/python.rb')
load load_dir.join('rouge/lexers/ruby.rb')
load load_dir.join('rouge/lexers/perl.rb')
load load_dir.join('rouge/lexers/factor.rb')
load load_dir.join('rouge/lexers/clojure.rb')
load load_dir.join('rouge/lexers/groovy.rb')
load load_dir.join('rouge/lexers/io.rb')

load load_dir.join('rouge/lexers/haskell.rb')
load load_dir.join('rouge/lexers/scheme.rb')
load load_dir.join('rouge/lexers/common_lisp.rb')

load load_dir.join('rouge/lexers/c.rb')
load load_dir.join('rouge/lexers/cpp.rb')
load load_dir.join('rouge/lexers/java.rb')
load load_dir.join('rouge/lexers/rust.rb')

load load_dir.join('rouge/lexers/csharp.rb')

load load_dir.join('rouge/lexers/smalltalk.rb')

load load_dir.join('rouge/formatter.rb')
load load_dir.join('rouge/formatters/html.rb')
load load_dir.join('rouge/formatters/terminal256.rb')

load load_dir.join('rouge/theme.rb')
load load_dir.join('rouge/themes/thankful_eyes.rb')
load load_dir.join('rouge/themes/colorful.rb')
load load_dir.join('rouge/themes/base16.rb')
