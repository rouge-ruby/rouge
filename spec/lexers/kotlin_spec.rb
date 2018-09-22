# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Kotlin do
  let(:subject) { Rouge::Lexers::Kotlin.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.kt'
      assert_guess :filename => 'foo.kts'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-kotlin'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'recognizes one-line comments not followed by a newline (#797)' do
      assert_tokens_equal '// comment', ['Comment.Single', '// comment']
    end

    describe 'functions' do

      it 'recognizes function' do
        assert_tokens_equal 'fun makeField()',
          ['Keyword', 'fun'],
          ['Text', " "],
          ['Name.Function', 'makeField'],
          ['Punctuation', '()']
      end

      it 'recognizes backticked function' do
        assert_tokens_equal 'fun `makeField`()',
          ['Keyword', 'fun'],
          ['Text', " "],
          ['Name.Function', '`makeField`'],
          ['Punctuation', '()']
      end

      it 'recognizes extension function' do
        assert_tokens_equal 'fun String.makeField()',
          ['Keyword', 'fun'],
          ['Text', " "],
          ['Name.Class', 'String'],
          ['Punctuation', '.'],
          ['Name.Function', 'makeField'],
          ['Punctuation', '()']
      end

      it 'recognizes backticked extension function' do
        assert_tokens_equal 'fun `String`.`makeField`()',
          ['Keyword', 'fun'],
          ['Text', " "],
          ['Name.Class', '`String`'],
          ['Punctuation', '.'],
          ['Name.Function', '`makeField`'],
          ['Punctuation', '()']
      end

      it 'recognizes generic function' do
        assert_tokens_equal 'fun <T, ClassT> makeField()',
          ['Keyword', 'fun'],
          ['Text', " "],
          ['Punctuation', '<'],
          ['Name.Class', 'T'],
          ['Punctuation', ','],
          ['Text', " "],
          ['Name.Class', 'ClassT'],
          ['Punctuation', '>'],
          ['Text', " "],
          ['Name.Function', 'makeField'],
          ['Punctuation', '()']
      end

      it 'recognizes generic extension function' do
        assert_tokens_equal 'fun <T, ClassT> String.makeField()',
          ['Keyword', 'fun'],
          ['Text', " "],
          ['Punctuation', '<'],
          ['Name.Class', 'T'],
          ['Punctuation', ','],
          ['Text', " "],
          ['Name.Class', 'ClassT'],
          ['Punctuation', '>'],
          ['Text', " "],
          ['Name.Class', 'String'],
          ['Punctuation', '.'],
          ['Name.Function', 'makeField'],
          ['Punctuation', '()']
      end

      it 'recognizes function parameters' do
        assert_tokens_equal 'fun makeField(thing: Int, other: String)',
          ['Keyword', 'fun'],
          ['Text', " "],
          ['Name.Function', 'makeField'],
          ['Punctuation', '('],
          ['Name.Variable', 'thing'],
          ['Punctuation', ':'],
          ['Text', " "],
          ['Name.Class', 'Int'],
          ['Punctuation', ','],
          ['Text', " "],
          ['Name.Variable', 'other'],
          ['Punctuation', ':'],
          ['Text', " "],
          ['Name.Class', 'String'],
          ['Punctuation', ')']
      end

      it 'recognizes function with a generic parameter' do
        assert_tokens_equal 'fun makeField(thing: Array<String>)',
          ['Keyword', 'fun'],
          ['Text', " "],
          ['Name.Function', 'makeField'],
          ['Punctuation', '('],
          ['Name.Variable', 'thing'],
          ['Punctuation', ':'],
          ['Text', " "],
          ['Name.Class', 'Array'],
          ['Punctuation', '<'],
          ['Name.Class', "String"],
          ['Punctuation', '>)']
      end

      it 'recognizes function return type' do
        assert_tokens_equal 'fun makeField(): String',
          ['Keyword', 'fun'],
          ['Text', " "],
          ['Name.Function', 'makeField'],
          ['Punctuation', '():'],
          ['Text', " "],
          ['Name.Class', 'String']
      end

      it 'recognizes function return generic type' do
        assert_tokens_equal 'fun makeField(): Array<String>',
          ['Keyword', 'fun'],
          ['Text', " "],
          ['Name.Function', 'makeField'],
          ['Punctuation', '():'],
          ['Text', " "],
          ['Name.Class', 'Array'],
          ['Punctuation', '<'],
          ['Name.Class', 'String'],
          ['Punctuation', '>']
      end

    end
  end
end
