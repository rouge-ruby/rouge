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
      if argv.include? '-v' or argv.include? '--version'
        puts Rouge.version
        exit 0
      end

      unless %w(highlight style list --help -h help).include?(argv.first)
        argv.unshift 'highlight'
      end

      super(argv, *a)
    end

    desc 'highlight [FILE]', 'highlight some code'
    option :input_file, :aliases => '-i',  :desc => 'the file to operate on'
    option :lexer, :aliases => '-l',
      :desc => ('Which lexer to use.  If not provided, rougify will try to ' +
                'guess based on --mimetype, the filename, and the file ' +
                'contents.')
    option :formatter, :aliases => '-f', :default => 'terminal256',
      :desc => ('Which formatter to use.')
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

      formatter_class = Formatter.find(options[:formatter])

      # only HTML is supported for now
      formatter = formatter_class.new(normalize_hash_keys(options[:formatter_opts]))
      lexer = lexer_class.new(normalize_hash_keys(options[:lexer_opts]))

      formatter.format(lexer.lex(source), &method(:print))
    end

    desc 'style THEME', 'render THEME as css'
    option :scope, :desc => "a css selector to scope the styles to"
    def style(theme_name='thankful_eyes')
      theme = Theme.find(theme_name)
      raise "unknown theme: #{theme_name}" unless theme

      theme.new(options).render(&method(:puts))
    end

    desc 'list', 'list the available lexers, formatters, and styles'
    def list
      puts "== Available Lexers =="
      all_lexers = Lexer.all
      max_len = all_lexers.map { |l| l.tag.size }.max

      Lexer.all.each do |lexer|
        desc = "#{lexer.desc}"
        if lexer.aliases.any?
          desc << " [aliases: #{lexer.aliases.join(',')}]"
        end
        puts "%s: %s" % [lexer.tag, desc]
        puts
      end
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
