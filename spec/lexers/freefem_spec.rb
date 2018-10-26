# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::FreeFem do
  let(:subject) { Rouge::Lexers::FreeFem.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.edp'
      assert_guess :filename => 'foo.idp', :source => 'foo'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-ffsrc'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'recognizes one-line comments not followed by a newline (#796)' do
      assert_tokens_equal '// comment', ['Comment.Single', '// comment']
    end
  end
end
