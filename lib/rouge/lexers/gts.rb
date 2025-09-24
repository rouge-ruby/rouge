# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    load_lexer 'typescript.rb'

    class Gts < Typescript
      title "Template Tag (gts)"
      desc "Ember.js, TypeScript with <template> tags"
      tag "gts"
      filenames "*.gts"
      mimetypes "text/x-gts", "application/x-gts"

      def initialize(*)
        super
      end

      prepend :root do
        rule %r/(<\s*)(template)(\s*>)/ do
          groups Name::Tag, Keyword, Name::Tag
          push :template
        end
      end

      state :template do
        rule %r((<\s*/\s*)(template)(\s*>)) do
          groups Name::Tag, Keyword, Name::Tag
          pop!
        end
      end
    end
  end
end
