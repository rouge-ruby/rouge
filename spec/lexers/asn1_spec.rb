# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Asn1 do
  let(:subject) { Rouge::Lexers::Asn1.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.asn'
      assert_guess :filename => 'foo.asn1'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-ttcn-asn'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'can lex numbers' do
      assert_tokens_equal '0', ['Literal.Number.Integer', '0']
      assert_tokens_equal '10', ['Literal.Number.Integer', '10']
      assert_tokens_equal '-20', ['Literal.Number.Integer', '-20']
      assert_tokens_equal '1.5', ['Literal.Number.Float', '1.5']
      assert_tokens_equal '-0.5', ['Literal.Number.Float', '-0.5']
      assert_tokens_equal '1E-6', ['Literal.Number.Float', '1E-6']

      # Binary string (X.680 02/2021 clause 12.10)
      assert_tokens_equal "'01101100'B", ['Literal.Number.Bin', "'01101100'B"]
      # Hexadecimal string (X.680 02/2021 clause 12.12)
      assert_tokens_equal "'AB0196'H", ['Literal.Number.Hex', "'AB0196'H"]
    end

    it 'can lex string' do
      assert_tokens_equal '""', ['Literal.String', '""']
      assert_tokens_equal '"😀"', ['Literal.String', '"😀"'] # non ascii text
      assert_tokens_equal %q("Multi\nLine"), ['Literal.String', %q("Multi\nLine")]
      assert_tokens_equal %q("Escaped""Quotation"),
        ['Literal.String', %q("Escaped)],
        ['Literal.String.Escape', %q("")],
        ['Literal.String', %q(Quotation")]
    end

    it 'can lex comments' do
      assert_tokens_equal '-- single line', ['Comment.Single', '-- single line']
      assert_tokens_equal " /*\n*/ /**/ ",
        ['Text.Whitespace', ' '],
        ['Comment.Multiline', "/*\n*/"],
        ['Text.Whitespace', ' '],
        ['Comment.Multiline', '/**/'],
        ['Text.Whitespace', ' ']

      # Nested multiple-line comments (X.680 02/2021 clause 12.6.4)
      assert_tokens_equal "/* /* nested */ \n-- */",
        ['Comment.Multiline', "/* /* nested */ \n-- */"]
    end

  end
end
