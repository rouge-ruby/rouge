require 'rubygems'
require 'bundler'
Bundler.require
require 'rouge'

# stdlib
require 'pathname'

class VisualTestApp < Sinatra::Application
  BASE = Pathname.new(__FILE__).dirname
  SAMPLES = BASE.join('samples')

  configure do
    set :root, BASE
    set :views, BASE.join('templates')
  end

  get '/:lexer' do |lexer_name|
    lexer_class = Rouge::Lexer.find(lexer_name)
    halt 404 unless lexer_class
    @sample = File.read(SAMPLES.join(lexer_class.tag))

    lexer_options = {}
    lexer_options[:debug] = true if params[:debug]

    formatter = Rouge::Formatters::HTML.new
    @lexer = lexer_class.new(lexer_options)
    @highlighted = Rouge.highlight(@sample, @lexer, formatter)
    @theme = Rouge::Themes::ThankfulEyes.new

    erb :lexer
  end

  get '/' do
    'TODO'
  end
end
