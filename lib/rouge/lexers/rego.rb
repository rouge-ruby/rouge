# -*- coding: utf-8 -*- #
# frozen_string_literal: true
# example file taken from https://github.com/open-policy-agent/contrib/blob/f9e71d7/api_authz/docker/policy/api_authz.rego

module Rouge
    module Lexers
        class Rego < RegexLexer
            title "Rego"
            desc "The Rego open-policy-agent (OPA) policy language (https://www.openpolicyagent.org/)"
            tag 'rego'
            aliases 'rego'
            filenames '*.rego'

            state :basic do
              rule %r/\s+/, Text
              rule %r/#.*/, Comment::Single
      
              rule %r/[\[\](){}|.,;!]/, Punctuation
      
              rule %r/"[^"]*"/, Str::Double
      
              rule %r/-?\d+\.\d+([eE][+-]?\d+)?/, Num::Float
              rule %r/-?\d+([eE][+-]?\d+)?/, Num

              rule %r/\\u[0-9a-fA-F]{4}/, Num::Hex
              rule %r/\\["\/bfnrt]/, Str::Delimiter
            end
      
            state :atoms do
              rule %r/(true|false|null)/, Keyword::Constant
              rule %r/[[:word:]]*/, Str::Symbol
              rule %r/'[^']*'/, Str::Symbol
            end
      
            state :operators do
              rule %r/(=|!=|>|<|>=|<=|\+|-|\*|%|\/|\||&|:=)/, Operator
              rule %r/(default|not|package|import|as|with|else|some)/, Operator
              rule %r/[#&*+-.\/:<=>?@^~]+/, Operator
            end
      
            state :root do
              mixin :basic
              mixin :operators
              mixin :atoms
            end
        end
    end
end