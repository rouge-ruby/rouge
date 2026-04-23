# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Lateralus do
  let(:subject) { Rouge::Lexers::Lateralus.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.ltl'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-lateralus'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'lexes the pipeline operator' do
      assert_tokens_equal 'x |> f',
        ['Name', 'x'],
        ['Text', ' '],
        ['Operator', '|>'],
        ['Text', ' '],
        ['Name', 'f']
    end

    it 'lexes typed integers' do
      assert_tokens_equal '42u64', ['Literal.Number.Integer', '42u64']
      assert_tokens_equal '0xFF_i32', ['Literal.Number.Hex', '0xFF_i32']
      assert_tokens_equal '0b1010u8', ['Literal.Number.Bin', '0b1010u8']
    end

    it 'lexes typed floats' do
      assert_tokens_equal '3.14_f32', ['Literal.Number.Float', '3.14_f32']
    end

    it 'recognizes keywords and types' do
      assert_tokens_equal 'fn',  ['Keyword', 'fn']
      assert_tokens_equal 'let', ['Keyword', 'let']
      assert_tokens_equal 'int', ['Keyword.Type', 'int']
      assert_tokens_equal 'str', ['Keyword.Type', 'str']
    end

    it 'recognizes decorators' do
      assert_tokens_equal '@memo', ['Name.Decorator', '@memo']
    end

    it 'treats UpperCamelCase as a class name' do
      assert_tokens_equal 'Some', ['Keyword.Type', 'Some']
      assert_tokens_equal 'MyType', ['Name.Class', 'MyType']
    end

    it 'highlights builtin functions' do
      assert_tokens_equal 'println', ['Name.Builtin', 'println']
    end

    it 'handles line and doc comments' do
      assert_tokens_equal '// hi', ['Comment.Single', '// hi']
      assert_tokens_equal '/// doc', ['Comment.Special', '/// doc']
    end
  end
end
