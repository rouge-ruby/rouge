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
  end
end
