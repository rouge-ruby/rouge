# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Solidity do
  let(:subject) { Rouge::Lexers::Solidity.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.sol'
      assert_guess :filename => 'foo.solidity'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-solidity'
    end

    it 'guesses by source' do
      assert_guess :source => 'pragma solidity'
    end
  end
end
