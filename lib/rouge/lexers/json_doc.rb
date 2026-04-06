# -*- coding: utf-8 -*- #
# frozen_string_literal: true

require_relative 'json'

module Rouge
  module Lexers
    class JSONDOC < JSON
      desc "JavaScript Object Notation with extensions for documentation"
      tag 'json-doc'
      aliases 'jsonc'

      prepend :name do
        rule %r/([$\w]+)(\s*)(:)/ do
          groups Name::Attribute, Text, Punctuation
        end
      end

      prepend :value do
        rule %r(/[*].*?[*]/), Comment
        rule %r(//.*?$), Comment::Single
        rule %r/(\.\.\.)/, Comment::Single
      end
    end
  end
end
