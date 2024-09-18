# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::INI do
  let(:subject) { Rouge::Lexers::INI.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.ini'
      assert_guess :filename => '.gitconfig'
      assert_guess :filename => 'setup.cfg', :source => "[metadata]\nname = my_package"
      assert_guess :filename => '.editorconfig'
      assert_guess :filename => 'request.inf'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-ini'
      assert_guess :mimetype => 'text/inf'
    end
  end
end
