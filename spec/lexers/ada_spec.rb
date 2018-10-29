# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Ada do
  let(:subject) { Rouge::Lexers::Ada.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.adb'
      assert_guess :filename => 'foo.ads'
      assert_guess :filename => 'foo.gpr'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-adasrc'
    end
  end
end
