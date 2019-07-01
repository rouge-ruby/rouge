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
        return false if text.doctype?(/((?:ht|x)ml)/)
        return true if text.doctype?
      end

      # Note: If you add a tag in the lines below, you also need to modify "disambiguate '*.m'" in file disambiguation.rb
      TEXT_BLOCKS = %w(text doc)
      PERL_BLOCKS = %w(args flags attr init once shared perl cleanup filter strings general_media shared_vars)
      COMPONENTS = %w(def method)
  
      state :root do
        mixin :mason_tags
      end

      state :mason_tags do
        rule %r/\s+/, Text::Whitespace

        rule %r/<%(#{TEXT_BLOCKS.join('|')})>/oi, Keyword, :text_block

        rule %r/<%(#{PERL_BLOCKS.join('|')})>/oi, Keyword, :perl_block

        rule %r/(<%(#{COMPONENTS.join('|')}))([^>]*)(>)/oi do |m|
          token Keyword, m[1]
          token Name, m[3]
          token Keyword, m[4]
          push :component_block
        end
        
        # perl line
        rule %r/^(%)(.*)$/ do |m|
          token Keyword, m[1]
          delegate @perl, m[2]
        end

        # start of component call
        rule %r/<%/, Keyword, :component_call

         # start of component with content
        rule %r/<&\|/ do
          token Keyword
          push :component_with_content
          push :component_sub
        end

        # start of component substitution
        rule %r/<&/, Keyword, :component_sub

        # fallback to HTML until a mason tag is encountered
        rule(/(.+?)(?=(<\/?&|<\/?%|^%|^#))/m) { delegate parent }

        # if we get here, there's no more mason tags, so we parse the rest of the doc as HTML
        rule(/.+/m) { delegate parent }
      end

      state :perl_block do
        rule %r/<\/%(#{PERL_BLOCKS.join('|')})>/oi, Keyword, :pop!
        rule %r/\s+/, Text::Whitespace
        rule %r/^(#.*)$/, Comment
        rule(/(.*?[^"])(?=<\/%)/m) { delegate @perl }
      end

      state :text_block do
        rule %r/<\/%(#{TEXT_BLOCKS.join('|')})>/oi, Keyword, :pop!
        rule %r/\s+/, Text::Whitespace
        rule %r/^(#.*)$/, Comment
        rule %r/(.*?[^"])(?=<\/%)/m, Comment
      end

      state :component_block do
        rule %r/<\/%(#{COMPONENTS.join('|')})>/oi, Keyword, :pop!
        rule %r/\s+/, Text::Whitespace
        rule %r/^(#.*)$/, Comment
        mixin :mason_tags
      end

      state :component_with_content do
        rule %r/<\/&>/ do 
          token Keyword
          pop!
        end

        mixin :mason_tags
      end

      state :component_sub do
        rule %r/&>/, Keyword, :pop!

        rule(/(.*?)(?=&>)/m) { delegate @perl }
      end

      state :component_call do
        rule %r/%>/, Keyword, :pop!

        rule(/(.*?)(?=%>)/m) { delegate @perl }
      end
    end
  end
end
  