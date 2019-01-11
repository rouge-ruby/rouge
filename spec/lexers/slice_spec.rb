# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Slice do
  let(:subject) { Rouge::Lexers::Slice.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.ice'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/slice'
    end
  end
end
