# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    require_relative 'jsx.rb'
    require_relative 'typescript/common.rb'

    class TSX < JSX
      include TypescriptCommon

      title 'TypeScript'
      desc 'tsx'

      tag 'tsx'
      filenames '*.tsx'
    end
  end
end

