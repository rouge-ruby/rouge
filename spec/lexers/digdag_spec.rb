# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Digdag do
  let(:subject) { Rouge::Lexers::Digdag.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.dig'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'application/x-digdag'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'recognizes one line comment on last line even when not terminated by a new line (#360)' do
      assert_tokens_equal "+step1:\n  echo> Hello!\n",
        ["Literal.String", "+step1"],
        ["Punctuation.Indicator", ":"],
        ["Text", "\n  "],
        ["Literal.String", "echo> Hello!"],
        ["Text", "\n"]
    end
  end
end
