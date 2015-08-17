require 'yaml'

module Rouge
  module Lexers
    class Apache < RegexLexer
      title "Apache"
      desc 'configuration files for Apache web server'
      tag 'apache'
      mimetypes 'text/x-httpd-conf', 'text/x-apache-conf'
      filenames '.htaccess', 'httpd.conf'

      MAP = { :directives => Name::Class, :sections => Name::Label, :values => Literal::String::Symbol }

      class << self
        attr_reader :keywords
      end
      # Load Apache keywords from separate YML file
      @keywords = ::YAML.load(File.open(Pathname.new(__FILE__).dirname.join('apache/keywords.yml')))

      def name_for_token(token, type)
        if self.class.keywords[type].bsearch { |value| token <=> value }
          MAP[type]
        else
          Text
        end
      end

      state :whitespace do
        rule /\#.*?\n/, Comment
        rule /\s+/m, Text
      end

      state :root do
        mixin :whitespace

        rule /(<\/?)(\w+)/ do |m|
          groups Punctuation, name_for_token(m[2].downcase, :sections)
          push :section
        end

        rule /\w+/ do |m|
          token name_for_token(m[0].downcase, :directives)
          push :directive
        end
      end

      state :section do
        # Match section arguments
        rule /([^>]+)?(>\R?)/ do |m|
          groups Literal::String::Regex, Punctuation
          pop!
        end

        mixin :whitespace
      end

      state :directive do
        # Match value literals and other directive arguments
        rule /\R/, Text, :pop!

        mixin :whitespace

        rule /\S+/ do |m|
          token name_for_token(m[0], :values)
        end
      end
    end
  end
end
