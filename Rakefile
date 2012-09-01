require 'rake/clean'

task :spec do
  spec_files = FileList.new('./spec/**/*_spec.rb')
  switch_spec_files = spec_files.map { |x| "-r#{x}" }.join(' ')
  sh "ruby -I./lib -r ./spec/spec_helper #{switch_spec_files} -e Minitest::Unit.autorun"
end

CLEAN.include('*.gem')
task :build => [:clean, :spec] do
  puts
  sh "gem build rouge.gemspec"
end

task :default => :spec
