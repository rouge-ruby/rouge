# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::XPath do
  let(:subject) { Rouge::Lexers::XPath.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.xpath'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    describe 'whitespace' do
      it 'handles whitespace in attribute names' do
        assert_tokens_equal "$emp/@  name",
          ['Name.Variable', '$emp'],
          ['Operator', '/'],
          ['Name.Attribute', '@'],
          ['Text.Whitespace', '  '],
          ['Name.Attribute', 'name']
      end

      it 'handles whitespace in variable names' do
        assert_tokens_equal "$  emp",
          ['Name.Variable', '$'],
          ['Text.Whitespace', '  '],
          ['Name.Variable', 'emp']
      end
    end
  end
end
