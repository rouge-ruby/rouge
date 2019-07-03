# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::BIML do
  let(:subject) { Rouge::Lexers::BIML.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.biml'
    end

    it 'guesses by source' do
      assert_guess :source => '<Biml></Biml>'
    end
  end
end
