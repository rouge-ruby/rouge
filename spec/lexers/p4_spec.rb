# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::P4 do
  let(:subject) { Rouge::Lexers::P4.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.p4'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-p4'
    end
  end
end
