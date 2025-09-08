# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    load_lexer 'javascript.rb'
    load_lexer 'html.rb'
    load_lexer 'glimmer/common.rb'

    class GlimmerJs < Javascript
      extend GlimmerCommon
      include GlimmerCommon

      title "Glimmer JavaScript"
      desc "Ember.js Glimmer components with JavaScript (.gjs)"
      tag 'glimmer-js'
      aliases 'gjs'
      filenames '*.gjs'
      mimetypes 'text/x-gjs', 'application/x-gjs'
    end
  end
end
