# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Syzprog do
  let(:subject) { Rouge::Lexers::Syzprog.new }

  describe 'lexing' do
    include Support::Lexing

    it 'recognizes syscalls' do
      assert_tokens_equal "foo$bar(&AUTO=@field, &(0x100)={0x0, nil, @void})",
        ['Name.Function', 'foo'],
        ['Punctuation', '$'],
        ['Name.Function.Magic', 'bar'],
        ['Punctuation', '(&'],
        ['Keyword', 'AUTO'],
        ['Punctuation', '=@'],
        ['Name', 'field'],
        ['Punctuation', ','],
        ['Text', ' '],
        ['Punctuation', '&('],
        ['Literal.Number.Hex', '0x100'],
        ['Punctuation', ')={'],
        ['Literal.Number.Hex', '0x0'],
        ['Punctuation', ','],
        ['Text', ' '],
        ['Keyword', 'nil'],
        ['Punctuation', ','],
        ['Text', ' '],
        ['Punctuation', '@'],
        ['Keyword', 'void'],
        ['Punctuation', '})']
    end

    it 'recognizes resources' do
      assert_tokens_equal "r0 = foo()\nbar(&AUTO={r0, <r1=>0x0})",
        ['Keyword.Pseudo', 'r0'],
        ['Text', ' '],
        ['Punctuation', '='],
        ['Text', ' '],
        ['Name.Function', 'foo'],
        ['Punctuation', '()'],
        ['Text', "\n"],
        ['Name.Function', 'bar'],
        ['Punctuation', '(&'],
        ['Keyword', 'AUTO'],
        ['Punctuation', '={'],
        ['Keyword.Pseudo', 'r0'],
        ['Punctuation', ','],
        ['Text', ' '],
        ['Punctuation', '<'],
        ['Keyword.Pseudo', 'r1'],
        ['Punctuation', '=>'],
        ['Literal.Number.Hex', '0x0'],
        ['Punctuation', '})']
    end

    it 'recognizes strings' do
      assert_tokens_equal "foo(&AUTO=ANY=[@ANYBLOB=\"AA\"], &AUTO='BB\x00')",
        ['Name.Function', 'foo'],
        ['Punctuation', '(&'],
        ['Keyword', 'AUTO'],
        ['Punctuation', '='],
        ['Keyword', 'ANY'],
        ['Punctuation', '=[@'],
        ['Keyword', 'ANYBLOB'],
        ['Punctuation', '='],
        ['Literal.String.Double', "\"AA\""],
        ['Punctuation', '],'],
        ['Text', ' '],
        ['Punctuation', '&'],
        ['Keyword', 'AUTO'],
        ['Punctuation', '='],
        ['Literal.String.Single', "'BB\x00'"],
        ['Punctuation', ')']
    end

    it 'recognizes syscalls mods' do
      assert_tokens_equal "foo(0x0) (async, rerun: 10)",
        ['Name.Function', 'foo'],
        ['Punctuation', '('],
        ['Literal.Number.Hex', '0x0'],
        ['Punctuation', ')'],
        ['Text', ' '],
        ['Punctuation', '('],
        ['Keyword', 'async'],
        ['Punctuation', ','],
        ['Text', ' '],
        ['Keyword', 'rerun'],
        ['Punctuation', ':'],
        ['Text', ' '],
        ['Literal.Number.Integer', '10'],
        ['Punctuation', ')']
    end

    # The test below checks that the lexer can process inputs with relaxed
    # whitespace usage and after-line comments. This is useful for highlighting
    # syzprog snippets that are split into multiple lines for readability and
    # that have per-line comment annotations.

    it 'recognizes relaxed syscalls' do
      assert_tokens_equal "r0 = #c\nfoo$bar( #c\n#c\n0x0,\n&AUTO={ #c\n0x0, @void})",
        ['Keyword.Pseudo', 'r0'],
        ['Text', ' '],
        ['Punctuation', '='],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n"],
        ['Name.Function', 'foo'],
        ['Punctuation', '$'],
        ['Name.Function.Magic', 'bar'],
        ['Punctuation', '('],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n"],
        ['Comment', '#c'],
        ['Text', "\n"],
        ['Literal.Number.Hex', '0x0'],
        ['Punctuation', ','],
        ['Text', "\n"],
        ['Punctuation', '&'],
        ['Keyword', 'AUTO'],
        ['Punctuation', '={'],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n"],
        ['Literal.Number.Hex', '0x0'],
        ['Punctuation', ','],
        ['Text', ' '],
        ['Punctuation', '@'],
        ['Keyword', 'void'],
        ['Punctuation', '})']
    end

  end
end
