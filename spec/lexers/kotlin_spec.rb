# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Kotlin do
  let(:subject) { Rouge::Lexers::Kotlin.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.kt'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-kotlin'
    end

    it 'parses functions ok' do
      tokens = subject.lex('fun myFunction()').to_a
      assert { tokens[0][0] == Token['Keyword'] }
      assert { tokens[1][0] == Token['Text'] }
      assert { tokens[2][0] == Token['Name.Function'] }
    end

    it 'parses extension functions ok' do
      tokens = subject.lex('fun String.extensionFunction()').to_a
      assert { tokens[0][0] == Token['Keyword'] }
      assert { tokens[1][0] == Token['Text'] }
      assert { tokens[2][0] == Token['Punctuation'] }
      assert { tokens[3][0] == Token['Name.Function'] }
    end

    it 'parses generic functions ok' do
      tokens = subject.lex('fun <T> myFunction()').to_a
      assert { tokens[0][0] == Token['Keyword'] }
      assert { tokens[1][0] == Token['Text'] }
      assert { tokens[2][0] == Token['Punctuation'] }
      assert { tokens[3][0] == Token['Text'] }
      assert { tokens[4][0] == Token['Punctuation'] }
      assert { tokens[5][0] == Token['Text'] }
      assert { tokens[6][0] == Token['Name.Function'] }
    end

    it 'parses generic extension functions ok' do
      tokens = subject.lex('fun <T> String.myFunction()').to_a
      assert { tokens[0][0] == Token['Keyword'] }
      assert { tokens[1][0] == Token['Text'] }
      assert { tokens[2][0] == Token['Punctuation'] }
      assert { tokens[3][0] == Token['Text'] }
      assert { tokens[4][0] == Token['Punctuation'] }
      assert { tokens[5][0] == Token['Text'] }
      assert { tokens[6][0] == Token['Punctuation'] }
      assert { tokens[7][0] == Token['Name.Function'] }
    end

  end
end
