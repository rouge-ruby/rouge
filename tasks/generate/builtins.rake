namespace :generate do
  desc "Generate the builtins for the given language"
  task :builtins, [:lang] do |t, args|
    unless args.lang
      Rake.application.in_namespace("builtins") do |ns|
        ns.tasks.each do |t|
          puts "generating: #{t.name}"
          t.invoke
        end
      end
    else
      builtin_task = "builtins:#{args.lang.downcase}"
      if Rake::Task.task_defined? builtin_task
        puts "generating: #{builtin_task}"
        Rake::Task[builtin_task].invoke
      else
        puts "There is no builtin generator for #{args.lang}"
      end
    end
  end
end
