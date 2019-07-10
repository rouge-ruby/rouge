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

      state :whitespace do
        rule %r/\s+/, Text::Whitespace
      end

      state :root do
        mixin :whitespace
        rule %r/{/, Punctuation, :object
        rule %r/\[/, Punctuation, :array
        
        rule %r/("[^"]*")(:?)/ do |m|
          if m[2] == ":"
            groups Name::Label, Punctuation
            push :value
          else
            token Str::Double
          end
        end

        rule(%r//) { push :value }
      end

      state :object do
        mixin :whitespace
        rule %r/"/, Name::Label, :name
        rule %r/:/, Punctuation, :value
        rule %r/,/, Punctuation
        rule %r/}/, Punctuation, :pop!
      end
      
      state :value do
        mixin :whitespace
        rule %r/"/, Str::Double, :string_value
        mixin :constants
        rule %r/\[/, Punctuation, :array
        rule %r/{/, Punctuation, :object
        rule %r/}/ do
          if stack[-2].name == :object
            token Punctuation
            pop! 2 # pop both this state and the :object one below it
          else
            token Error
            pop!
          end
        end
        rule %r/,/, Punctuation, :pop!
        rule %r/:/, Punctuation
      end

      state :name do
        rule %r/[^\\"]+/, Name::Label
        rule %r/\\./, Name::Label
        rule %r/"/, Name::Label, :pop!
      end

      state :string_value do
        rule %r/[^\\"]+/, Str::Double
        rule %r/\\./, Str::Escape
        rule %r/"/, Str::Double, :pop!
      end

      state :array do
        rule %r/\]/, Punctuation, :pop!
        rule %r/"/, Str::Double, :string_value
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
