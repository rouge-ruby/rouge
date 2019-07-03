# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Nix do
  let(:subject) { Rouge::Lexers::Nix.new }

  describe 'lexing' do
    include Support::Lexing
  end
end
