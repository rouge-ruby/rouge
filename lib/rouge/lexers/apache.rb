# frozen_string_literal: true

require 'yaml'

module Rouge
  module Lexers
    class Apache < RegexLexer
      title "Apache"
      desc 'configuration files for Apache web server'
      tag 'apache'
      mimetypes 'text/x-httpd-conf', 'text/x-apache-conf'
      filenames '.htaccess', 'httpd.conf'

      # self-modifying method that loads the keywords file
      lazy do
        require_relative 'apache/keywords'
      end

      def name_for_token(token, tktype)
        token = token.downcase

        if SECTIONS.include? token
          tktype
        elsif DIRECTIVES.include? token
          tktype
        elsif VALUES.include? token
          tktype
        else
          Text
        end
      end

      state :whitespace do
        rule %r/\#.*/, Comment
        rule %r/\s+/m, Text
      end

      state :root do
        mixin :whitespace

        rule %r/(<\/?)(\w+)/ do |m|
          groups Punctuation, name_for_token(m[2], Name::Label)
          push :section
        end

        rule %r/\w+/ do |m|
          token name_for_token(m[0], Name::Class)
          push :directive
        end
      end

      state :section do
        # Match section arguments
        rule %r/([^>]+)?(>(?:\r\n?|\n)?)/ do
          groups Literal::String::Regex, Punctuation
          pop!
        end

        mixin :whitespace
      end

      state :directive do
        # Match value literals and other directive arguments
        rule %r/\r\n?|\n/, Text, :pop!

        mixin :whitespace

        rule %r/\S+/ do |m|
          if VALUES.include?(m[0].downcase)
            token Literal::String::Symbol
          else
            fallthrough!
          end
        end

        rule(%r/(?=\S)/) { push :value }
      end

      state :value do
        rule %r/[ \t]+/, Text, :pop!
        rule %r/[^\s%]+/, Text
        rule %r/%{.*?}/, Name::Variable
        rule %r/[%]/, Text
        rule(/(?=\n)/) { pop! }
      end
    end
  end
end
