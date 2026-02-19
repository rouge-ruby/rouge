# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::NuXmv do
  let(:subject) { Rouge::Lexers::NuXmv.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.smv'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-nusmv'
      assert_guess :mimetype => 'text/x-nuxmv'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'recognizes one-line comments not followed by a newline' do
      assert_tokens_equal '-- comment', ['Comment.Single', '-- comment']
    end

    it 'recognizes comments at the end of a line' do
      assert_tokens_includes 'MODULE main -- main module', ['Comment.Single', '-- main module']
      assert_tokens_includes 'MODULE main -- main module\n', ['Comment.Single', '-- main module\\n']
    end
  end
end
