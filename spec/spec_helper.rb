# -*- coding: utf-8 -*- #
# frozen_string_literal: true

require 'rubygems'
require 'bundler'
Bundler.require

$VERBOSE = true

require 'rouge'
require 'minitest/autorun'

Token = Rouge::Token

Dir[File.expand_path('support/**/*.rb', File.dirname(__FILE__))].each {|f|
  require f
}
