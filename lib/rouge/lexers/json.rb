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
        rule %r/\s+/, Text::Whitespace
        rule %r/{/, Punctuation, :object
        rule %r/\[/, Punctuation, :array
      end

      state :object do
        rule %r/\s+/, Text::Whitespace
        rule %r/"/, Str::Double, :name
        rule %r/:/, Punctuation, :value
        rule %r/,/, Punctuation
        rule %r/}/, Punctuation, :pop!
      end

      state :value do
        rule %r/"/, Name::Tag, :stringvalue
        mixin :constants
        rule %r/}/ do
          token Punctuation
          pop! 2 # pop both this state and the :object one below it
        end
        rule %r/\[/, Punctuation, :array
        rule %r/{/, Punctuation, :object
        rule %r/}/ do
          token Punctuation
          pop! 2 # pop both this state and the :object one below it
        end
        rule %r/,/, Punctuation, :pop!
        rule %r/\s+/, Text::Whitespace
      end

      state :name do
        rule %r/[^\\"]+/, Str::Double
        rule %r/\\./, Str::Escape
        rule %r/"/, Str::Double, :pop!
      end

      state :stringvalue do
        rule %r/[^\\"]+/, Name::Tag
        rule %r/\\./, Str::Escape
        rule %r/"/, Name::Tag, :pop!
      end

      state :array do
        rule %r/\]/, Punctuation, :pop!
        rule %r/"/, Name::Tag, :stringvalue
        rule %r/,/, Punctuation
        mixin :constants
        mixin :root
      end

      state :constants do 
        rule %r/(?:true|false|null)/, Keyword::Constant
        rule %r/-?(?:0|[1-9]\d*)\.\d+(?:e[+-]?\d+)?/i, Num::Float
        rule %r/-?(?:0|[1-9]\d*)(?:e[+-]?\d+)?/i, Num::Integer
      end
    end
  end
end
