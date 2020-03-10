# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::TTCN3 do
  let(:subject) { Rouge::Lexers::TTCN3.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.ttcn'
      assert_guess :filename => 'foo.ttcn3'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-ttcn'
      assert_guess :mimetype => 'text/x-ttcn3'
    end
  end
end
