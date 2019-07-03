# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Mosel do
  let(:subject) { Rouge::Lexers::Mosel.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.mos'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-mosel'
    end
  end
end
