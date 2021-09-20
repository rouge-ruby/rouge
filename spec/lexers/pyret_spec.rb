# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Pyret do
  let(:subject) { Rouge::Lexers::Pyret.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.arr'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'application/pyret'
    end
  end
end