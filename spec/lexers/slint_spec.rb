# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Slint do
  let(:subject) { Rouge::Lexers::Slint.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.slint'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'application/x-slint'
      assert_guess :mimetype => 'text/x-slint'
    end
  end
end
