# -*- coding: utf-8 -*- #

describe Rouge::Lexers::CUDA do
  let(:subject) { Rouge::Lexers::CUDA.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.cu'
      assert_guess :filename => 'foo.cuh'
    end
  end
end
