# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Dylan do
  let(:subject) { Rouge::Lexers::Dylan.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'myfile.dylan'
    end
  end
end
