# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Nix do
  let(:subject) { Rouge::Lexers::Nix.new }

  describe 'lexing' do
    include Support::Lexing
  end
end
