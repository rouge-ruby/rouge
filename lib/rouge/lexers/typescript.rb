# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    load_lexer 'javascript.rb'
    load_lexer 'typescript/common.rb'

    class Typescript < Javascript
      include TypescriptCommon

      title "TypeScript"
      desc "TypeScript, a superset of JavaScript"

      tag 'typescript'
      aliases 'ts'

      filenames '*.ts', '*.d.ts'

      mimetypes 'text/typescript'

      prepend :statement do
        rule %r/(#{Javascript.id_regex})(\??)(\s*)(:)/ do
          groups Name::Label, Punctuation, Text, Punctuation
          push :expr_start
        end
      end
    end
  end
end
