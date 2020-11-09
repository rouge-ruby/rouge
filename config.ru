# frozen_string_literal: true

require 'bundler/setup'
require 'rouge'

require 'pathname'

here = Pathname.new(__FILE__).dirname
load here.join('spec/visual/app.rb')

run VisualTestApp
