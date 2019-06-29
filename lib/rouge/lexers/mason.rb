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

      # Note: If you add a tag in the lines below, you also need to modify "disambiguate '*.m'" in file disambiguation.rb
      textblocks = %w(text doc)
      perlblocks = %w(args flags attr init once shared perl cleanup filter)
      components = %w(def method)
  
      state :root do
        mixin :mason_tags
      end

      state :mason_tags do
        rule /\s+/, Text::Whitespace

        rule /<%(#{textblocks.join('|')})>/i, Comment::Preproc, :text_block

        rule /<%(#{perlblocks.join('|')})>/i, Comment::Preproc, :perl_block

        rule /(<%(#{components.join('|')}))([^>]*)(>)/i do |m|
          token Comment::Preproc, m[1]
          token Name, m[3]
          token Comment::Preproc, m[4]
          push :component_block
        end
        
        # perl line
        rule /^(%)(.*)$/ do |m|
          token Comment::Preproc, m[1]
          delegate @perl, m[2]
        end

        # start of component call
        rule /<%/, Comment::Preproc, :component_call

         # start of component with content
        rule /<&\|/ do
          token Comment::Preproc
          push :component_with_content
          push :component_sub
        end

        # start of component substitution
        rule /<&/, Comment::Preproc, :component_sub

        # fallback to HTML until a mason tag is encountered
        rule(/(.+?)(?=(<\/?&|<\/?%|^%|^#))/m) { delegate parent }

        # if we get here, there's no more mason tags, so we parse the rest of the doc as HTML
        rule(/.+/m) { delegate parent }
      end

      state :perl_block do
        rule /<\/%(#{perlblocks.join('|')})>/i, Comment::Preproc, :pop!
        rule /\s+/, Text::Whitespace
        rule /^(#.*)$/, Comment
        rule(/(.*?[^"])(?=<\/%)/m) { delegate @perl }
      end

      state :text_block do
        rule /<\/%(#{textblocks.join('|')})>/i, Comment::Preproc, :pop!
        rule /\s+/, Text::Whitespace
        rule /^(#.*)$/, Comment
        rule /(.*?[^"])(?=<\/%)/m, Comment
      end

      state :component_block do
        rule /<\/%(#{components.join('|')})>/i, Comment::Preproc, :pop!
        rule /\s+/, Text::Whitespace
        rule /^(#.*)$/, Comment
        mixin :mason_tags
      end

      state :component_with_content do
        rule /<\/&>/ do 
          token Comment::Preproc
          pop!
        end

        mixin :mason_tags
      end

      state :component_sub do
        rule /&>/, Comment::Preproc, :pop!

        rule(/(.*?)(?=&>)/m) { delegate @perl }
      end

      state :component_call do
        rule /%>/, Comment::Preproc, :pop!

        rule(/(.*?)(?=%>)/m) { delegate @perl }
      end

      state :comment do
      
      end
    end
  end
end
  