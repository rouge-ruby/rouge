# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::NSS do
  let(:subject) { Rouge::Lexers::NSS.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.nss'
      assert_guess :filename => 'FOO.NSS'
    end
  end
end
