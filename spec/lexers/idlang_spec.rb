# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::IDLang do
  let(:subject) { Rouge::Lexers::IDLang.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      #assert_guess :filename => 'foo.pro'
      assert_guess :filename => 'foo.idl'
    end
  end
end
