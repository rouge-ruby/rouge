# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Smalltalk do
  let(:subject) { Rouge::Lexers::Smalltalk.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.st', :source => ''
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-smalltalk'
    end
  end
end
