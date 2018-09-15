# -*- coding: utf-8 -*- #

describe Rouge::Lexers::M68k do
  let(:subject) { Rouge::Lexers::M68k.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.s'
      assert_guess :filename => 'foo.i'
      assert_guess :filename => 'foo.68k'
      assert_guess :filename => 'foo.m68k'
    end

    it 'guesses by source' do
      assert_guess :source => ' move '
      assert_guess :source => ' d0'
    end
  end
end

