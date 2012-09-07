# not required by the main lib.
# to use this module, require 'rouge/cli'.

# stdlib
require 'optparse'

# gems
require 'thor'

module Rouge
  class CLI < Thor
    default_task :highlight

    def self.start(argv=ARGV, *a)
      unless %w(highlight style).include?(argv.first)
        argv.unshift 'highlight'
      end

      super(argv, *a)
    end

    desc 'highlight [FILE]', 'highlight some code'
    option :file, :aliases => '-f',  :desc => 'the file to operate on'
    option :lexer, :aliases => '-l',
      :desc => ('Which lexer to use.  If not provided, rougify will try to ' +
                'guess based on --mimetype, the filename, and the file ' +
                'contents.')
    option :mimetype, :aliases => '-m',
      :desc => ('a mimetype that Rouge will use to guess the correct lexer. ' +
                'This is ignored if --lexer is specified.')
    option :lexer_opts, :aliases => '-L', :type => :hash, :default => {},
      :desc => ('a hash of options to pass to the lexer.')
    option :formatter_opts, :aliases => '-F', :type => :hash, :default => {},
      :desc => ('a hash of options to pass to the formatter.')
    def highlight(file=nil)
      filename = options[:file] || file
      source = filename ? File.read(filename) : $stdin.read

      if options[:lexer].nil?
        lexer_class = Lexer.guess(
          :filename => filename,
          :mimetype => options[:mimetype],
          :source   => source,
        )
      else
        lexer_class = Lexer.find(options[:lexer])
        raise "unknown lexer: #{options[:lexer]}" unless lexer_class
      end

      # only HTML is supported for now
      formatter = Formatters::HTML.new(normalize_hash_keys(options[:formatter_opts]))
      lexer = lexer_class.new(normalize_hash_keys(options[:lexer_opts]))

      puts Rouge.highlight(source, lexer, formatter)
    end

    desc 'style THEME', 'render THEME as css'
    def style(theme_name='thankful_eyes')
      theme = Theme.find(theme_name)
      raise "unknown theme: #{theme_name}" unless theme

      puts theme.new(options).render
    end

  private
    # TODO: does Thor do this for me?
    def normalize_hash_keys(hash)
      out = {}
      hash.each do |k, v|
        new_key = k.tr('-', '_').to_sym
        out[new_key] = v
      end

      out
    end
  end
end
