# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Isabelle do
  let(:subject) { Rouge::Lexers::Isabelle.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.thy'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-isabelle'
    end
  end
end
