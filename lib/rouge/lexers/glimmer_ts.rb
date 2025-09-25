# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    load_lexer 'typescript.rb'
    load_lexer 'html.rb'
    load_lexer 'glimmer/common.rb'

    class GlimmerTs < Typescript
      extend GlimmerCommon
      include GlimmerCommon

      title "Glimmer TypeScript"
      desc "Ember.js Glimmer components with TypeScript (.gts)"
      tag 'glimmer-ts'
      aliases 'gts'
      filenames '*.gts'
      mimetypes 'text/x-gts', 'application/x-gts'
    end
  end
end
