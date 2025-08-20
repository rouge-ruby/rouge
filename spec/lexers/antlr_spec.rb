# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::ANTLR do
  let(:subject) { Rouge::Lexers::ANTLR.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.g4'
    end

  end
end
