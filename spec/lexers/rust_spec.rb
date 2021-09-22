# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Rust do
  let(:subject) { Rouge::Lexers::Rust.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.rs'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-rust'
    end

    it 'guesses by source' do
      assert_guess :source => '#!/usr/bin/env rustc --jit'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'can lex integers' do
      assert_tokens_equal '123usize', ['Literal.Number.Integer', '123usize']
      assert_tokens_equal '1_2_3_isize', ['Literal.Number.Integer', '1_2_3_isize']
      assert_tokens_equal '30_000i128', ['Literal.Number.Integer', '30_000i128']
      assert_tokens_equal '0u128', ['Literal.Number.Integer', '0u128']
      assert_tokens_equal '0o5_0_0', ['Literal.Number.Integer', '0o5_0_0']
    end

    it 'is not confused by float edge cases' do
      assert_tokens_equal '0.1E4', ['Literal.Number.Float', '0.1E4']
      assert_tokens_equal '0._1',
        ["Literal.Number.Integer", "0"],
        ["Name.Property", "._1"]
      assert_tokens_equal '1.',
        ["Literal.Number.Float", "1."]
      assert_tokens_equal '102. ',
        ["Literal.Number.Float", "102."],
        ["Text", " "]
      assert_tokens_equal '5_000._',
        ["Literal.Number.Integer", "5_000"],
        ["Name.Property", "._"]
    end

    it 'can lex identifier edge cases' do
      assert_tokens_equal '_', ['Name', '_']
      assert_tokens_equal '_0', ["Name", "_0"]
      assert_tokens_equal 'garçon', ['Name', 'garçon']
      assert_tokens_equal 'Москва.東京', ["Name", "Москва"], ["Name.Property", ".東京"]
      assert_tokens_equal '東京', ["Name", "東京"]
    end

    it 'can lex (possibly raw) byte chars/strings' do
      assert_tokens_equal %q(b'1'),
        ['Literal.String.Char', %q(b'1')]
      assert_tokens_equal %q(b'\xff'),
        ['Literal.String.Char', %q(b'\xff')]
      assert_tokens_equal %q(b"abc\xffdef"),
        ['Literal.String', 'b"abc'],
        ['Literal.String.Escape', '\xff'],
        ['Literal.String', 'def"']
      # raw string: no escape
      assert_tokens_equal %q(br##"ab"c\xffd"#ef"##),
        ['Literal.String', %q(br##"ab"c\xffd"#ef"##)]
    end

    it 'can lex multiline and doc comments' do
      assert_tokens_equal "// single line",
        ['Comment.Single', '// single line']
      assert_tokens_equal "/// line-style docs (outer)",
        ['Comment.Doc', '/// line-style docs (outer)']
      assert_tokens_equal "//! line-style docs (inner)",
        ['Comment.Doc', '//! line-style docs (inner)']
      assert_tokens_equal "//// not a doc anymore",
        ['Comment.Single', '//// not a doc anymore']
      assert_tokens_equal "///! still doc (but not inner, not that we care)",
        ['Comment.Doc', '///! still doc (but not inner, not that we care)']
      assert_tokens_equal "////! plain again",
        ['Comment.Single', '////! plain again']
      assert_tokens_equal "1 /**/ 2",
        ['Literal.Number.Integer', '1'],
        ['Text', ' '],
        ['Comment.Multiline', '/**/'],
        ['Text', ' '],
        ['Literal.Number.Integer', '2']
      assert_tokens_equal "1 /***/ 2",
        ['Literal.Number.Integer', '1'],
        ['Text', ' '],
        ['Comment.Multiline', '/***/'],
        ['Text', ' '],
        ['Literal.Number.Integer', '2']
      assert_tokens_equal "/** outer docs */",
        ['Comment.Doc', '/** outer docs */']
      assert_tokens_equal "/*! inner docs */",
        ['Comment.Doc', '/*! inner docs */']
      assert_tokens_equal "/*** not docs */",
        ['Comment.Multiline', '/*** not docs */']
      assert_tokens_equal "1 /* /* /* nested */ */ */ 2",
        ['Literal.Number.Integer', '1'],
        ['Text', ' '],
        ['Comment.Multiline', '/* /* /* nested */ */ */'],
        ['Text', ' '],
        ['Literal.Number.Integer', '2']
      assert_tokens_equal "1 /** /* /* doc nested */ */ */ 2",
        ['Literal.Number.Integer', '1'],
        ['Text', ' '],
        ['Comment.Doc', '/** /* /* doc nested */ */ */'],
        ['Text', ' '],
        ['Literal.Number.Integer', '2']
      assert_tokens_equal "1 /* /** /* not doc, still nested */ */ */ 2",
        ['Literal.Number.Integer', '1'],
        ['Text', ' '],
        ['Comment.Multiline', '/* /** /* not doc, still nested */ */ */'],
        ['Text', ' '],
        ['Literal.Number.Integer', '2']
      assert_tokens_equal "/**/// this is still commented\n\"this is not\"",
        ['Comment.Multiline', '/**/'],
        ['Comment.Single', '// this is still commented'],
        ['Text', "\n"],
        ['Literal.String', '"this is not"']
      assert_tokens_equal '/* /*/ / * // */ */ "tricky"',
        ['Comment.Multiline', "/* /*/ / * // */ */"],
        ['Text', ' '],
        ['Literal.String', '"tricky"']
      assert_tokens_equal "/*! abcd /* ef */\n/**/ //! /***/ // */ \"uncommented\"",
        ['Comment.Doc', "/*! abcd /* ef */\n/**/ //! /***/ // */"],
        ['Text', ' '],
        ['Literal.String', '"uncommented"']
      assert_tokens_equal "8/**//4",
        ['Literal.Number.Integer', '8'],
        ['Comment.Multiline', "/**/"],
        ['Operator', '/'],
        ['Literal.Number.Integer', '4']
    end

    it 'can lex unicode escapes' do
      assert_tokens_equal %q("abc\u{0}def"),
        ['Literal.String', '"abc'],
        ['Literal.String.Escape', '\u{0}'],
        ['Literal.String', 'def"']
      assert_tokens_equal %q("abc\u{FDFD}def"),
        ['Literal.String', '"abc'],
        ['Literal.String.Escape', '\u{FDFD}'],
        ['Literal.String', 'def"']
      assert_tokens_equal %q('\u{10ffff}'),
        ['Literal.String.Char', %q('\u{10ffff}')]
      assert_tokens_equal %q('\u{f_f___f_f}'),
        ['Literal.String.Char', %q('\u{f_f___f_f}')]
    end
  end
end
