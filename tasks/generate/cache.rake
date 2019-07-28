namespace :generate do
  desc "Generate a cache of lexers"
  task :cache do
    require "json"
    require "rouge/util"
    require "rouge/token"
    require "rouge/lexer"
    require "rouge/regex_lexer"
    require "rouge/template_lexer"

    builder = Rouge::Tasks::ProxyBuilder.new

    paths = FileList["lib/rouge/lexers/*.rb"]
    paths.each { |path| Rouge::Lexers.load_lexer File.basename(path) }

    proxies = Array.new

    builder.lexer_classes.each do |lexer,path|
      next if lexer.tag.nil?

      unless lexer.name =~ /Rouge::Lexers::\w+/
        raise "#{lexer.name} is an invalid class name"
      end

      proxies << { "path"      => path,
                   "name"      => lexer.name.split("::").last,
                   "tag"       => lexer.tag,
                   "aliases"   => lexer.aliases,
                   "filenames" => lexer.filenames,
                   "mimetypes" => lexer.mimetypes }
    end

    File.write("cache/proxies.json", JSON.generate(proxies) + "\n")
  end
end

module Rouge
  module Tasks
    class ProxyBuilder
      attr_accessor :source_files
      attr_accessor :lexer_classes

      def initialize()
        @source_files = Array.new
        @lexer_classes = Hash.new

        builder = self

        ::Rouge::Lexer.define_singleton_method(:inherited) do |subclass|
          builder.lexer_classes[subclass] = builder.source_files.last
        end

        ::Rouge::Lexers.singleton_class.send(:alias_method,
                                             :load_lexer_original,
                                             :load_lexer)

        ::Rouge::Lexers.define_singleton_method(:load_lexer) do |relpath|
          builder.source_files.push relpath
          ::Rouge::Lexers.load_lexer_original relpath
          builder.source_files.pop
        end
      end
    end
  end
end
