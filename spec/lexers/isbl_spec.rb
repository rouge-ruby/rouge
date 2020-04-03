# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::ISBL do
  let(:subject) { Rouge::Lexers::ISBL.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.isbl'
    end
  end
end
