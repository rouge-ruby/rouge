# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::HLSL do
  let(:subject) { Rouge::Lexers::HLSL.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.hlsl'
      assert_guess :filename => 'foo.hlsli'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-hlsl'
    end
  end
end
