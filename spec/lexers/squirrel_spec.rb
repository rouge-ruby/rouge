# -*- coding: utf-8 -*- #
<<<<<<< HEAD
# frozen_string_literal: true
=======
>>>>>>> Added Squirrel lexer

describe Rouge::Lexers::Squirrel do
  let(:subject) { Rouge::Lexers::Squirrel.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.nut'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-squirrel'
    end
  end
end
