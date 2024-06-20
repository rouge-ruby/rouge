# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Sbsl do
  let(:subject) { Rouge::Lexers::Sbsl.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.sbsl'
      assert_guess :filename => 'foo.xbsl'
    end
  end
end
