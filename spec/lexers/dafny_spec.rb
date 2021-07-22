# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Dafny do
  let(:subject) { Rouge::Lexers::Dafny.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.dfy'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-dafny'
    end
  end
end
