# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    load_lexer 'javascript.rb'

    class Gjs < Javascript
      title "Template Tag (gjs)"
      desc "Ember.js, JavaScript with <template> tags"
      tag "gjs"
      filenames "*.gjs"
      mimetypes "text/x-gjs", "application/x-gjs"

      def initialize(*)
        super
      end
    end
  end
end
