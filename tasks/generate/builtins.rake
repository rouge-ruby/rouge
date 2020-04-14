namespace :generate do
  desc "Generate the builtins for the given language"
  task :builtins, [:lang] do |t, args|
    exit unless args.lang

    builtin_task = "builtins:#{args.lang.downcase}"
    if Rake::Task.task_defined? builtin_task
      Rake::Task[builtin_task].invoke
    else
      puts "There is no builtin generator for #{args.lang}"
    end
  end
end
