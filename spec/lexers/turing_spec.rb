# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Turing do
  let(:subject) { Rouge::Lexers::Turing.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.t'
      assert_guess :filename => 'foo.tu'
    end
  end
end
