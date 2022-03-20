# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::PLSQL do
  let(:subject) { Rouge::Lexers::PLSQL.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.pls'
      assert_guess :filename => 'foo.typ'
      assert_guess :filename => 'foo.tps'
      assert_guess :filename => 'foo.tpb'
      assert_guess :filename => 'foo.pks'
      assert_guess :filename => 'foo.pkb'
      assert_guess :filename => 'foo.pkg'
      assert_guess :filename => 'foo.trg'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-plsql'
    end
  end

  describe 'lexing' do
    include Support::Lexing
    describe 'numerics' do
      it 'distinguishes Float from Integer' do
        assert_tokens_equal "2.3 + 5",
          ['Literal.Number.Float', '2.3'],
          ['Text', ' '],
          ['Operator', '+'],
          ['Text', ' '],
          ['Literal.Number.Integer', '5']
      end

      it 'identifies Floats with exponent correctly' do
        assert_tokens_equal "12.3e4",
          ['Literal.Number.Float', '12.3e4']
        assert_tokens_equal "5.67e-9",
          ['Literal.Number.Float', '5.67e-9']
        assert_tokens_equal "20.4e+8",
          ['Literal.Number.Float', '20.4e+8']
      end
    end

  end
end
