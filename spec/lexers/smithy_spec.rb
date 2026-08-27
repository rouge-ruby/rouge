# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Smithy do
    let(:subject) { Rouge::Lexers::Smithy.new }
  
    describe 'guessing' do
      include Support::Guessing
  
      it 'guesses by filename' do
        assert_guess :filename => 'foo.smithy'
      end
  
    end
  
    describe 'lexing' do
      include Support::Lexing
  
      it 'recognizes annotation with dots and hashes' do
        assert_tokens_equal '@aws.apigateway#integration', ['Name.Decorator', '@aws.apigateway#integration']
      end
    end
  end
  