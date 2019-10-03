# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::MiniZinc do
  let(:subject) { Rouge::Lexers::MiniZinc.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.mzn'
      assert_guess :filename => 'foo.fzn'
      assert_guess :filename => 'foo.dzn'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/minizinc'
    end
  end
end
