# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::SPL do
  let(:subject) { Rouge::Lexers::SPL.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.spl'
    end
  end
end