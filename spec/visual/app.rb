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
    theme_class = Rouge::Theme.find(params[:theme] || 'thankful_eyes')
    halt 404 unless theme_class

    @sample = File.read(SAMPLES.join(lexer_class.tag))

    lexer_options = {}
    params.each do |k, v|
      lexer_options[k.to_sym] = v
    end

    formatter = Rouge::Formatters::HTML.new
    @lexer = lexer_class.new(lexer_options)
    @theme = theme_class.new
    @highlighted = Rouge.highlight(@sample, @lexer, formatter)

    erb :lexer
  end


  get '/' do
    @samples = SAMPLES.entries.reject { |s| s.basename.to_s =~ /^\.|~$/ }
    erb :index
  end
end
