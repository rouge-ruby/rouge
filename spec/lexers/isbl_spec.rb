# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Isbl do
  let(:subject) { Rouge::Lexers::Isbl.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.isbl'
    end
  end
end
