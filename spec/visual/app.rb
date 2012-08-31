require 'rubygems'
require 'bundler'
Bundler.require
require 'rouge'

# stdlib
require 'pathname'

class VisualTestApp < Sinatra::Application
  BASE = Pathname.new(__FILE__).dirname

  configure do
    set :root, BASE
    set :views, BASE.join('templates')
  end

  get '/:lexer' do |lexer_name|
    dir = BASE.join(lexer_name)
    @lexer = Rouge::Lexer.find(lexer_name)
    halt 404 unless @lexer
    @sample = File.read(dir.join('sample'))
    formatter = Rouge::Formatters::HTML.new
    @highlighted = Rouge.highlight(@sample, lexer_name, formatter)
    @theme = Rouge::Themes::ThankfulEyes.new

    erb :lexer
  end

  get '/' do
    'TODO'
  end
end
