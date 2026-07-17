# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Go do
  let(:subject) { Rouge::Lexers::Go.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.go'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-go'
      assert_guess :mimetype => 'application/x-go'
    end
  end

  describe 'numeric literals with underscores' do
    include Support::Lexing

    it 'lexes decimal integers with underscores' do
      assert_tokens_equal '100_000', ['Literal.Number', '100_000']
      assert_tokens_equal '1_2_3_4_5', ['Literal.Number', '1_2_3_4_5']
    end

    it 'lexes hexadecimal integers with underscores' do
      assert_tokens_equal '0x_1234_ABCD', ['Literal.Number', '0x_1234_ABCD']
      assert_tokens_equal '0xDEAD_BEEF', ['Literal.Number', '0xDEAD_BEEF']
    end

    it 'lexes binary integers with underscores' do
      assert_tokens_equal '0b1010_0110', ['Literal.Number', '0b1010_0110']
      assert_tokens_equal '0B_1111_0000', ['Literal.Number', '0B_1111_0000']
    end

    it 'lexes octal integers with underscores' do
      assert_tokens_equal '0o755_777', ['Literal.Number', '0o755_777']
      assert_tokens_equal '0O_777', ['Literal.Number', '0O_777']
    end

    it 'lexes floating-point numbers with underscores' do
      assert_tokens_equal '1_000.5', ['Literal.Number', '1_000.5']
      assert_tokens_equal '3.14_15_92', ['Literal.Number', '3.14_15_92']
    end

    it 'lexes imaginary numbers with underscores' do
      assert_tokens_equal '1_000i', ['Literal.Number', '1_000i']
    end
  end
end
