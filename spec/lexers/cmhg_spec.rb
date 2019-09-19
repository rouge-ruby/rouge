# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::CMHG do
  let(:subject) { Rouge::Lexers::CMHG.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.cmhg'
    end
  end
end
