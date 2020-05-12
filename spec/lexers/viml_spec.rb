# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::VimL do
  let(:subject) { Rouge::Lexers::VimL.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.vim'
      assert_guess :filename => 'foo.vba'
      assert_guess :filename => '~/.vimrc'
      assert_guess :filename => '.exrc'
      assert_guess :filename => '.gvimrc'
      assert_guess :filename => '_vimrc'
      assert_guess :filename => '_gvimrc'
      assert_guess :filename => '_exrc'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-vim'
    end
  end
end
