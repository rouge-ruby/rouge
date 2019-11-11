# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::NesAsm do
  let(:subject) { Rouge::Lexers::NesAsm.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.nesasm'
    end
  end
end
