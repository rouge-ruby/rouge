# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
    module Lexers
      load_lexer 'python.rb'
  
      class Mojo < Python
        title "Mojo"
        desc "The Mojo programming language"
        tag 'mojo'
        filenames '*.mojo', '*.🔥'




        rule %r/(fn)((?:\s|\\\s)+)/ do
            groups Keyword, Text
            push :funcname
        end