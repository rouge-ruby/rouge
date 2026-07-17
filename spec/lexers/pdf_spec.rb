# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Pdf do
  let(:subject) { Rouge::Lexers::Pdf.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.pdf'
      assert_guess :filename => 'foo.fdf'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'application/pdf'
      assert_guess :mimetype => 'application/fdf'
    end

    it 'guesses by source' do
      assert_guess :source => '%PDF-1.6'
      assert_guess :source => '%PDF-2.0'
      assert_guess :source => '%PDF-0.3' # Fake PDF version
      assert_guess :source => '%PDF-6.8' # Fake PDF version
      assert_guess :source => '%FDF-1.2'
    end
  end

end
