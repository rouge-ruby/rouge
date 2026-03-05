# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Natural do
  let(:subject) { Rouge::Lexers::Natural.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.NSA'
      assert_guess :filename => 'foo.NSC'
      assert_guess :filename => 'foo.NSD'
      assert_guess :filename => 'foo.NSF'
      assert_guess :filename => 'foo.NSG'
      assert_guess :filename => 'foo.NSH'
      assert_guess :filename => 'foo.NSL'
      assert_guess :filename => 'foo.NSM'
      assert_guess :filename => 'foo.NSN'
      assert_guess :filename => 'foo.NSP'
      assert_guess :filename => 'foo.NSS'
      assert_guess :filename => 'foo.NST'
      assert_guess :filename => 'foo.NSR'
      assert_guess :filename => 'foo.NS7'
    end
    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-natural'
    end
  end
end