# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Liquid do
  let(:subject) { Rouge::Lexers::Liquid.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'file.liquid'
    end
  end
end
