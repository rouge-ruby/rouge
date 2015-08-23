# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Praat do
  let(:subject) { Rouge::Lexers::Praat.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.praat'
      assert_guess :filename => 'foo.proc'
    end

  end
end
