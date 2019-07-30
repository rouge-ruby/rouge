# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Batchfile do
  let(:subject) { Rouge::Lexers::Batchfile.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.bat'
      assert_guess :filename => 'foo.cmd'
    end

  end

  describe 'lexing' do
    include Support::Lexing

    it 'recognizes one-line comments' do
      assert_tokens_equal 'REM comment', ['Comment', 'REM comment']
    end
  end
end
