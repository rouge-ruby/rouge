# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Nim do
  let(:subject) { Rouge::Lexers::Nim.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.nim'
    end
  end
end
