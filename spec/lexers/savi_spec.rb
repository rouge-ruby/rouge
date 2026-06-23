# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Savi do
  let(:subject) { Rouge::Lexers::Savi.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.savi'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-savi'
      assert_guess :mimetype => 'application/x-savi'
    end
  end
end
