# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Elm do
  let(:subject) { Rouge::Lexers::Elm.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.elm'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-elm'
    end
  end
end
