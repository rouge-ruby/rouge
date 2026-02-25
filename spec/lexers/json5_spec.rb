# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::JSON5 do
  let(:subject) { Rouge::Lexers::JSON5.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.json5'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'application/json5'
    end
  end
end
