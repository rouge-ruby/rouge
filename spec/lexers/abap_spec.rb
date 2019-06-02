# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::ABAP do
  let(:subject) { Rouge::Lexers::ABAP.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.abap'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-abap'
    end
  end
end
