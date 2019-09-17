# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::CSVS do
  let(:subject) { Rouge::Lexers::CSVS.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.csvs'
    end
  end
end
