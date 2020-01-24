# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    preload 'jsx'
    load_helper 'typescript/common'

    class TSX < JSX
      include TypescriptCommon

      title 'TypeScript'
      desc 'tsx'

      tag 'tsx'
      filenames '*.tsx'
    end
  end
end

