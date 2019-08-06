# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::BBCBASIC do
  let(:subject) { Rouge::Lexers::BBCBASIC.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo,fd1'
    end
  end
end
