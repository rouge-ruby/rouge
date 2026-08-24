# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Agda do
  let(:subject) { Rouge::Lexers::Agda.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.agda'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-agda'
    end
  end
end
