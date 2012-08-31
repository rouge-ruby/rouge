# stdlib
require 'pathname'

module Rouge
end

load_dir = Pathname.new(__FILE__).dirname
load load_dir.join('rouge/token.rb')
load load_dir.join('rouge/lexer.rb')
load load_dir.join('rouge/lexers/shell.rb')
