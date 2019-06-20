# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Powershell < RegexLexer
      title 'powershell'
      desc 'powershell'
      tag 'powershell'
      aliases 'posh', 'microsoftshell', 'msshell'
      filenames '*.ps1', '*.psm1', '*.psd1', '*.psrc', '*.pssc'
      mimetypes 'text/x-powershell'

      state :root do
        rule %r(#requires\s-version \d.\d*$),Comment::Preproc
        rule %r(<#[\s,\S]*?#>)m, Comment::Multiline
        rule %r/#.*$/, Comment::Single
        rule %r/function\s/, Keyword
        rule %r/[a-z,A-Z,0-9]+?-[a-z,A-Z,0-9]*/, Keyword
        rule %r/param/, Keyword
        rule %r/{|}|<|>|(|)/, Operator
      end
    end
  end
end
