# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Rego do
    let(:subject) { Rouge::Lexers::Rego.new }
  
    describe 'guessing' do
      include Support::Guessing
  
      it 'guesses by filename' do
        assert_guess :filename => 'foo.rego'
      end
    end
end
  
