# -*- coding: utf-8 -*- #
# frozen_string_literal: true

require_relative 'javascript'

module Rouge
  module Lexers
    class Gjs < Javascript
      title "Template Tag (gjs)"
      desc "Ember.js, JavaScript with <template> tags"
      tag "gjs"
      filenames "*.gjs"
      mimetypes "text/x-gjs", "application/x-gjs"

      def initialize(*)
        super
        @handlebars = Handlebars.new(options)
      end

      prepend :root do
        rule %r/(<)(template)(>)/ do
          groups Name::Tag, Keyword, Name::Tag
          push :template
        end
      end

      state :template do
        rule %r((</)(template)(>)) do
          groups Name::Tag, Keyword, Name::Tag
          pop!
        end

        rule %r/.+?(?=<\/template>)/m do
          delegate @handlebars
        end
      end
    end
  end
end
