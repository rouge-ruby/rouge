# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Scad do
  let(:subject) { Rouge::Lexers::Scad.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.scad'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-scad'
    end
  end
end
