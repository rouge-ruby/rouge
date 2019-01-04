# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::ArmAsm do
  let(:subject) { Rouge::Lexers::ArmAsm.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.s'
    end
  end
end
