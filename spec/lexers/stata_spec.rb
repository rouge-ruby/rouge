# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Stata do
  let(:subject) { Rouge::Lexers::Stata.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.do'
      assert_guess :filename => 'bar.ado'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-stata'
      assert_guess :mimetype => 'application/x-stata'
    end

  end
end
