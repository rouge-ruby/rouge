# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Syzlang do
  let(:subject) { Rouge::Lexers::Syzlang.new }

  describe 'lexing' do
    include Support::Lexing

    it 'recognizes comments' do
      assert_tokens_equal '# comment',
        ['Comment', '# comment']
    end

    it 'recognizes includes' do
      assert_tokens_equal 'include <uapi/linux/a.out.h>',
        ['Keyword', 'include'],
        ['Text', ' '],
        ['Punctuation', '<'],
        ['Literal.String', 'uapi/linux/a.out.h'],
        ['Punctuation', '>']
    end

    it 'recognizes defines' do
      assert_tokens_equal 'define FOO (~BAR + 0x10) / 2',
        ['Keyword', 'define'],
        ['Text', ' '],
        ['Name', 'FOO'],
        ['Text', ' '],
        ['Punctuation', '('],
        ['Operator', '~'],
        ['Name', 'BAR'],
        ['Text', ' '],
        ['Operator', '+'],
        ['Text', ' '],
        ['Literal.Number.Hex', '0x10'],
        ['Punctuation', ')'],
        ['Text', ' '],
        ['Operator', '/'],
        ['Text', ' '],
        ['Literal.Number.Integer', '2']
    end

    it 'recognizes complex defines' do
      assert_tokens_equal "define FOO\t\t_IOWR('A', 0x10, struct {int a[10]; long b;})",
        ['Keyword', 'define'],
        ['Text', ' '],
        ['Name', 'FOO'],
        ['Text', "\t\t"],
        ['Name', '_IOWR'],
        ['Punctuation', '('],
        ['Literal.String.Char', "'A'"],
        ['Punctuation', ','],
        ['Text', ' '],
        ['Literal.Number.Hex', '0x10'],
        ['Punctuation', ','],
        ['Text', ' '],
        ['Name', 'struct'],
        ['Text', ' '],
        ['Punctuation', '{'],
        ['Name', 'int'],
        ['Text', ' '],
        ['Name', 'a'],
        ['Punctuation', '['],
        ['Literal.Number.Integer', '10'],
        ['Punctuation', '];'],
        ['Text', ' '],
        ['Name', 'long'],
        ['Text', ' '],
        ['Name', 'b'],
        ['Punctuation', ';})']
    end

    it 'recognizes resources' do
      assert_tokens_equal 'resource foo[int32]: -1, BAR',
        ['Keyword', 'resource'],
        ['Text', ' '],
        ['Name', 'foo'],
        ['Punctuation', '['],
        ['Keyword.Type', 'int32'],
        ['Punctuation', ']:'],
        ['Text', ' '],
        ['Literal.Number.Integer', '-1'],
        ['Punctuation', ','],
        ['Text', ' '],
        ['Name', 'BAR']
    end

    it 'recognizes flags lists' do
      assert_tokens_equal "flags = 1, -1, 0x10, FLAG1, FLAG2, 'x'",
        ['Name', 'flags'],
        ['Text', ' '],
        ['Punctuation', '='],
        ['Text', ' '],
        ['Literal.Number.Integer', '1'],
        ['Punctuation', ','],
        ['Text', ' '],
        ['Literal.Number.Integer', '-1'],
        ['Punctuation', ','],
        ['Text', ' '],
        ['Literal.Number.Hex', '0x10'],
        ['Punctuation', ','],
        ['Text', ' '],
        ['Name', 'FLAG1'],
        ['Punctuation', ','],
        ['Text', ' '],
        ['Name', 'FLAG2'],
        ['Punctuation', ','],
        ['Text', ' '],
        ['Literal.String.Char', "'x'"]
    end

    it 'recognizes strings lists' do
      assert_tokens_equal 'strings = "foo", `bar`',
        ['Name', 'strings'],
        ['Text', ' '],
        ['Punctuation', '='],
        ['Text', ' '],
        ['Literal.String.Double', '"foo"'],
        ['Punctuation', ','],
        ['Text', ' '],
        ['Literal.String.Backtick', '`bar`']
    end

    it 'recognizes anonymous flags lists' do
      assert_tokens_equal '_ = FLAG',
        ['Keyword', '_'],
        ['Text', ' '],
        ['Punctuation', '='],
        ['Text', ' '],
        ['Name', 'FLAG']
    end

    it 'recognizes syscalls' do
      assert_tokens_equal 'foo(arg1 int32, arg2 ptr[inout, int64be])',
        ['Name.Function', 'foo'],
        ['Punctuation', '('],
        ['Name', 'arg1'],
        ['Text', ' '],
        ['Keyword.Type', 'int32'],
        ['Punctuation', ','],
        ['Text', ' '],
        ['Name', 'arg2'],
        ['Text', ' '],
        ['Keyword.Type', 'ptr'],
        ['Punctuation', '['],
        ['Keyword', 'inout'],
        ['Punctuation', ','],
        ['Text', ' '],
        ['Keyword.Type', 'int64be'],
        ['Punctuation', '])']
    end

    it 'recognizes variant syscalls' do
      assert_tokens_equal 'foo$bar(arg ptr[in, weird$struct]) fd (disabled, timeout[100])',
        ['Name.Function', 'foo'],
        ['Punctuation', '$'],
        ['Name.Function.Magic', 'bar'],
        ['Punctuation', '('],
        ['Name', 'arg'],
        ['Text', ' '],
        ['Keyword.Type', 'ptr'],
        ['Punctuation', '['],
        ['Keyword', 'in'],
        ['Punctuation', ','],
        ['Text', ' '],
        ['Name', 'weird$struct'],
        ['Punctuation', '])'],
        ['Text', ' '],
        ['Name', 'fd'],
        ['Text', ' '],
        ['Punctuation', '('],
        ['Keyword', 'disabled'],
        ['Punctuation', ','],
        ['Text', ' '],
        ['Keyword', 'timeout'],
        ['Punctuation', '['],
        ['Literal.Number.Integer', '100'],
        ['Punctuation', '])']
    end

    it 'recognizes unions' do
      assert_tokens_equal "foo [\n\t#c\n\tf0\tint32\n\tf1\tint64\n] [varlen]",
        ['Name', 'foo'],
        ['Text', ' '],
        ['Punctuation', '['],
        ['Text', "\n\t"],
        ['Comment', '#c'],
        ['Text', "\n\t"],
        ['Name', 'f0'],
        ['Text', "\t"],
        ['Keyword.Type', 'int32'],
        ['Text', "\n\t"],
        ['Name', 'f1'],
        ['Text', "\t"],
        ['Keyword.Type', 'int64'],
        ['Text', "\n"],
        ['Punctuation', ']'],
        ['Text', ' '],
        ['Punctuation', '['],
        ['Keyword', 'varlen'],
        ['Punctuation', ']']
    end

    it 'recognizes structs' do
      assert_tokens_equal "weird$struct {\n\tsize\tconst[0, int16]\n\tfield\tint32\t(in)\n} [packed, align[4]]",
        ['Name', 'weird$struct'],
        ['Text', ' '],
        ['Punctuation', '{'],
        ['Text', "\n\t"],
        ['Name', 'size'],
        ['Text', "\t"],
        ['Keyword.Type', 'const'],
        ['Punctuation', '['],
        ['Literal.Number.Integer', '0'],
        ['Punctuation', ','],
        ['Text', ' '],
        ['Keyword.Type', 'int16'],
        ['Punctuation', ']'],
        ['Text', "\n\t"],
        ['Name', 'field'],
        ['Text', "\t"],
        ['Keyword.Type', 'int32'],
        ['Text', "\t"],
        ['Punctuation', '('],
        ['Keyword', 'in'],
        ['Punctuation', ')'],
        ['Text', "\n"],
        ['Punctuation', '}'],
        ['Text', ' '],
        ['Punctuation', '['],
        ['Keyword', 'packed'],
        ['Punctuation', ','],
        ['Text', " "],
        ['Keyword', 'align'],
        ['Punctuation', '['],
        ['Literal.Number.Integer', '4'],
        ['Punctuation', ']]']
    end

    it 'recognizes types' do
      assert_tokens_equal 'type foo int32[1:5]',
        ['Keyword', 'type'],
        ['Text', ' '],
        ['Name', 'foo'],
        ['Text', ' '],
        ['Keyword.Type', 'int32'],
        ['Punctuation', '['],
        ['Literal.Number.Integer', '1'],
        ['Punctuation', ':'],
        ['Literal.Number.Integer', '5'],
        ['Punctuation', ']']
    end

    it 'recognizes struct types' do
      assert_tokens_equal "type foo[ARG1, ARG2] {\n\tf0\tARG1\n\tf1\tbar[ARG2]\n}",
        ['Keyword', 'type'],
        ['Text', ' '],
        ['Name', 'foo'],
        ['Punctuation', '['],
        ['Name', 'ARG1'],
        ['Punctuation', ','],
        ['Text', ' '],
        ['Name', 'ARG2'],
        ['Punctuation', ']'],
        ['Text', ' '],
        ['Punctuation', '{'],
        ['Text', "\n\t"],
        ['Name', 'f0'],
        ['Text', "\t"],
        ['Name', 'ARG1'],
        ['Text', "\n\t"],
        ['Name', 'f1'],
        ['Text', "\t"],
        ['Name', 'bar'],
        ['Punctuation', '['],
        ['Name', 'ARG2'],
        ['Punctuation', ']'],
        ['Text', "\n"],
        ['Punctuation', '}']
    end

    it 'recognizes many types' do
      assert_tokens_equal "type foo {\n\tf int8\n}\ntype bar int16",
        ['Keyword', 'type'],
        ['Text', ' '],
        ['Name', 'foo'],
        ['Text', ' '],
        ['Punctuation', '{'],
        ['Text', "\n\t"],
        ['Name', 'f'],
        ['Text', ' '],
        ['Keyword.Type', 'int8'],
        ['Text', "\n"],
        ['Punctuation', '}'],
        ['Text', "\n"],
        ['Keyword', 'type'],
        ['Text', ' '],
        ['Name', 'bar'],
        ['Text', ' '],
        ['Keyword.Type', 'int16']
    end

    # The tests below check that the lexer can process inputs with lists and
    # syscall arguments replaced with "...". This is useful for highlighting
    # syzlang snippets that are shortened for readability.

    it 'recognizes shortened flags lists' do
      assert_tokens_equal "flags = FLAG1, FLAG2, ...",
        ['Name', 'flags'],
        ['Text', ' '],
        ['Punctuation', '='],
        ['Text', ' '],
        ['Name', 'FLAG1'],
        ['Punctuation', ','],
        ['Text', ' '],
        ['Name', 'FLAG2'],
        ['Punctuation', ','],
        ['Text', ' '],
        ['Punctuation', '...']
    end

    it 'recognizes shortened syscalls' do
      assert_tokens_equal 'foo(...)',
        ['Name.Function', 'foo'],
        ['Punctuation', '(...)']
    end

    # The tests below check that the lexer can process inputs with relaxed
    # whitespace usage and after-line comments. This is useful for highlighting
    # syzlang snippets that are split into multiple lines for readability and
    # that have per-line comment annotations.

    it 'recognizes relaxed defines' do
      assert_tokens_equal " define #c\n\tFOO #c\n\t(1 + 2) #c",
        ['Text', ' '],
        ['Keyword', 'define'],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n\t"],
        ['Name', 'FOO'],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n\t"],
        ['Punctuation', '('],
        ['Literal.Number.Integer', '1'],
        ['Text', ' '],
        ['Operator', '+'],
        ['Text', ' '],
        ['Literal.Number.Integer', '2'],
        ['Punctuation', ')'],
        ['Text', ' '],
        ['Comment', '#c']
    end

    it 'recognizes relaxed resources' do
      assert_tokens_equal " resource #c\n\tres [int8] : #c\n\t0, #c\n\tF0 #c",
        ['Text', ' '],
        ['Keyword', 'resource'],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n\t"],
        ['Name', 'res'],
        ['Text', ' '],
        ['Punctuation', '['],
        ['Keyword.Type', 'int8'],
        ['Punctuation', ']'],
        ['Text', ' '],
        ['Punctuation', ':'],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n\t"],
        ['Literal.Number.Integer', '0'],
        ['Punctuation', ','],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n\t"],
        ['Name', 'F0'],
        ['Text', ' '],
        ['Comment', '#c']
    end

    it 'recognizes relaxed flags' do
      assert_tokens_equal " flags = #c\n\t1 , #c\n\t2 #c",
        ['Text', ' '],
        ['Name', 'flags'],
        ['Text', ' '],
        ['Punctuation', '='],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n\t"],
        ['Literal.Number.Integer', '1'],
        ['Text', ' '],
        ['Punctuation', ','],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n\t"],
        ['Literal.Number.Integer', '2'],
        ['Text', ' '],
        ['Comment', '#c']
    end

    it 'recognizes relaxed syscalls' do
      assert_tokens_equal " foo ( #c\n\targ1 fd , #c\n\targ2 #c\n\tint32 #c\n) fd #c",
        ['Text', ' '],
        ['Name.Function', 'foo'],
        ['Text', ' '],
        ['Punctuation', '('],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n\t"],
        ['Name', 'arg1'],
        ['Text', ' '],
        ['Name', 'fd'],
        ['Text', ' '],
        ['Punctuation', ','],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n\t"],
        ['Name', 'arg2'],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n\t"],
        ['Keyword.Type', 'int32'],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n"],
        ['Punctuation', ')'],
        ['Text', ' '],
        ['Name', 'fd'],
        ['Text', ' '],
        ['Comment', '#c']
    end

    it 'recognizes relaxed structs' do
      assert_tokens_equal " foo{ #c\n f #c\n bar[ #c\n int8 , #c\n int16 #c\n ] (out) #c\n } [packed] #c",
        ['Text', ' '],
        ['Name', 'foo'],
        ['Punctuation', '{'],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n "],
        ['Name', 'f'],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n "],
        ['Name', 'bar'],
        ['Punctuation', '['],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n "],
        ['Keyword.Type', 'int8'],
        ['Text', ' '],
        ['Punctuation', ','],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n "],
        ['Keyword.Type', 'int16'],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n "],
        ['Punctuation', ']'],
        ['Text', ' '],
        ['Punctuation', '('],
        ['Keyword', 'out'],
        ['Punctuation', ')'],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n "],
        ['Punctuation', '}'],
        ['Text', ' '],
        ['Punctuation', '['],
        ['Keyword', 'packed'],
        ['Punctuation', ']'],
        ['Text', ' '],
        ['Comment', '#c']
    end

    it 'recognizes relaxed types' do
      assert_tokens_equal " type #c\n foo[ #c\n A, #c\n B #c\n ] #c\n bar[ #c\n A, #c\n B, #c\n int16 #c\n ] #c",
        ['Text', ' '],
        ['Keyword', 'type'],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n "],
        ['Name', 'foo'],
        ['Punctuation', '['],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n "],
        ['Name', 'A'],
        ['Punctuation', ','],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n "],
        ['Name', 'B'],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n "],
        ['Punctuation', ']'],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n "],
        ['Name', 'bar'],
        ['Punctuation', '['],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n "],
        ['Name', 'A'],
        ['Punctuation', ','],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n "],
        ['Name', 'B'],
        ['Punctuation', ','],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n "],
        ['Keyword.Type', 'int16'],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n "],
        ['Punctuation', ']'],
        ['Text', ' '],
        ['Comment', '#c']
    end

    it 'recognizes relaxed struct types' do
      assert_tokens_equal " type foo[A, B] #c\n [ #c\n f0 #c\n A #c\n f1 B #c\n f2 int8 #c\n ] [\nvarlen\n] #c",
        ['Text', ' '],
        ['Keyword', 'type'],
        ['Text', ' '],
        ['Name', 'foo'],
        ['Punctuation', '['],
        ['Name', 'A'],
        ['Punctuation', ','],
        ['Text', ' '],
        ['Name', 'B'],
        ['Punctuation', ']'],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n "],
        ['Punctuation', '['],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n "],
        ['Name', 'f0'],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n "],
        ['Name', 'A'],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n "],
        ['Name', 'f1'],
        ['Text', ' '],
        ['Name', 'B'],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n "],
        ['Name', 'f2'],
        ['Text', ' '],
        ['Keyword.Type', 'int8'],
        ['Text', ' '],
        ['Comment', '#c'],
        ['Text', "\n "],
        ['Punctuation', ']'],
        ['Text', ' '],
        ['Punctuation', '['],
        ['Text', "\n"],
        ['Keyword', 'varlen'],
        ['Text', "\n"],
        ['Punctuation', ']'],
        ['Text', ' '],
        ['Comment', '#c']
    end

  end
end
