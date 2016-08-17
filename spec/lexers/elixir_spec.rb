# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Elixir do
  let(:subject) { Rouge::Lexers::Elixir.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.ex'
      assert_guess :filename => 'foo.exs'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-elixir'
      assert_guess :mimetype => 'application/x-elixir'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'lexes double colon as punctuation' do
      assert_tokens_equal 'Elixir::Builtin',
        ['Name.Constant', 'Elixir'],
        ['Punctuation',   '::'],
        ['Name.Constant', 'Builtin']
    end

    it 'lexes keywords without following whitespaces' do
      assert_tokens_equal %{cond do\nend},
        ['Keyword', 'cond'],
        ['Text',    ' '],
        ['Keyword', 'do'],
        ['Text',    "\n"],
        ['Keyword', 'end']
    end

    it 'lexes bitwise operators' do
      assert_tokens_equal %{~~~1\n2&&&3},
        ['Operator', '~~~'],
        ['Literal.Number', '1'],
        ['Text', "\n"],
        ['Literal.Number', '2'],
        ['Operator', '&&&'],
        ['Literal.Number', '3']
    end

    it 'lexes structs' do
      assert_tokens_equal %{%Struct{}},
        ['Punctuation', '%'],
        ['Name.Constant', 'Struct'],
        ['Punctuation', '{}']
    end

    it 'lexes map' do
      assert_tokens_equal %{%{key: 1}},
        ['Punctuation', '%{'],
        ['Literal.String.Symbol', 'key:'],
        ['Text', ' '],
        ['Literal.Number', '1'],
        ['Punctuation', '}']
    end

    it 'lexes regexp sigils' do
      %w(() [] <> '' "" || //).each do |pair|
        l, r = pair[0], pair[1]
        assert_tokens_equal %{~r#{l}#{r}},
          ['Literal.String.Regex', "~r#{l}#{r}"]

        assert_tokens_equal %{~r#{l}#{r}gif},
          ['Literal.String.Regex', "~r#{l}#{r}gif"]

        assert_tokens_equal %{~r#{l}abc+foo#{r}rsx},
          ['Literal.String.Regex', "~r#{l}abc+foo#{r}rsx"]

        assert_tokens_equal %{~r//p}, # Wrong regex modifier gets turned into a Name
          ['Literal.String.Regex', '~r//'],
          ['Name', 'p']
      end
    end

    it 'lexes regexp sigil avoiding greedy errors' do
      text = 'string |> String.split(~r/[ -]/) |> Enum.map(&abbreviate_word/1) |> Enum.join()'
      
      assert_tokens_equal text,
        ['Name', 'string'],
        ['Text', ' '],
        ['Operator', '|>'],
        ['Text', ' '],
        ['Name.Constant', 'String'],
        ['Operator', '.'],
        ['Name', 'split'],
        ['Punctuation', '('],
        ['Literal.String.Regex', '~r/[ -]/'],
        ['Punctuation', ')'],
        ['Text', ' '],
        ['Operator', '|>'],
        ['Text', ' '],
        ['Name.Constant', 'Enum'],
        ['Operator', '.'],
        ['Name', 'map'],
        ['Punctuation', '('],
        ['Operator', '&'],
        ['Name', 'abbreviate_word'],
        ['Operator', '/'],
        ['Literal.Number', '1'],
        ['Punctuation', ')'],
        ['Text', ' '],
        ['Operator', '|>'],
        ['Text', ' '],
        ['Name.Constant', 'Enum'],
        ['Operator', '.'],
        ['Name', 'join'],
        ['Punctuation', '()']

    end

    it 'lexes other sigils' do
      %w(() [] <> '' "" || //).each do |pair|
        l, r = pair[0], pair[1]
        assert_tokens_equal %{~c#{l}#{r}},
          ['Literal.String.Other', "~c#{l}#{r}"]

        assert_tokens_equal %{~s#{l}ABC#{r}},
          ['Literal.String.Other', "~s#{l}ABC#{r}"]


        assert_tokens_equal %{~w#{l}lorem ipsum dolor#{r}s},
          ['Literal.String.Other', "~w#{l}lorem ipsum dolor#{r}s"]

        assert_tokens_equal %{~S#{l}#\{inter <> "polation"\}#{r}},
          ['Literal.String.Other', "~S#{l}"],
          ['Literal.String.Interpol', '#{'],
          ['Name', 'inter'],
          ['Text', ' '],
          ['Operator', '<>'],
          ['Text', ' '],
          ['Literal.String.Doc', '"'],
          ['Literal.String.Double', 'polation"'],
          ['Literal.String.Interpol', '}'],
          ['Literal.String.Other', r]
      end

    end

    it 'lexes & operator' do
      assert_tokens_equal %{&(&1)},
        ['Operator', '&'],
        ['Punctuation', '('],
        ['Name.Variable', '&1'],
        ['Punctuation', ')']

    end
  end
end
