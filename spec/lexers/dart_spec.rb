# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Dart do
  let(:subject) { Rouge::Lexers::Dart.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.dart'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-dart'
    end
  end
  
  describe 'lexer' do
    include Support::Lexing

    it 'lexes exponential float values' do
      assert_tokens_equal '34.3e-7', ['Literal.Number.Float', '34.3e-7']
    end

    it 'lexes variable interpolation' do
      assert_tokens_equal %('Value: $value'),
        ['Literal.String', "'Value: "],
        ['Literal.String.Interpol', '$value'],
        ['Literal.String', "'"]
    end

    it 'lexes interpolated expression' do
      assert_tokens_equal %('Value: ${value + 1}'),
        ['Literal.String', "'Value: "],
        ['Literal.String.Interpol', '${value + 1}'],
        ['Literal.String', "'"]
    end

    it 'lexes escapes' do
      assert_tokens_equal %q('Line1\nLine2'),
        ['Literal.String', "'Line1"],
        ['Literal.String.Escape', '\n'],
        ['Literal.String', "Line2'"]
    end
  end
end
