# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::ABAP do
  let(:described_class) { Rouge::Lexers::ABAP }
  let(:subject) { described_class.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.abap'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-abap'
    end
  end

  it 'does not respond to self.class.detect?' do
    refute { described_class.methods(false).include?(:detect?) }
    refute { described_class.detectable? }
  end
end
