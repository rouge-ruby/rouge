# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Picat do
  let(:subject) { Rouge::Lexers::Picat.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.pi'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-picat'
    end
  end
end
