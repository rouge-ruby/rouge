# -*- coding: utf-8 -*- #
# frozen_string_literal: true

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

    it 'recognizes label' do
      assert_tokens_equal 'label@', ["Name.Decorator", "label@"]
    end

    it 'recognizes label reference in break statement' do
      assert_tokens_equal 'break@label', ["Keyword", "break"], ["Name.Decorator", "@label"]
    end

    it 'recognizes type modifiers' do
      for modifer in ['reified', 'out', 'in'] do
        assert_tokens_equal "<#{modifer} T>", ["Punctuation", "<"], ["Keyword", modifer], ["Text", " "], ["Name.Class", "T"], ["Punctuation", ">"]
      end
    end
  end
end
