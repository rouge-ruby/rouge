# stdlib
require 'pathname'

module Rouge
  class << self
    def highlight(text, lexer_name, formatter)
      lexer = Lexer.find(lexer_name)
      raise "unknown lexer #{lexer_name}" unless lexer

      formatter.get_output(lexer.enum_tokens(text))
    end
  end
end

load_dir = Pathname.new(__FILE__).dirname
load load_dir.join('rouge/token.rb')
load load_dir.join('rouge/lexer.rb')
load load_dir.join('rouge/lexers/shell.rb')

load load_dir.join('rouge/formatter.rb')
load load_dir.join('rouge/formatters/html.rb')
