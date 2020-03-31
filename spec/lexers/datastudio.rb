# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Datastudio do
  let(:subject) { Rouge::Lexers::Datastudio.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.job'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-datastudio'
    end
  end
end
