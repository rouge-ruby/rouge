# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::FreeFEM do
  let(:subject) { Rouge::Lexers::FreeFEM.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.edp'
      assert_guess :filename => 'foo.idp', :source => 'foo'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-ffsrc'
    end
  end
end
