# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Twig do
  let(:subject) { Rouge::Lexers::Twig.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by mimetype' do
      assert_guess mimetype: 'application/x-twig'
      assert_guess mimetype: 'text/html+twig'
    end
  end

  describe 'regression: PR #1949' do
    it 'has different keyword set than its superclass' do
      refute_equal Rouge::Lexers::Twig.keywords, Rouge::Lexers::Jinja.keywords
    end

    it 'has different operator set than its superclass' do
      refute_equal Rouge::Lexers::Twig.word_operators, Rouge::Lexers::Jinja.word_operators
    end
  end
end
