# frozen_string_literal: true

require 'rake/clean'
require 'pathname'
require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:spec) do |t|
  t.libs << "lib"
  t.ruby_opts << "-r./spec/spec_helper"
  t.warning = !!$VERBOSE
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

task :profile_memory do
  lib = File.expand_path("lib", __dir__)
  $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

  require 'memory_profiler'

  source = File.expand_path('lib/rouge/lexer.rb', __dir__)
  sample = File.read(source, encoding: 'utf-8')
  report = MemoryProfiler.report do
    require 'rouge'
    formatter = Rouge::Formatters::HTML.new
    lexer     = Rouge::Lexers::Ruby.new
    formatter.format(lexer.lex(source))
  end
  print_options = { :scale_bytes => true }

  if ENV['CI']
    report.pretty_print(print_options)
  else
    results_file = File.expand_path('rouge-memory.tmp')
    t_allocated = report.scale_bytes(report.total_allocated_memsize)
    t_retained  = report.scale_bytes(report.total_retained_memsize)
    puts
    puts "Total allocated: #{t_allocated} (#{report.total_allocated} objects)"
    puts "Total retained:  #{t_retained} (#{report.total_retained} objects)"
    report.pretty_print(print_options.merge(to_file: results_file))
    puts
    puts "Detailed report saved to file: #{results_file}"
  end
end
