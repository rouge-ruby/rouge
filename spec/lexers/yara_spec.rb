# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::YARA do
  let(:subject) { Rouge::Lexers::YARA.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.yar'
      assert_guess :filename => 'foo.yara'
    end
  end
end
