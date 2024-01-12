# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::BitBake do
  let(:subject) { Rouge::Lexers::BitBake.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'recipe.bb'
      assert_guess :filename => 'recipe.bbclass'
      assert_guess :filename => 'recipe.bbappend'
    end
  end
end
