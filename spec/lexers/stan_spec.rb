# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Stan do
  let(:subject) { Rouge::Lexers::Stan.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.stan'
      assert_guess :filename => 'foo.stanfunctions'
    end
  end
end

