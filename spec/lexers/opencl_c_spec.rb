# -*- coding: utf-8 -*- #

describe Rouge::Lexers::OpenCLC do
  let(:subject) { Rouge::Lexers::OpenCLC.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.cl', :source => '@property'
    end

    it 'guesses by source' do
      assert_guess :filename => 'foo.c', :source => 'cl_device'
      assert_guess :filename => 'foo.h', :source => 'cl_int'
      assert_guess :source => 'cl_float'
    end
  end
end

