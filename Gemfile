# frozen_string_literal: true

source 'http://rubygems.org'

gemspec

gem 'rake'

gem 'minitest', '>= 5.0'
gem 'minitest-power_assert'
gem 'power_assert', '~> 2.0'

# don't try to install redcarpet under jruby
gem 'redcarpet', platforms: :ruby

# Profiling
gem 'memory_profiler', require: false

group :development do
  gem 'pry'

  # Needed for a Rake task
  gem 'git'
  gem 'yard'

  gem 'rubocop'
  gem 'rubocop-performance', '~> 1.26'
  gem 'rubocop-minitest', '~> 0.38'
  gem 'rubocop-rake', '~> 0.7'

  # docs
  gem 'github-markup'

  # for visual tests
  gem 'sinatra'

  gem 'puma'
  gem 'shotgun'

  gem "mutex_m" if RUBY_VERSION >= '3.4'
  gem "base64" if RUBY_VERSION >= '3.4'

  gem 'ostruct'
  gem 'reline'
end
