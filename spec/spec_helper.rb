# -*- coding: utf-8 -*- #
# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
require 'rouge/all'
require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/power_assert'

Token = Rouge::Token

Dir[File.expand_path('support/**/*.rb', File.dirname(__FILE__))].each {|f|
  require f
}
