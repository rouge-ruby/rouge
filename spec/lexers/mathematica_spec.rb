# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Mathematica do
  let(:subject) { Rouge::Lexers::Mathematica.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.wl'
      assert_guess :filename => 'foo.m', :source => '(* Fibonacci numbers with memoization *)'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'application/vnd.wolfram.mathematica.package'
      assert_guess :mimetype => 'application/vnd.wolfram.wl'
    end
  end
end

