# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    require_relative 'javascript'
    require_relative 'typescript/common'

    class Typescript < Javascript
      extend TypescriptCommon

      title "TypeScript"
      desc "TypeScript, a superset of JavaScript"

      tag 'typescript'
      aliases 'ts'

      filenames '*.ts', '*.d.ts'

      mimetypes 'text/typescript'
    end
  end
end
