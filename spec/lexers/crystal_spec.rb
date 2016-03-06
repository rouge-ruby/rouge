# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Crystal do
  let(:subject) { Rouge::Lexers::Crystal.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.cr'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-crystal'
      assert_guess :mimetype => 'application/x-crystal'
    end

    it 'guesses by source' do
      assert_guess :source => '#!/usr/local/bin/crystal'
    end
  end
end
