# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::JSL do
  let(:subject) { Rouge::Lexers::JSL.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.jsl'
    end
    
  end
end
