# -*- coding: utf-8 -*- #

describe Rouge::Lexers::HQL do
  let(:subject) { Rouge::Lexers::HQL.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.hql'
    end

  end

  describe 'lexing' do
    include Support::Lexing

    it 'recognizes variable interpolation within a string' do
      assert_tokens_equal '"${var1}.${var2}"', ['Literal.String.Double', '"'], ['Name.Variable', '${var1}'], ['Literal.String.Double', '.'], ['Name.Variable', '${var2}'], ['Literal.String.Double', '"']
    end
  end
end
