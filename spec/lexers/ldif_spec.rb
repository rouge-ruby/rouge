# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::LDIF do
  let(:subject) { Rouge::Lexers::LDIF.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.ldif'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/ldif'
    end
  end
end
