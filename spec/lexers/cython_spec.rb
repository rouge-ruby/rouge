# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Cython do
  let(:subject) { Rouge::Lexers::Cython.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.pyx'
      assert_guess :filename => 'foo.pxd'
      assert_guess :filename => 'foo.pxi'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-cython'
      assert_guess :mimetype => 'application/x-cython'
    end
  end
end

