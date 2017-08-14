# -*- coding: utf-8 -*- #

describe Rouge::Lexers::SuperCollider do
  let(:subject) { Rouge::Lexers::SuperCollider.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.scd'
      assert_guess :filename => 'foo.sc'
    end
  end
end
