# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Ada do
  let(:subject) { Rouge::Lexers::Ada.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.ada'
      assert_guess :filename => 'foo.adb'
      assert_guess :filename => 'foo.ads'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-ada'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'classifies identifiers' do
      assert_tokens_equal 'constant Boolean := A and B',
                           ['Keyword', 'constant'],
                           ['Text', ' '],
                           ['Name.Builtin', 'Boolean'],
                           ['Text', ' '],
                           ['Operator', ':='],
                           ['Text', ' '],
                           ['Name', 'A'],
                           ['Text', ' '],
                           ['Operator.Word', 'and'],
                           ['Text', ' '],
                           ['Name', 'B']
    end

    it 'accepts Unicode identifiers' do
      assert_tokens_equal '東京', ['Name', '東京']
      assert_tokens_equal '０東京', ['Error', '０'], ['Name', '東京']
      assert_tokens_equal '東京０', ['Name', '東京０']
    end

    it 'rejects identifiers with double or trailing underscores' do
      assert_tokens_equal '_ab', ['Error', '_ab']
      assert_tokens_equal 'a__b', ['Error', 'a__b']
      assert_tokens_equal 'a_b', ['Name', 'a_b']
      assert_tokens_equal 'ab_', ['Error', 'ab_']
    end

    it 'understands other connecting punctuation' do
      assert_tokens_equal 'a﹏b', ['Name', 'a﹏b']
      assert_tokens_equal '﹏ab', ['Error', '﹏ab']
      assert_tokens_equal 'a﹏﹏b', ['Error', 'a﹏﹏b']
      assert_tokens_equal 'ab﹏', ['Error', 'ab﹏']
    end

    it 'classifies based number literals' do
      assert_tokens_equal '2#0001_1110#', ['Literal.Number.Bin', '2#0001_1110#']
      assert_tokens_equal '2#0001__1110#', ['Error', '2#0001__1110#']
      assert_tokens_equal '8#1234_0000#', ['Literal.Number.Oct', '8#1234_0000#']
      assert_tokens_equal '16#abc_BBB_12#', ['Literal.Number.Hex', '16#abc_BBB_12#']
      assert_tokens_equal '4#1230000#e+5', ['Literal.Number.Integer', '4#1230000#e+5']
      assert_tokens_equal '2#0001_1110#e3', ['Literal.Number.Bin', '2#0001_1110#e3']

      assert_tokens_equal '16#abc_BBB.12#', ['Literal.Number.Float', '16#abc_BBB.12#']
    end

    it 'recognizes exponents in integers and reals' do
      assert_tokens_equal '1e6', ['Literal.Number.Integer', '1e6']
      assert_tokens_equal '123_456', ['Literal.Number.Integer', '123_456']
      assert_tokens_equal '3.14159_26', ['Literal.Number.Float', '3.14159_26']
      assert_tokens_equal '3.141_592e-20', ['Literal.Number.Float', '3.141_592e-20']
    end

    it 'highlights escape sequences inside doubly quoted strings' do
      assert_tokens_equal '"Archimedes said ""Εύρηκα"""',
                          ['Literal.String.Double', '"Archimedes said '],
                          ['Literal.String.Escape', '""'],
                          ['Literal.String.Double', 'Εύρηκα'],
                          ['Literal.String.Escape', '""'],
                          ['Literal.String.Double', '"']
    end

    it 'marks function names in declarations' do
      assert_tokens_equal 'Entry Foo IS',
                          ['Keyword.Declaration', 'Entry'],
                          ['Text', ' '],
                          ['Name.Function', 'Foo'],
                          ['Text', ' '],
                          ['Keyword', 'IS']

      assert_tokens_equal 'package body Ada.Foo IS',
                          ['Keyword.Declaration', 'package'],
                          ['Text', ' '],
                          ['Keyword.Declaration', 'body'],
                          ['Text', ' '],
                          ['Name.Namespace', 'Ada'],
                          ['Punctuation', '.'],
                          ['Name.Function', 'Foo'],
                          ['Text', ' '],
                          ['Keyword', 'IS']
    end

    it 'allows both names and builtin names in context clauses' do
      assert_tokens_equal 'limited with Math.Integer;',
                          ['Keyword.Namespace', 'limited'],
                          ['Text', ' '],
                          ['Keyword.Namespace', 'with'],
                          ['Text', ' '],
                          ['Name.Namespace', 'Math'],
                          ['Punctuation', '.'],
                          ['Name.Namespace', 'Integer'],
                          ['Punctuation', ';']
    end

    it 'recovers quickly after mistakenly entering :libunit_name' do
      # A `with` keyword at the beginning of a line is 99.9% sure to be
      # a context clause, but there are things that could be mistaken if
      # they are indented strangely:
      #
      # generic
      #    with function Random return Integer is <>;
      # procedure Foo;
      #
      # If that `with` is not indented, we should recover immediately:
      assert_tokens_equal 'with function Random',
                          ['Keyword.Namespace', 'with'],
                          ['Text', ' '],
                          ['Keyword.Declaration', 'function'],
                          ['Text', ' '],
                          ['Name.Function', 'Random']

      # Another case that's even less likely to be at BOL:
      #
      # type Painted_Point is new Point with
      #    record
      #       Paint : Color := White;
      #    end record;
      #
      # type Addition is new Binary_Operation with null record;
      assert_tokens_equal 'with record Paint',
                          ['Keyword.Namespace', 'with'],
                          ['Text', ' '],
                          ['Keyword', 'record'],
                          ['Text', ' '],
                          ['Name', 'Paint']
      assert_tokens_equal 'with null record;',
                          ['Keyword.Namespace', 'with'],
                          ['Text', ' '],
                          ['Keyword', 'null'],
                          ['Text', ' '],
                          ['Keyword', 'record'],
                          ['Punctuation', ';']

      # Finally: raise Runtime_Error with "NO!"
      assert_tokens_equal 'with "NO!"',
                          ['Keyword.Namespace', 'with'],
                          ['Text', ' '],
                          ['Literal.String.Double', '"NO!"']
    end
  end
end
