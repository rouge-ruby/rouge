# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::CommonLisp do
  let(:subject) { Rouge::Lexers::CommonLisp.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.cl'
      assert_guess :filename => 'foo.lisp'
      assert_guess :filename => 'foo.el'
      assert_guess :filename => 'foo.asd'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-common-lisp'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'does not crash on unbalanced parentheses' do
      subject.lex(")\n").to_a
    end
  end
end
