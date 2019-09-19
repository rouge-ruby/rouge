
namespace :check do
  desc "Analyse the memory profile of Rouge"
  task :memory do
    require 'memory_profiler'

    dir = Rake.application.original_dir
    source = File.expand_path('lib/rouge/lexer.rb', dir)
    sample = File.read(source, encoding: 'utf-8')
    report = MemoryProfiler.report do
      require 'rouge'
      formatter  = Rouge::Formatters::HTML.new
      ruby_lexer = Rouge::Lexers::Ruby.new
      guessed_lexer = Rouge::Lexer.find_fancy('guess', sample)
      formatter.format ruby_lexer.lex(sample)
      formatter.format guessed_lexer.lex(sample)
    end
    print_options = { scale_bytes: true, normalize_paths: true }

    if ENV['CI']
      report.pretty_print(print_options)
    else
      results_file = File.expand_path('rouge-memory.tmp', dir)
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
end

CLOBBER << File.expand_path('rouge-memory.tmp', Rake.application.original_dir)
