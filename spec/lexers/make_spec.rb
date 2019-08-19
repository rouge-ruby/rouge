# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Make do
  let(:subject) { Rouge::Lexers::Make.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.make'
      assert_guess :filename => 'bar.mak'
      assert_guess :filename => 'baz.mk'
      assert_guess :filename => 'Make,fe1'
      assert_guess :filename => 'Makefile'
      assert_guess :filename => 'makefile'
      assert_guess :filename => 'Makefile.in'
      assert_guess :filename => 'GNUmakefile'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-makefile'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'recognizes declarations not terminated by a new line (#694)' do
      assert_tokens_equal "hello: \n\techo hello",
       ["Name.Label", "hello"], ["Operator", ":"], ["Text", " \n\t"], ["Name.Builtin", "echo "], ["Text", "hello"]
    end
  end
end
