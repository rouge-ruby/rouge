# -*- coding: utf-8 -*- #

describe Rouge::Lexers::OpenType do
  let(:subject) { Rouge::Lexers::OpenType.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.fea'
    end

  end
end
