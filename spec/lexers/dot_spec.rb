# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Dot do
  let(:subject) { Rouge::Lexers::Dot.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.dot'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/vnd.graphviz'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'recognizes one-line "//" comments not followed by a newline' do
      assert_tokens_equal '// comment', ['Comment.Single', '// comment']
    end

    it 'recognizes one-line "#" comments not followed by a newline' do
      assert_tokens_equal '# comment', ['Comment.Single', '# comment']
    end
  end
end
