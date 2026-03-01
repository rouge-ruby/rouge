# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Veryl do
  let(:subject) { Rouge::Lexers::Veryl.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.veryl'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-veryl'
    end
  end
end
