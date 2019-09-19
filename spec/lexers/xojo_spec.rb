# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Xojo do
  let(:subject) { Rouge::Lexers::Xojo.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.xojo_code'
      assert_guess :filename => 'foo.xojo_window'
      assert_guess :filename => 'foo.xojo_toolbar'
      assert_guess :filename => 'foo.xojo_menu'
    end

  end
end
