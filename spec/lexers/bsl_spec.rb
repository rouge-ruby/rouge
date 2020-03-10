# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Bsl do
  let(:subject) { Rouge::Lexers::Bsl.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.bsl'
      assert_guess :filename => 'foo.os'
    end
  end
end
