# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class JSON < RegexLexer
      title 'JSON'
      desc "JavaScript Object Notation (json.org)"
      tag 'json'
      filenames '*.json', 'Pipfile.lock'
      mimetypes 'application/json', 'application/vnd.api+json',
                'application/hal+json', 'application/problem+json',
                'application/schema+json'

      state :root do
        rule /\s+/, Text::Whitespace
        rule /{/, Punctuation, :object
        rule /\[/, Punctuation, :array
      end

      state :object do
        rule /\s+/, Text::Whitespace
        rule /"/, Str::Double, :name
        rule /:/, Punctuation, :value
        rule /,/, Punctuation
        rule /}/, Punctuation, :pop!
      end

      state :value do
        rule /"/, Name::Tag, :stringvalue
        mixin :constants
        rule /}/ do
          token Punctuation
          pop! 2 # pop both this state and the :object one below it
        end
        rule /\[/, Punctuation, :array
        rule /{/, Punctuation, :object
        rule /}/ do
          token Punctuation
          pop! 2 # pop both this state and the :object one below it
        end
        rule /,/, Punctuation, :pop!
        rule /\s+/, Text::Whitespace
      end

      state :name do
        rule /[^\\"]+/, Str::Double
        rule /\\./, Str::Escape
        rule /"/, Str::Double, :pop!
      end

      state :stringvalue do
        rule /[^\\"]+/, Name::Tag
        rule /\\./, Str::Escape
        rule /"/, Name::Tag, :pop!
      end

      state :array do
        rule /\]/, Punctuation, :pop!
        rule /"/, Name::Tag, :stringvalue
        rule /,/, Punctuation
        mixin :constants
        mixin :root
      end

      state :constants do 
        rule /(?:true|false|null)/, Keyword::Constant
        rule /-?(?:0|[1-9]\d*)\.\d+(?:e[+-]?\d+)?/i, Num::Float
        rule /-?(?:0|[1-9]\d*)(?:e[+-]?\d+)?/i, Num::Integer
      end
    end
  end
end
