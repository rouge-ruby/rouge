namespace :check do
  desc "Run RuboCop on bin/, lib/ and spec/"
  RuboCop::RakeTask.new(:style) do |task|
    task.fail_on_error = false
  end
end
