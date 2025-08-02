#!/usr/bin/env ruby

require_relative "lib/rouge"

lexer = Rouge::Lexers::CSS.new
content = File.read("spec/visual/samples/css")
tokens = lexer.lex(content)

puts "Nested selectors found:"
tokens.select { |token, text| token == Rouge::Token::Tokens::Name::Tag }.each do |_, text|
  puts "  #{text.inspect}"
end
