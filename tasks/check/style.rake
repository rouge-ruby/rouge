namespace :check do
  desc "Run RuboCop on bin/, lib/ and spec/"
  RuboCop::RakeTask.new(:style) do |task|
    task.patterns = ["bin/**/*", "lib/**/*.rb", "spec/**/*.rb"]
    task.fail_on_error = false
  end
end
