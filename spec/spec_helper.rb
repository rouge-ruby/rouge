# -*- coding: utf-8 -*- #
# frozen_string_literal: true

require 'rubygems'
require 'bundler'
Bundler.require
require 'rouge'
require 'minitest/spec'
require 'minitest/autorun'
require 'pry'

Token = Rouge::Token

Dir[File.expand_path('support/**/*.rb', File.dirname(__FILE__))].each {|f|
  require f
}
