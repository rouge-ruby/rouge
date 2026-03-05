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

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-yara'
    end

    it 'guesses by source' do
      assert_guess :source => 'rule Example { condition: true }'
      assert_guess :source => 'import "pe"'
      assert_guess :source => 'include "other.yar"'
    end
  end
end
