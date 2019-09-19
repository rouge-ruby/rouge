# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Clean do
  let(:subject) { Rouge::Lexers::Clean.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.dcl'
      assert_guess :filename => 'foo.icl'
    end
  end
end
