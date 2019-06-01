# frozen_string_literal: true

source 'http://rubygems.org'

gemspec

gem 'rake'

group :development do
  gem 'pry'

  # docs
  gem 'yard'
  gem 'github-markup'

  # for visual tests
  if RUBY_VERSION < '2.2.0'
    gem 'sinatra', '~> 1.4.8'
  else
    gem 'sinatra'
  end
  gem 'shotgun'
end

group :test do
  # automated testing
  gem 'minitest', '>= 5.0'
  gem 'minitest-power_assert'
  gem 'rubocop', '~> 0.49.1'

  # make CI builds faster
  gem 'parallel', '~> 1.13.0' if RUBY_VERSION < '2.2.0'

  # don't try to install redcarpet under jruby
  gem 'redcarpet', :platforms => :ruby
end
