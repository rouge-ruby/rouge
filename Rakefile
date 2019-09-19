# frozen_string_literal: true

require "bundler/setup"
require "bundler/gem_tasks" # Adds the :build, :install and :release tasks
require "rake/clean" # Adds the :clean and :clobber tasks
require "rake/testtask"
require "rubocop/rake_task"
require "yard"

# Add tasks
task :check => ["check:specs", "check:style"]
task :default => [:check]
task :test => [:check]

# Add pre-requisites
task :build => [:clean, :check, "generate:docs"]

# Add utility tasks
task :newline do
  puts
end

# Load tasks
Dir.glob(Pathname.new(__FILE__).dirname.join('tasks/**/*.rake')).each do |f|
  load f
end

# Legacy task names (for preserving backwards compatibility)
def alias_task(aliases)
  aliases.each do |alias_name,task_name|
    t = Rake::Task[task_name]
    task alias_name, *t.arg_names do |_, args|
      args = t.arg_names.map { |a| args[a] }
      t.invoke(args)
    end
  end
end

alias_task "changelog:insert" => "update:changelog"
alias_task :lex               => "generate:lexer"
alias_task :profile_memory    => "check:memory"
alias_task :similarity        => "check:similarity"
alias_task :spec              => "check:specs"
