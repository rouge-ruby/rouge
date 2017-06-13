source 'http://rubygems.org'

gemspec

gem 'minitest', '~> 4.0'
gem 'wrong'

gem 'rubocop', '~> 0.49.1' if RUBY_VERSION >= '2.0.0'

gem 'rake'

# don't try to install redcarpet under jruby
gem 'redcarpet', :platforms => :ruby

group :development do
  gem 'pry'

  # docs
  gem 'yard'
  gem 'github-markup'

  # for visual tests
  gem 'sinatra'
  gem 'shotgun'
end
