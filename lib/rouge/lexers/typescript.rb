# -*- coding: utf-8 -*- #
# frozen_string_literal: true

require_relative 'javascript'
require_relative 'typescript/common'

module Rouge
  module Lexers
    class Typescript < Javascript
      extend TypescriptCommon

      title "TypeScript"
      desc "TypeScript, a superset of JavaScript (https://www.typescriptlang.org/)"

      tag 'typescript'
      aliases 'ts'

      filenames '*.ts', '*.d.ts', '*.cts', '*.mts'

      mimetypes 'text/typescript'
    end
  end
end
