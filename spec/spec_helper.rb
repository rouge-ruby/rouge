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

class Minitest::Test
  def rescuing(*assertions, &b)
    yield
    nil
  rescue => e
    assertions.each do |a|
      if a.is_a?(Class)
        raise e unless a === e
      else
        raise e unless a === e.message
      end
    end

    e
  end
end
