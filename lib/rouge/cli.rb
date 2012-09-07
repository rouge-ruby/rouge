# not required by the main lib.
# to use this module, require 'rouge/cli'.

# stdlib
require 'optparse'

# gems
require 'thor'

module Rouge
  class CLI < Thor
    default_task :highlight

    desc 'highlight [FILE]', 'highlight some code'
    option :file, :aliases => '-f',  :desc => 'the file to operate on'
    option :lexer, :aliases => '-l', :desc => ('Which lexer to use.  If not provided, '
                                               'rougify will try to guess based on '
                                               '--mimetype, the filename, and the file '
                                               'contents.')
    option :mimetype, :aliases => '-l', :desc => ''
    def highlight(file=nil)
      filename = options[:file] || file
      source = filename ? File.read(filename) : $stdin.read

      if options[:lexer].nil?
        lexer = Lexer.guess(
          :filename => filename,
          :mimetype => options[:mimetype],
          :source   => source,
        )
      else
        lexer = Lexer.find(options[:lexer])
        raise "unknown lexer: #{options[:lexer]}" unless lexer
      end

      # only HTML is supported for now
      formatter = Formatters::HTML.new

      puts Rouge.highlight(source, lexer, formatter)
    end
  end
end
