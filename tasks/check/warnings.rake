namespace :check do
  Rake::TestTask.new(:warnings) do |t|
    t.libs << "lib"
    t.ruby_opts << "-r./spec/spec_helper"
    t.ruby_opts << "-W2"
    t.warning = !!$VERBOSE
    t.pattern = FileList['spec/**/*_spec.rb']
  end
end

