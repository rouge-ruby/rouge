# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::ConsoleLexer do
  let(:subject) { Rouge::Lexers::ConsoleLexer.new }
  let(:klass) { Rouge::Lexers::ConsoleLexer }

  include Support::Lexing
  
  it 'parses a basic prompt' do
    assert_tokens_equal '$ foo',
      ['Generic.Prompt', '$'],
      ['Text.Whitespace', ' '],
      ['Text', 'foo']
  end

  it 'parses a custom prompt' do
    subject_with_options = klass.new({ prompt: '%' })
    assert_tokens_equal '% foo', subject_with_options,
      ['Generic.Prompt', '%'],
      ['Text.Whitespace', ' '],
      ['Text', 'foo']
  end

  it 'does not crash if argument ends with backslash' do
    assert_tokens_equal '$ cd application\\bin\\',
      ['Generic.Prompt', '$'],
      ['Text.Whitespace', ' '],
      ['Name.Builtin', 'cd '],
      ['Text', 'application'],
      ['Literal.String.Escape', '\\b'],
      ['Keyword', 'in'],
      ['Literal.String.Escape', '\\']
  end

  it 'parses a custom error' do
    subject_with_options = klass.new({ error: 'No command,Unhandled' })
    assert_tokens_equal 'No command \'foo\' found, did you mean:', subject_with_options,
      ['Generic.Error', 'No command \'foo\' found, did you mean:']
    assert_tokens_equal 'Unhandled condition in test.lisp', subject_with_options,
      ['Generic.Error', 'Unhandled condition in test.lisp']
    assert_tokens_equal 'foo', subject_with_options,
      ['Generic.Output', 'foo']
  end

  it 'parses single-line comments' do
    subject_with_options = klass.new({ comments: true })
    assert_tokens_equal '# this is a comment', subject_with_options,
      ['Comment', '# this is a comment']
  end

  it 'ignores single-line comments' do
    assert_tokens_equal '# this is not a comment',
      ['Generic.Prompt', '#'],
      ['Text.Whitespace', ' '],
      ['Text', 'this is not a comment']
  end

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.cap'
    end
  end
end
