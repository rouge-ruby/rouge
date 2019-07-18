# -*- coding: utf-8 -*- #
# frozen_string_literal: true

require 'rubygems'
require 'bundler'
Bundler.require(:default, :development)

# stdlib
require 'pathname'

class VisualTestApp < Sinatra::Application
  BASE = Pathname.new(__FILE__).dirname
  SAMPLES = BASE.join('samples')
  ROOT = BASE.parent.parent

  ROUGE_LIB = ROOT.join('lib/rouge.rb')

  DEMOS = ROOT.join('lib/rouge/demos')

  def reload_source!
    Object.send :remove_const, :Rouge
    load ROUGE_LIB
  end

  def query_string
    env['rack.request.query_string']
  end

  # Invoke a specific formatter based on what one intends to test
  def setup_formatter(params)
    # parameters disabled by default
    inline       = as_boolean params.fetch(:inline, false)
    line_numbers = as_boolean params.fetch(:line_numbers, false)

    # parameters enabled by default
    wrapped    = as_boolean params.fetch(:wrap, true)
    line_table = as_boolean params.fetch(:line_table, true)

    # base HTML formatter
    formatter = inline ?
                  Rouge::Formatters::HTMLInline.new(@theme) :
                  Rouge::Formatters::HTML.new

    if line_numbers
      formatter = line_table ?
                    Rouge::Formatters::HTMLLineTable.new(formatter) :
                    Rouge::Formatters::HTMLTable.new(formatter)
    end

    return Rouge::Formatters::HTMLPygments.new(formatter) if wrapped

    formatter
  end

  def as_boolean(value)
    case value
    when nil, false, 0, '0', 'false', 'off', 'disabled', ''
      false
    else
      true
    end
  end

  configure do
    set :root, BASE
    set :views, BASE.join('templates')
  end

  before do
    reload_source!

    Rouge::Lexer.enable_debug!
    Rouge::Formatter.enable_escape! if params[:escape]

    theme_class = Rouge::Theme.find(params[:theme] || 'thankful_eyes')
    halt 404 unless theme_class

    @theme         = theme_class.new(scope: '.codehilite')
    @comment_color = theme_class.get_style(Rouge::Token::Tokens::Comment).fg
    @formatter     = setup_formatter(params)
  end

  get '/:lexer' do |lexer_name|
    @lexer = Rouge::Lexer.find_fancy("#{lexer_name}?#{query_string}")
    halt 404 unless @lexer
    @sample = File.read(SAMPLES.join(@lexer.class.tag), encoding: 'utf-8')

    @title = "#{@lexer.class.tag} | Visual Test"
    @raw = Rouge.highlight(@sample, 'plaintext', @formatter)
    @highlighted = Rouge.highlight(@sample, @lexer, @formatter)

    template = params[:juxtaposed] ? :lexer_juxtaposed : :lexer
    erb template
  end


  get '/' do
    @samples = DEMOS.entries.sort.reject { |s| s.basename.to_s =~ /^\.|~$/ }
    @samples.map!(&Rouge::Lexer.method(:find))

    erb :index
  end
end
