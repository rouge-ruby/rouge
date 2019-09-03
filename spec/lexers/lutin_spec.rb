# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Lutin do
  let(:subject) { Rouge::Lexers::Lutin.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.lut'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-lutin'
    end
  end
end
