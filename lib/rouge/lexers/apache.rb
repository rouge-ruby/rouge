require 'yaml'

module Rouge
  module Lexers
    class Apache < RegexLexer
      desc 'configuration files for Apache web server'
      tag 'apache'
      mimetypes 'text/x-httpd-conf', 'text/x-apache-conf'
      filenames '.htaccess', 'httpd.conf'

      class << self
        attr_reader :keywords
      end
      # Load Apache keywords from separate YML file
      @keywords = ::YAML.load(File.open(Pathname.new(__FILE__).dirname.join('apache/keywords.yml')))

      def name_for_token(token)
        if self.class.keywords[:sections].include? token
          Name::Class
        elsif self.class.keywords[:directives].include? token
          Name::Label
        elsif self.class.keywords[:values].include? token
          Literal::String::Symbol
        end
      end

      state :root do
        rule /\#.*?\n/, Comment

        rule /(<\/?)(\w+)/ do |m|
          token Text, m[1]
          token name_for_token(m[2]), m[2]
          push :section
        end

        rule /\s*(\w+)/ do |m|
          token name_for_token(m[1]), m[0]
          push :directive
        end

        rule /^\n+/, Text # Empty lines
      end

      state :section do
        # Match section arguments
        rule /(\s+[^>]+)?(>\n)/ do |m|
          token Literal::String::Regex, m[1]
          token Text, m[2]
          pop!
        end
      end

      state :directive do
        # Match value literals and other directive arguments
        rule /(\s+(\w+))*(\s?.*\n)/ do |m|
          token name_for_token(m[1]), m[1]
          token Text, m[3]
          pop!
        end
      end
    end
  end
end
