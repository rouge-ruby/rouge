# -*- coding: utf-8 -*- #

require 'rubygems'
require 'bundler'
Bundler.require
require 'rouge'
require 'minitest/spec'
require 'minitest/autorun'

Token = Rouge::Token

Dir[File.expand_path('support/**/*.rb', File.dirname(__FILE__))].each {|f|
  require f
}
