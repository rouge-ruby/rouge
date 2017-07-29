# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Nix < RegexLexer
      title 'Nix'
      desc 'The Nix expression language (https://nixos.org/nix/manual/#ch-expression-language)'
      tag 'nix'
      aliases 'nixos'
      filenames '*.nix'
      state :root do
        rule /.*/m, Text
      end
    end
  end
end
