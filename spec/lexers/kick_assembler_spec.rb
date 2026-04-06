# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::KickAssembler do
  let(:subject) { Rouge::Lexers::KickAssembler.new }

  describe 'lexing' do
    include Support::Lexing

    it 'recognizes comments' do
      assert_tokens_equal '// comment', ['Comment.Single', '// comment']
    end

    it 'recognizes labels' do
      assert_tokens_equal 'foobar:', ['Name.Label', 'foobar:']
    end

    it 'recognizes mnemonics' do
      assert_tokens_equal 'lda', ['Keyword', 'lda']
      assert_tokens_equal 'LDA', ['Keyword', 'LDA']
      assert_tokens_equal 'Lda', ['Keyword', 'Lda']
    end

    it 'recognizes 65c02 mnemonics' do
      assert_tokens_equal 'phx', ['Keyword', 'phx']
      assert_tokens_equal 'bra', ['Keyword', 'bra']
      assert_tokens_equal 'stz', ['Keyword', 'stz']
    end

    it 'recognizes illegal opcodes' do
      assert_tokens_equal 'ahx', ['Keyword', 'ahx']
      assert_tokens_equal 'slo', ['Keyword', 'slo']
      assert_tokens_equal 'dcp', ['Keyword', 'dcp']
    end

    it 'recognizes .const' do
      assert_tokens_equal '.const', ['Keyword.Constant', '.const']
    end

    it 'recognizes type directives' do
      assert_tokens_equal '.text', ['Keyword.Declaration', '.text']
      assert_tokens_equal '.byte', ['Keyword.Declaration', '.byte']
      assert_tokens_equal '.word', ['Keyword.Declaration', '.word']
      assert_tokens_equal '.align', ['Keyword.Declaration', '.align']
      assert_tokens_equal '.macro', ['Keyword.Reserved', '.macro']
    end

    it 'recognizes preprocessor directives' do
      assert_tokens_equal '#define', ['Keyword', '#define']
      assert_tokens_equal '#import', ['Keyword', '#import']
      assert_tokens_equal '#if', ['Keyword', '#if']
      assert_tokens_equal '#endif', ['Keyword', '#endif']
      assert_tokens_equal '#error', ['Keyword', '#error']
    end

    it 'recognizes strings' do
      expression = '" hello\\nworld "'
      assert_tokens_equal expression, ['Literal.String', expression]
    end

    it 'recognizes character literals' do
      assert_tokens_equal "'A'", ['Literal.String.Char', "'A'"]
      assert_tokens_equal "'x'", ['Literal.String.Char', "'x'"]
    end

    it 'recognizes hexadecimal numbers' do
      assert_tokens_equal '$ab', ['Literal.Number', '$ab']
      assert_tokens_equal '$0f', ['Literal.Number', '$0f']
      assert_tokens_equal '$d', ['Literal.Number', '$d']
      assert_tokens_equal '$de2', ['Literal.Number', '$de2']
      assert_tokens_equal '$9de0', ['Literal.Number', '$9de0']
    end

    it 'recognizes binary numbers' do
      assert_tokens_equal '%010', ['Literal.Number', '%010']
      assert_tokens_equal '%10101111', ['Literal.Number', '%10101111']
    end

    it 'recognizes decimal numbers' do
      assert_tokens_equal '0', ['Literal.Number', '0']
      assert_tokens_equal '#9', ['Literal.Number', '#9']
      assert_tokens_equal '123456789', ['Literal.Number', '123456789']
    end

    it 'recognizes immediate mode' do
      assert_tokens_equal '#', ['Punctuation', '#']
    end

    it 'recognizes operators' do
      assert_tokens_equal '+', ['Operator', '+']
      assert_tokens_equal '-', ['Operator', '-']
      assert_tokens_equal '/', ['Operator', '/']
      assert_tokens_equal '*', ['Operator', '*']
      assert_tokens_equal '=', ['Operator', '=']
      assert_tokens_equal '<', ['Operator', '<']
      assert_tokens_equal '>', ['Operator', '>']
    end

    it 'recognizes punctuation' do
      assert_tokens_equal '(', ['Punctuation', '(']
      assert_tokens_equal ')', ['Punctuation', ')']
      assert_tokens_equal '{', ['Punctuation', '{']
      assert_tokens_equal '}', ['Punctuation', '}']
      assert_tokens_equal ',', ['Punctuation', ',']
    end
  end
end
