# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::ReasonML do
  let(:subject) { Rouge::Lexers::ReasonML.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.re'
      assert_guess :filename => 'foo.rei'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-reasonml'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'recognizes value as a Name' do
      assert_tokens_equal 'value', ['Name', 'value']
    end

    it 'recognizes nonrec as a Keyword' do
      assert_tokens_equal 'nonrec', ['Keyword', 'nonrec']
    end
  end
end
