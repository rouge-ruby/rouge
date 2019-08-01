# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Magik do
  let(:subject) { Rouge::Lexers::Magik.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.magik'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-magik'
      assert_guess :mimetype => 'application/x-magik'
    end
  end
end
