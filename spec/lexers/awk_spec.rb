# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Awk do
  let(:described_class) { Rouge::Lexers::Awk }
  let(:subject) { described_class.new }

  describe 'lexing' do
    include Support::Lexing

    it %(doesn't let a bad regex mess up the whole lex) do
      assert_has_token 'Error',          "a = /foo;\n1"
      assert_has_token 'Literal.Number', "a = /foo;\n1"
    end
  end

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.awk'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'application/x-awk'
    end

    it 'guesses by source' do
      assert_guess :source => '#!/usr/bin/awk'
      assert_guess :source => '#!/usr/bin/env awk'
    end
  end

  it 'responds to self.class.detect?' do
    assert { described_class.methods(false).include?(:detect?) }
    assert { described_class.detectable? }
  end
end
