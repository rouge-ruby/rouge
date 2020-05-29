# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Augeas do
  let(:subject) { Rouge::Lexers::Augeas.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'file.aug'
    end
  end
end

