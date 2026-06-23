# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::I4GL do
    let(:subject) { Rouge::Lexers::I4GL.new }
  
    describe 'guessing' do
      include Support::Guessing
  
      it 'guesses by filename' do
        assert_guess :filename => 'foo.4gl'
      end
    end
  end