namespace :generate do
  desc "Generate a cache of lexers"
  task :cache do
    require "json"
    require "rouge/util"
    require "rouge/token"
    require "rouge/lexer"
    require "rouge/regex_lexer"
    require "rouge/template_lexer"

    paths = FileList["lib/rouge/lexers/*.rb"]
    
    paths.each { |path| Rouge::Lexers.load_lexer(File.basename(path)) }

    proxies = Array.new

    Rouge::Lexers.instance_variable_get(:@_loaded_files).each do |lexer,path|
      proxies << { "path"      => path,
                   "name"      => lexer.name.split("::").last,
                   "tag"       => lexer.instance_variable_get(:@tag),
                   "aliases"   => lexer.instance_variable_get(:@aliases), 
                   "filenames" => lexer.instance_variable_get(:@filenames),
                   "mimetypes" => lexer.instance_variable_get(:@mimetypes) }
    end

    File.write("cache/proxies.json", JSON.dump(proxies))
  end
end
