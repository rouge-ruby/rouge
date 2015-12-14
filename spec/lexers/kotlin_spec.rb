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
  end
end
