# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Wollok do
  let(:subject) { Rouge::Lexers::Wollok.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.wlk'
      assert_guess :filename => 'foo.wtest'
      assert_guess :filename => 'foo.wpgm'
    end
  end
end
