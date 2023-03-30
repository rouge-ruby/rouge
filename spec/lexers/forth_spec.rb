# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Forth do
  let(:subject) { Rouge::Lexers::Forth.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.fs', :source => ': noop ( -- ) ;'
      assert_guess :filename => 'foo.fth'
      assert_guess :filename => 'foo.4th'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-forth'
    end

    it 'guesses by source' do
      assert_guess :source => '#! /usr/bin/gforth'
    end
  end
end
