# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Tauraro do
  let(:subject) { Rouge::Lexers::Tauraro.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'hello.tr'
      assert_guess :filename => 'main.tau'
      assert_guess :filename => 'app.tauraro'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-tauraro'
      assert_guess :mimetype => 'application/x-tauraro'
    end

    it 'guesses by shebang' do
      assert_guess :source => '#!/usr/bin/env tauraro'
    end

    it 'guesses by hausa keyword presence' do
      assert_guess :source => 'aiki gaishe(suna: str):'
      assert_guess :source => 'idan x > 0:'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    # --- Comments ---

    it 'highlights line comments' do
      assert_tokens_equal '# this is a comment',
        ['Comment.Single', '# this is a comment']
    end

    it 'highlights inline comments' do
      assert_tokens_equal 'x = 1 # set x',
        ['Name', 'x'],
        ['Text.Whitespace', ' '],
        ['Operator', '='],
        ['Text.Whitespace', ' '],
        ['Literal.Number.Integer', '1'],
        ['Text.Whitespace', ' '],
        ['Comment.Single', '# set x']
    end

    it 'highlights docstrings' do
      assert_tokens_equal '"""This is a docstring."""',
        ['Literal.String.Doc', '"""'],
        ['Literal.String.Doc', 'This is a docstring.'],
        ['Literal.String.Doc', '"""']
    end

    # --- English Keywords ---

    it 'highlights declaration keywords' do
      %w[def class struct interface enum extend lambda].each do |kw|
        assert_tokens_equal kw, ['Keyword.Declaration', kw]
      end
    end

    it 'highlights control flow keywords' do
      %w[if elif else for while return break continue pass match case].each do |kw|
        assert_tokens_equal kw, ['Keyword', kw]
      end
    end

    it 'highlights exception keywords' do
      %w[try except finally raise with assert].each do |kw|
        assert_tokens_equal kw, ['Keyword', kw]
      end
    end

    it 'highlights async keywords' do
      %w[async await spawn yield].each do |kw|
        assert_tokens_equal kw, ['Keyword', kw]
      end
    end

    it 'highlights modifier keywords' do
      %w[pub mut static const abstract virtual override unsafe let].each do |kw|
        assert_tokens_equal kw, ['Keyword.Declaration', kw]
      end
    end

    it 'highlights operator word keywords' do
      %w[and or not in is as].each do |kw|
        assert_tokens_equal kw, ['Operator.Word', kw]
      end
    end

    # --- Hausa Keywords ---

    it 'highlights Hausa declaration keywords' do
      %w[aiki aji tsari dan_aiki].each do |kw|
        assert_tokens_equal kw, ['Keyword.Reserved', kw]
      end
    end

    it 'highlights Hausa control flow keywords' do
      %w[idan koidan sai ga yayinda dawo tsaya ci_gaba wuce duba hali].each do |kw|
        assert_tokens_equal kw, ['Keyword.Reserved', kw]
      end
    end

    it 'highlights Hausa exception keywords' do
      %w[gwada kama karshe jefa tare tabbatar].each do |kw|
        assert_tokens_equal kw, ['Keyword.Reserved', kw]
      end
    end

    it 'highlights Hausa async keywords' do
      %w[ba_jira jira bayar].each do |kw|
        assert_tokens_equal kw, ['Keyword.Reserved', kw]
      end
    end

    it 'highlights Hausa import keywords' do
      %w[shigo daga kamar a_cikin fito].each do |kw|
        assert_tokens_equal kw, ['Keyword.Reserved', kw]
      end
    end

    it 'highlights Hausa operator words' do
      %w[da ko ba].each do |kw|
        assert_tokens_equal kw, ['Operator.Word', kw]
      end
    end

    # --- Constants ---

    it 'highlights English boolean and null constants' do
      %w[true false none null].each do |c|
        assert_tokens_equal c, ['Keyword.Constant', c]
      end
    end

    it 'highlights Hausa boolean and null constants' do
      assert_tokens_equal 'gaskiya', ['Keyword.Constant', 'gaskiya']
      assert_tokens_equal 'karya',   ['Keyword.Constant', 'karya']
      assert_tokens_equal 'babu',    ['Keyword.Constant', 'babu']
    end

    # --- self ---

    it 'highlights self as builtin pseudo' do
      assert_tokens_equal 'self', ['Name.Builtin.Pseudo', 'self']
    end

    # --- Built-in types ---

    it 'highlights primitive types' do
      %w[str int bool char void f32 f64].each do |t|
        assert_tokens_equal t, ['Name.Builtin.Type', t]
      end
    end

    it 'highlights integer types' do
      %w[i8 i16 i32 i64 i128 u8 u16 u32 u64 u128].each do |t|
        assert_tokens_equal t, ['Name.Builtin.Type', t]
      end
    end

    it 'highlights generic container types' do
      %w[List Dict Tuple Set Option Result Box Vec Map Pointer String Bytes Any Never Self].each do |t|
        assert_tokens_equal t, ['Name.Builtin.Type', t]
      end
    end

    # --- Built-in functions ---

    it 'highlights built-in functions' do
      %w[print buga len range input abs min max sum round isinstance type].each do |f|
        assert_tokens_equal f, ['Name.Builtin', f]
      end
    end

    # --- Built-in exceptions ---

    it 'highlights built-in exception types' do
      %w[Exception ValueError TypeError RuntimeError KeyError IndexError].each do |e|
        assert_tokens_equal e, ['Name.Exception', e]
      end
    end

    # --- Strings ---

    it 'highlights double-quoted strings' do
      assert_tokens_equal '"hello world"',
        ['Literal.String.Double', '"'],
        ['Literal.String.Double', 'hello world'],
        ['Literal.String.Double', '"']
    end

    it 'highlights single-quoted strings' do
      assert_tokens_equal "'hello'",
        ['Literal.String.Single', "'"],
        ['Literal.String.Single', 'hello'],
        ['Literal.String.Single', "'"]
    end

    it 'highlights escape sequences inside strings' do
      assert_tokens_equal '"line\\nbreak"',
        ['Literal.String.Double', '"'],
        ['Literal.String.Double', 'line'],
        ['Literal.String.Escape', '\\n'],
        ['Literal.String.Double', 'break'],
        ['Literal.String.Double', '"']
    end

    it 'highlights f-strings with interpolation' do
      assert_tokens_equal 'f"hello {name}"',
        ['Literal.String.Interpol', 'f"'],
        ['Literal.String.Interpol', 'hello '],
        ['Literal.String.Interpol', '{'],
        ['Name', 'name'],
        ['Literal.String.Interpol', '}'],
        ['Literal.String.Interpol', '"']
    end

    it 'highlights raw strings' do
      assert_tokens_equal 'r"raw\\nstring"',
        ['Literal.String.Other', 'r"'],
        ['Literal.String.Other', 'raw\\nstring'],
        ['Literal.String.Other', '"']
    end

    it 'highlights byte strings' do
      assert_tokens_equal 'b"bytes"',
        ['Literal.String.Other', 'b"'],
        ['Literal.String.Other', 'bytes'],
        ['Literal.String.Other', '"']
    end

    # --- Numbers ---

    it 'highlights integer literals' do
      assert_tokens_equal '42',    ['Literal.Number.Integer', '42']
      assert_tokens_equal '1_000', ['Literal.Number.Integer', '1_000']
    end

    it 'highlights typed integer literals' do
      assert_tokens_equal '42i32', ['Literal.Number.Integer', '42i32']
      assert_tokens_equal '255u8', ['Literal.Number.Integer', '255u8']
    end

    it 'highlights float literals' do
      assert_tokens_equal '3.14',    ['Literal.Number.Float', '3.14']
      assert_tokens_equal '2.5e10',  ['Literal.Number.Float', '2.5e10']
      assert_tokens_equal '1.0f64',  ['Literal.Number.Float', '1.0f64']
    end

    it 'highlights hexadecimal literals' do
      assert_tokens_equal '0xFF',   ['Literal.Number.Hex', '0xFF']
      assert_tokens_equal '0xDEAD', ['Literal.Number.Hex', '0xDEAD']
    end

    it 'highlights binary literals' do
      assert_tokens_equal '0b1010', ['Literal.Number.Bin', '0b1010']
      assert_tokens_equal '0b1111_0000', ['Literal.Number.Bin', '0b1111_0000']
    end

    it 'highlights octal literals' do
      assert_tokens_equal '0o777', ['Literal.Number.Oct', '0o777']
    end

    # --- Decorators ---

    it 'highlights decorators' do
      assert_tokens_equal '@cached',
        ['Name.Decorator', '@cached']
    end

    it 'highlights dotted decorators' do
      assert_tokens_equal '@std.cached',
        ['Name.Decorator', '@std.cached']
    end

    # --- Operators ---

    it 'highlights arrow operator' do
      assert_tokens_equal '->', ['Operator', '->']
    end

    it 'highlights fat arrow' do
      assert_tokens_equal '=>', ['Operator', '=>']
    end

    it 'highlights comparison operators' do
      %w[== != <= >=].each do |op|
        assert_tokens_equal op, ['Operator', op]
      end
    end

    it 'highlights arithmetic operators' do
      %w[+ - * / % **].each do |op|
        assert_tokens_equal op, ['Operator', op]
      end
    end

    it 'highlights nullable operators' do
      assert_tokens_equal '??', ['Operator', '??']
      assert_tokens_equal '!!', ['Operator', '!!']
    end

    # --- Class names ---

    it 'highlights class names (PascalCase identifiers)' do
      assert_tokens_equal 'MyClass', ['Name.Class', 'MyClass']
      assert_tokens_equal 'JsonParser', ['Name.Class', 'JsonParser']
    end

    # --- Full snippets ---

    it 'highlights a function definition' do
      assert_tokens_equal "def greet(name: str) -> str:",
        ['Keyword.Declaration', 'def'],
        ['Text.Whitespace', ' '],
        ['Name', 'greet'],
        ['Punctuation', '('],
        ['Name', 'name'],
        ['Punctuation', ':'],
        ['Text.Whitespace', ' '],
        ['Name.Builtin.Type', 'str'],
        ['Punctuation', ')'],
        ['Text.Whitespace', ' '],
        ['Operator', '->'],
        ['Text.Whitespace', ' '],
        ['Name.Builtin.Type', 'str'],
        ['Punctuation', ':']
    end

    it 'highlights a Hausa function definition' do
      assert_tokens_equal "aiki gaishe(suna: str):",
        ['Keyword.Reserved', 'aiki'],
        ['Text.Whitespace', ' '],
        ['Name', 'gaishe'],
        ['Punctuation', '('],
        ['Name', 'suna'],
        ['Punctuation', ':'],
        ['Text.Whitespace', ' '],
        ['Name.Builtin.Type', 'str'],
        ['Punctuation', ')'],
        ['Punctuation', ':']
    end

    it 'highlights a class definition' do
      assert_tokens_equal "class Circle:",
        ['Keyword.Declaration', 'class'],
        ['Text.Whitespace', ' '],
        ['Name.Class', 'Circle'],
        ['Punctuation', ':']
    end

    it 'highlights an extern block' do
      assert_tokens_equal 'extern "C":',
        ['Keyword', 'extern'],
        ['Text.Whitespace', ' '],
        ['Literal.String.Double', '"'],
        ['Literal.String.Double', 'C'],
        ['Literal.String.Double', '"'],
        ['Punctuation', ':']
    end

    it 'highlights import statements' do
      assert_tokens_equal 'from std.io import File',
        ['Keyword', 'from'],
        ['Text.Whitespace', ' '],
        ['Name', 'std'],
        ['Punctuation', '.'],
        ['Name', 'io'],
        ['Text.Whitespace', ' '],
        ['Keyword', 'import'],
        ['Text.Whitespace', ' '],
        ['Name.Class', 'File']
    end

    it 'highlights Hausa import' do
      assert_tokens_equal 'daga std.io shigo File',
        ['Keyword.Reserved', 'daga'],
        ['Text.Whitespace', ' '],
        ['Name', 'std'],
        ['Punctuation', '.'],
        ['Name', 'io'],
        ['Text.Whitespace', ' '],
        ['Keyword.Reserved', 'shigo'],
        ['Text.Whitespace', ' '],
        ['Name.Class', 'File']
    end
  end
end
