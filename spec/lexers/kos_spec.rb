# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Kos do
  let(:subject) { Rouge::Lexers::Kos.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.kos'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'application/kos'
      assert_guess :mimetype => 'text/kos'
    end

    it 'guesses by source' do
      assert_guess :source => '#!/usr/bin/env kos'
    end
  end
end
