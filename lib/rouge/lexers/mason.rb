# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Mason < TemplateLexer
      title 'Mason'
      desc 'HTML::Mason'
      tag 'mason'
      filenames '*.mi', '*.mc', '*.mas', '*.m', '*.mhtml', '*.mcomp', 'autohandler', 'dhandler'
      mimetypes 'text/x-mason', 'application/x-mason'

      def initialize(*)
        super
        @perl = Perl.new
      end
  
      def self.detect?(text)
        return false if text.doctype?(/[html|xml]/)
        return true if text.doctype?
      end

      textblocks = %w(text doc)
      perlblocks = %w(args flags attr init once shared perl cleanup filter)
      components = %w(def method)
  
      state :root do
        mixin :mason_tags
      end

      state :mason_tags do
        rule /\s+/, Text::Whitespace

        rule /<%(#{textblocks.join('|')})>/i, Keyword::Constant, :text_block

        rule /<%(#{perlblocks.join('|')})>/i, Keyword::Constant, :perl_block

        rule /(<%(#{components.join('|')}))([^>]*)(>)/i do |m|
          token Keyword::Constant, m[1]
          token Name, m[3]
          token Keyword::Constant, m[4]
          push :component_block
        end

        # other perl blocks
        rule /<%([a-zA-Z_]*)>/i, Keyword::Constant, :other_perl_blocks
        
        # perl comment
        rule /^(#.*)$/, Comment

        # perl line
        rule /^%(.*)$/ do |m|
          token Keyword::Constant, '%'
          delegate @perl, m[1]
        end

        # start of component call
        rule /<%/, Keyword::Constant, :component_call

         # start of component with content
        rule /<&\|/ do
          token Keyword::Constant
          push :component_with_content
          push :component_sub
        end

        # start of component substitution
        rule /<&/, Keyword::Constant, :component_sub

        # fallback to HTML until a mason tag is encountered
        rule(/(.+?)(?=(<\/?&|<\/?%|^%|^#))/m) { delegate parent }

        # if we get here, there's no more mason tags, so we parse the rest of the doc as HTML
        rule(/.+/m) { delegate parent }
      end

      state :perl_block do
        rule /<\/%(#{perlblocks.join('|')})>/i, Keyword::Constant, :pop!

        rule(/(.*?[^"])(?=<\/%)/m) { delegate @perl; }
      end

      state :other_perl_blocks do
        rule /<\/%[a-zA-Z_]*>/i, Keyword::Constant, :pop!

        rule(/(.*?[^"])(?=<\/%)/m) { delegate @perl; }
      end

      state :text_block do
        rule /<\/%(#{textblocks.join('|')})>/i, Keyword::Constant, :pop!

        rule /(.*?[^"])(?=<\/%)/m, Comment
      end

      state :component_block do
        rule /<\/%(#{components.join('|')})>/i, Keyword::Constant, :pop!
        
        mixin :mason_tags
      end

      state :component_with_content do
        rule /<\/&>/ do 
          token Keyword::Constant
          pop!
        end

        mixin :mason_tags
      end

      state :component_sub do
        rule /&>/, Keyword::Constant, :pop!

        rule(/(.*?)(?=&>)/m) { delegate @perl; }
      end

      state :component_call do
        rule /%>/, Keyword::Constant, :pop!

        rule(/(.*?)(?=%>)/m) { delegate @perl; }
      end
    end
  end
end
  