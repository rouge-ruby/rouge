# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Janet do
  let(:subject) { Rouge::Lexers::Janet.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.janet'
      assert_guess :filename => 'foo.jdn'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-janet'
      assert_guess :mimetype => 'application/x-janet'
    end
  end
end
