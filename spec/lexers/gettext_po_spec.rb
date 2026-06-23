# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::GettextPO do
  let(:subject) { Rouge::Lexers::GettextPO.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess   :filename => 'ru_RU.po'
      assert_guess   :filename => 'domain.pot'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-gettext-translation'
    end
  end
end
