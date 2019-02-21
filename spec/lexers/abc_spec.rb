# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Abc do
  let(:subject) { Rouge::Lexers::Abc.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.abc'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/vnd.abc'
      assert_guess :mimetype => 'text/x-abc'
    end
  end
end
