# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class VimL < RegexLexer
      title "VimL"
      desc "VimL, the scripting language for the Vim editor (vim.org)"
      tag 'viml'
      aliases 'vim', 'vimscript', 'ex'
      filenames '*.vim', '*.vba', '.vimrc', '.exrc', '.gvimrc',
                '_vimrc', '_exrc', '_gvimrc' # _ names for windows

      mimetypes 'text/x-vim'

      lazy do
        require_relative 'viml/keywords'
      end

      state :root do
        rule %r/^(\s*)(".*?)$/ do
          groups Text, Comment
        end

        rule %r/^\s*\\/, Str::Escape

        rule %r/[ \t]+/, Text

        # TODO: regexes can have other delimiters
        rule %r(/(\\\\|\\/|[^\n/])*/), Str::Regex
        rule %r("(\\\\|\\"|[^\n"])*"), Str::Double
        rule %r('(\\\\|\\'|[^\n'])*'), Str::Single

        # if it's not a string, it's a comment.
        rule %r/(?<=\s)"[^-:.%#=*].*?$/, Comment

        rule %r/-?\d+/, Num
        rule %r/#[0-9a-f]{6}/i, Num::Hex
        rule %r/^:/, Punctuation
        rule %r/[():<>+=!\[\]{}\|,~.-]/, Punctuation
        rule %r/\b(let|if|else|endif|elseif|fun|function|endfunction)\b/,
          Keyword

        rule %r/\b(NONE|bold|italic|underline|dark|light)\b/, Name::Builtin

        rule %r/[absg]:\w+\b/, Name::Variable

        keywords %r/\b\w+\b/ do
          rule KEYWORDS[:command], Keyword
          rule KEYWORDS[:function], Name::Builtin
          rule KEYWORDS[:option], Name::Builtin
          rule KEYWORDS[:auto], Name::Builtin
          default Text
        end

        # no errors in VimL!
        rule %r/./m, Text
      end
    end
  end
end
