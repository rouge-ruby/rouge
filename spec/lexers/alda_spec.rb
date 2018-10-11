# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Alda do
  let(:subject) { Rouge::Lexers::Alda.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.alda'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/alda'
    end

  end
end
