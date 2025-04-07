# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::JQ do
  let(:subject) { Rouge::Lexers::JQ.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.jq'
    end
  end

  describe 'lexer' do
    include Support::Lexing

    it 'lexes string interpolation' do
      assert_tokens_equal '"value: \(.value)"',
        ['Literal.String', '"value: '],
        ['Punctuation', '\('],
        ['Name.Attribute', '.value'],
        ['Punctuation', ')'],
        ['Literal.String', '"']
    end
  end
end
