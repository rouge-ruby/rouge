# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::HOCON do
  let(:subject) { Rouge::Lexers::HOCON.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'application.hocon'
    end
  end
end
