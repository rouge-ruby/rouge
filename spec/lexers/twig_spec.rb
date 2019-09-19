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
end
