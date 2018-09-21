# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::HyLang do
  let(:subject) { Rouge::Lexers::HyLang.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.hy'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-hy'
      assert_guess :mimetype => 'application/x-hy'
    end
  end
end
