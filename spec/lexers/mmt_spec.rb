# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::MMT do
  let(:subject) { Rouge::Lexers::MMT.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.mmt'
      assert_guess :filename => 'bar.mmtx'
    end

    it 'guesses by source' do
      assert_guess :mimetype => 'application/x-mmt', :source => 'namespace http://example.com/foo/bar ❚'
    end
  end
end
