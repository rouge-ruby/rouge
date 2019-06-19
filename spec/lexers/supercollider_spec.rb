# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::SuperCollider do
  let(:subject) { Rouge::Lexers::SuperCollider.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.scd'
      assert_guess :filename => 'foo.sc', :source => '~x = 3'
      assert_guess :filename => 'foo.sc', :source => '0;'
    end
  end
end
