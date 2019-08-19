# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::SQL do
  let(:subject) { Rouge::Lexers::SQL.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.sql'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-sql'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'recognizes one line comment on last line even when not terminated by a new line (#360)' do
      assert_tokens_equal '-- comment', ['Comment.Single', '-- comment']
    end
  end
end
