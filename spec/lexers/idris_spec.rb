# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Idris do
  let(:subject) { Rouge::Lexers::Idris.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.idr'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-idris'
    end
  end
end
