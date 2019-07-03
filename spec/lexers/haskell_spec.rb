# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Haskell do
  let(:subject) { Rouge::Lexers::Haskell.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.hs'
      assert_guess :filename => 'foo.hs-boot'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-haskell'
    end

    it 'guesses by source' do
      assert_guess :source => '#!/usr/bin/env runhaskell'
    end
  end
end
