# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Slim do
  let(:subject) { Rouge::Lexers::Slim.new }
  include Support::Lexing

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.slim'
    end
  end

  describe 'regression: lexing heredocs' do
    it 'doesn\'t throw an error' do
      subject.lex('-<<x').to_a
    end
  end

  describe 'multi line ruby code' do
    it 'handles comma at the end of the line' do
      assert_tokens_equal "= puts 1,\n2",
        ['Punctuation', '='],
        ['Text', ' '],
        ['Name.Builtin', 'puts'],
        ['Text', ' '],
        ['Literal.Number.Integer', '1'],
        ['Punctuation', ","],
        ['Text', "\n"],
        ['Literal.Number.Integer', '2']
    end

    it 'handles backslash at the end of the line' do
      assert_tokens_equal "= puts \\\n1",
        ['Punctuation', '='],
        ['Text', ' '],
        ['Name.Builtin', 'puts'],
        ['Text', ' '],
        ['Punctuation', "\\"],
        ['Text', "\n"],
        ['Literal.Number.Integer', '1']
    end
  end
end
