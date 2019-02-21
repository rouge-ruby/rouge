# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::PostScript do
  let(:subject) { Rouge::Lexers::PostScript.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.ps'
      assert_guess :filename => 'foo.eps'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'application/postscript'
    end

    it 'guesses by source' do
      assert_guess :source => '%!PS'
      assert_guess :source => '%!PS-Adobe-3.0'
    end
  end
end
