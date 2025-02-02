# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Scilab do
  let(:subject) { Rouge::Lexers::Scilab.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.sci', :source => '// comment'
      assert_guess :filename => 'foo.sce', :source => '// comment'
      assert_guess :filename => 'foo.tst', :source => '// comment'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-scilab'
      assert_guess :mimetype => 'application/x-scilab'
    end

  end
end
