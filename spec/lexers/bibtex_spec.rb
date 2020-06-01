# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::BibTeX do
  let(:subject) { Rouge::Lexers::BibTeX.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.bib'
    end
  end
end

