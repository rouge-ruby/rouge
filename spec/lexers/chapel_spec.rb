# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Chapel do
  let(:subject) { Rouge::Lexers::Chapel.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.chpl'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-chpl'
    end
  end
end
