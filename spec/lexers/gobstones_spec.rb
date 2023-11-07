# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Gobstones do
  let(:subject) { Rouge::Lexers::Gobstones.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'meta.gbs'
    end
  end
end
