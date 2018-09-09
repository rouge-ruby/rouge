# frozen_string_literal: true

require 'rake/clean'
require 'pathname'
require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:spec) do |t|
  t.libs << "lib"
  t.ruby_opts << "-r./spec/spec_helper"
  t.warning = false # TODO: true
  t.pattern = FileList['spec/**/*_spec.rb']
end

task :test => [:spec]

task :doc do
  sh 'bundle exec yard'
end

namespace :doc do
  task :server do
    sh 'bundle exec yard server --reload'
  end

  task :clean do
    sh 'rm -rf ./doc/ ./.yardoc/'
  end
end

CLEAN.include('*.gem')
task :build => [:clean, :spec] do
  puts
  sh "gem build rouge.gemspec"
end

task :default => :spec

Dir.glob(Pathname.new(__FILE__).dirname.join('tasks/*.rake')).each do |f|
  load f
end
