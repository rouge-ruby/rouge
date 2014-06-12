require 'yaml'

module Rouge
  module Lexers
    class Apache < RegexLexer
      desc 'configuration files for Apache web server'
      tag 'apache'
      mimetypes 'text/x-httpd-conf', 'text/x-apache-conf'
      filenames '.htaccess', 'httpd.conf'

      # Load Apache keywords from separate YML file
      keywords = ::YAML.load(File.open(Pathname.new(__FILE__).dirname.join('apache/keywords.yml')))

      state :root do
        rule /\#.*?\n/, Comment


        rule Regexp.new("(<)(#{keywords[:sections].join('|')})") do |m|
          token Text, m[1]
          token Name::Class, m[2]
          push :section
        end
        rule Regexp.new("(</?)(#{keywords[:sections].join('|')})(>\n)") do |m|
          token Text, m[1]
          token Name::Class, m[2]
          token Text, m[3]
        end

        rule Regexp.new("\s*(#{keywords[:directives].join('|')})") do |m|
          token Name::Label, m[0]
          push :directive
        end

        rule /^\n+/, Text # Empty lines
      end

      state :section do
        # Match section arguments
        rule /\s+([^>]+)(>\n)/ do |m|
          token Literal::String::Regex, m[1]
          token Text, m[2]
          pop!
        end
      end

      state :directive do
        # Match value literals and other directive arguments
        rule Regexp.new("(\s+(#{keywords[:values].join('|')}))*(\s?.*\n)") do |m|
          token Literal::String::Symbol, m[1]
          token Text, m[3]
          pop!
        end
      end
    end
  end
end
