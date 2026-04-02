# -*- coding: utf-8 -*- #

describe Rouge::Lexers::GAL do
  let(:subject) { Rouge::Lexers::GAL.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.gal'
      assert_guess :filename => 'FOO.GAL'
    end

  end
end
