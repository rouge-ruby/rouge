# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::LiterateCoffeescript do
  let(:subject) { Rouge::Lexers::LiterateCoffeescript.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.litcoffee'
    end
  end
end
