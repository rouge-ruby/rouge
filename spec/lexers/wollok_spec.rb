# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Wollok do
  let(:subject) { Rouge::Lexers::Wollok.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.wlk'
      assert_guess :filename => 'foo.wtest'
      assert_guess :filename => 'foo.wpgm'
    end
  end

  describe 'lexing' do
    it 'does not share entity list between instances' do
      a = Rouge::Lexers::Wollok.new
      b = Rouge::Lexers::Wollok.new

      # If "foo" is defined as object, it is recognized as Name.Class.
      result_a1 = a.lex('object foo {}').to_a
      assert_equal result_a1[2].first, Token['Name.Class']
      result_a2 = a.lex('foo.bar()').to_a
      assert_equal result_a2[0].first, Token['Name.Class']

      # If "foo" is undefined, it is recognized as Keyword.Variable.
      result_b1 = b.lex('foo.bar()').to_a
      assert_equal result_b1[0].first, Token['Keyword.Variable']
    end
  end
end
