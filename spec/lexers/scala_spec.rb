# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Scala do
  let(:subject) { Rouge::Lexers::Scala.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.scala'
      assert_guess :filename => 'foo.sbt'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-scala'
      assert_guess :mimetype => 'application/x-scala'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'recognizes one-line comments not followed by a newline' do
      assert_tokens_equal '// comment', ['Comment.Single', '// comment']
    end
  end
end
