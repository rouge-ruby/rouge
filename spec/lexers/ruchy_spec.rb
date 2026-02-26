# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Ruchy do
  let(:subject) { Rouge::Lexers::Ruchy.new }

  describe 'lexing' do
    include Support::Lexing

    describe 'basic syntax' do
      it 'handles function definitions' do
        assert_tokens_equal "fn main() {\n  println!(\"Hello, world!\");\n}",
          ['Keyword', 'fn'],
          ['Text', ' '],
          ['Name.Function', 'main'],
          ['Punctuation', '()'],
          ['Text', ' '],
          ['Punctuation', '{'],
          ['Text', "\n  "],
          ['Name.Function', 'println!'],
          ['Punctuation', '('],
          ['Literal.String.Double', '"Hello, world!"'],
          ['Punctuation', ')'],
          ['Punctuation', ';'],
          ['Text', "\n"],
          ['Punctuation', '}']
      end

      it 'handles actor definitions' do
        assert_tokens_equal "actor Counter {\n  let mut count: i32 = 0;\n}",
          ['Keyword', 'actor'],
          ['Text', ' '],
          ['Name.Class', 'Counter'],
          ['Text', ' '],
          ['Punctuation', '{'],
          ['Text', "\n  "],
          ['Keyword', 'let'],
          ['Text', ' '],
          ['Keyword', 'mut'],
          ['Text', ' '],
          ['Name.Variable', 'count'],
          ['Punctuation', ':'],
          ['Text', ' '],
          ['Keyword.Type', 'i32'],
          ['Text', ' '],
          ['Operator', '='],
          ['Text', ' '],
          ['Literal.Number.Integer', '0'],
          ['Punctuation', ';'],
          ['Text', "\n"],
          ['Punctuation', '}']
      end

      it 'handles pipeline operator' do
        assert_tokens_equal "data >> process >> output",
          ['Name', 'data'],
          ['Text', ' '],
          ['Operator', '>>'],
          ['Text', ' '],
          ['Name', 'process'],
          ['Text', ' '],
          ['Operator', '>>'],
          ['Text', ' '],
          ['Name', 'output']
      end

      it 'handles actor send operator' do
        assert_tokens_equal "counter <- Increment(5)",
          ['Name', 'counter'],
          ['Text', ' '],
          ['Operator', '<-'],
          ['Text', ' '],
          ['Name.Function', 'Increment'],
          ['Punctuation', '('],
          ['Literal.Number.Integer', '5'],
          ['Punctuation', ')']
      end
    end

    describe 'comments' do
      it 'handles line comments' do
        assert_tokens_equal "// This is a comment\nlet x = 5;",
          ['Comment.Single', '// This is a comment'],
          ['Text', "\n"],
          ['Keyword', 'let'],
          ['Text', ' '],
          ['Name.Variable', 'x'],
          ['Text', ' '],
          ['Operator', '='],
          ['Text', ' '],
          ['Literal.Number.Integer', '5'],
          ['Punctuation', ';']
      end

      it 'handles block comments' do
        assert_tokens_equal "/* Multi\n   line\n   comment */",
          ['Comment.Multiline', "/* Multi\n   line\n   comment */"]
      end
    end
  end

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'test.rhy'
      assert_guess :filename => 'test.ruchy'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-ruchy'
    end

    it 'guesses by source' do
      assert_guess :source => 'actor Main {'
      assert_guess :source => 'fn main() {'
      assert_guess :source => 'data >> process'
    end
  end
end