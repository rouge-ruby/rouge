# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::XQuery do
  let(:subject) { Rouge::Lexers::XQuery.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.xq'
      assert_guess :filename => 'bar.xquery'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'application/xquery'
    end
  end
end