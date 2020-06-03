# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Zig do
  let(:subject) { Rouge::Lexers::Zig.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.zig'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-zig'
    end
  end

  describe 'lexing' do
    include Support::Lexing;

    it 'classifies identifiers' do
      assert_tokens_equal 'var x: i32 = 100;',
        ['Keyword', 'var'],
        ['Text', ' '],
        ['Name', 'x'],
        ['Punctuation', ':'],
        ['Text', ' '],
        ['Keyword.Type', 'i32'],
        ['Text', ' '],
        ['Operator', '='],
        ['Text', ' '],
        ['Literal.Number.Integer', '100'],
        ['Punctuation', ';']

      assert_tokens_equal 'var x: f32 = 1.01;',
        ['Keyword', 'var'],
        ['Text', ' '],
        ['Name', 'x'],
        ['Punctuation', ':'],
        ['Text', ' '],
        ['Keyword.Type', 'f32'],
        ['Text', ' '],
        ['Operator', '='],
        ['Text', ' '],
        ['Literal.Number.Float', '1.01'],
        ['Punctuation', ';']
    end

    it 'recognizes exponents in integers and reals' do
      assert_tokens_equal '1e6', ['Literal.Number.Float', '1e6']
      assert_tokens_equal '123_456', ['Literal.Number.Integer', '123_456']
      assert_tokens_equal '3.14159_26', ['Literal.Number.Float', '3.14159_26']
      assert_tokens_equal '3.141_592e-20', ['Literal.Number.Float', '3.141_592e-20']
    end
  end
end
