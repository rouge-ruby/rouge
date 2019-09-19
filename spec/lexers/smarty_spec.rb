# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Smarty do
  let(:subject) { Rouge::Lexers::Smarty.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.tpl'
      assert_guess :filename => 'foo.smarty'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'application/x-smarty'
      assert_guess :mimetype => 'text/x-smarty'
    end
  end
end
