#!/usr/bin/env ruby

require_relative "lib/rouge"

lexer = Rouge::Lexers::CSS.new
content = File.read("test_nested_css.css")
tokens = lexer.lex(content)

tokens.each do |token, text|
  puts "#{token}: #{text.inspect}"
end
