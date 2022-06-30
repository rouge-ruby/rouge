# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Lean do
  let(:subject) { Rouge::Lexers::Lean.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'file.lean'
    end

  end
end
