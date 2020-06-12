# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Brightscript do
  let(:subject) { Rouge::Lexers::Brightscript.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.brs'
    end
  end
end
