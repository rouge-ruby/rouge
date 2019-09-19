namespace :check do
  Rake::TestTask.new(:specs) do |t|
    t.libs << "lib"
    t.ruby_opts << "-r./spec/spec_helper"
    t.warning = !!$VERBOSE
    t.pattern = FileList['spec/**/*_spec.rb']
  end
end

