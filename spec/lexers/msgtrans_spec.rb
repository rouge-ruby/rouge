# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::MsgTrans do
  let(:subject) { Rouge::Lexers::MsgTrans.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'Messages', :source => 'Token:Token'
      assert_guess :filename => 'Message0'
      assert_guess :filename => 'Message12'
      assert_guess :filename => 'Message123'
    end
  end
end
