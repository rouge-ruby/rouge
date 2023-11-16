# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::ArmAsm do
  let(:subject) { Rouge::Lexers::ArmAsm.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename and source hint' do
      assert_guess :filename => 'foo.s', :source => 'Func MOVW    r0, #RetVal'
    end
  end
end
