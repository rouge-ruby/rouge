# frozen_string_literal: true

require 'bundler'
Bundler.require(:default, :development)

require_relative 'spec/visual/app'

run VisualTestApp
