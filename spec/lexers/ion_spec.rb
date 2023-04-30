# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Ion do
  let(:subject) { Rouge::Lexers::Ion.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'file.ion'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'application/ion'
    end
  end
end
