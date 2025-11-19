# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Rell do
  let(:subject) { Rouge::Lexers::Rell.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.rell'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-rell'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'recognizes comments' do
      assert_tokens_equal '// comment', ['Comment.Single', '// comment']
    end

    it 'recognizes at-expressions' do
      assert_tokens_equal '@', %w[Operator @]
      assert_tokens_equal '@?', %w[Operator @?]
      assert_tokens_equal '@*', %w[Operator @*]
      assert_tokens_equal '@+', %w[Operator @+]
    end

    it 'recognizes annotations' do
      assert_tokens_equal '@log', %w[Name.Decorator @log]
    end

    it 'recognizes numeric literals' do
      assert_tokens_equal '123', %w[Literal.Number.Integer 123]
      assert_tokens_equal '3.14', %w[Literal.Number.Float 3.14]
      assert_tokens_equal '123L', %w[Literal.Number.Integer 123L]
      assert_tokens_equal '-42', %w[Literal.Number.Integer -42]
      assert_tokens_equal '1E1', %w[Literal.Number.Float 1E1]
      assert_tokens_equal '1e1', %w[Literal.Number.Float 1e1]
      assert_tokens_equal '1E+1', %w[Literal.Number.Float 1E+1]
      assert_tokens_equal '1E-1', %w[Literal.Number.Float 1E-1]
      assert_tokens_equal '1E1L', %w[Literal.Number.Integer 1E1L]
      assert_tokens_equal '1e1L', %w[Literal.Number.Integer 1e1L]
    end

    it 'recognizes byte array literals' do
      assert_tokens_equal 'x"deadbeef"', %w[Literal.String.Other x"deadbeef"]
    end

    it 'highlights function names' do
      tokens = subject.lex('function my_func() {}')
      assert { tokens.any? { |t, v| t.qualname == 'Name.Function' && v == 'my_func' } }
    end

    it 'recognizes attribute access' do
      tokens = subject.lex('user.name')
      assert { tokens.any? { |t, v| t.qualname == 'Name.Attribute' && v == 'name' } }
    end
  end
end
