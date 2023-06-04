# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::NSS do
  let(:subject) { Rouge::Lexers::NSS.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.nss'
      assert_guess :filename => 'FOO.NSS'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-csrc'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'recognizes one-line comments not followed by a newline (#796)' do
      assert_tokens_equal '// comment', ['Comment.Single', '// comment']
    end
  end
end
