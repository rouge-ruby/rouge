# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Nial do
  let(:subject) { Rouge::Lexers::Nial.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.ndf'
      assert_guess :filename => 'foo.nlg'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    describe 'words' do
      it 'recognizes miscellaneous variable names' do
        assert_tokens_equal "hello", ['Name.Variable', "hello"]
        assert_tokens_equal "world", ['Name.Variable', "world"]
        assert_tokens_equal "foo_bar_baz1234", ['Name.Variable', "foo_bar_baz1234"]
      end
    end

    describe 'strings' do
      it 'recognizes single-quoted text' do
        assert_tokens_equal "'foo bar 12345á!#$@?'",
        ['Literal.String.Single', "'foo bar 12345á!#$@?'"]
      end

      it 'recognizes escape sequences' do
        assert_tokens_equal "'foo''bar'''",
        ['Literal.String.Single', "'foo"],
        ['Literal.String.Escape', "''"],
        ['Literal.String.Single', "bar"],
        ['Literal.String.Escape', "''"],
        ['Literal.String.Single', "'"]
      end

      it 'recognizes character literals' do
        assert_tokens_equal "`a", ["Literal.String.Char", "`a"]
        assert_tokens_equal "``", ["Literal.String.Char", "``"]
      end
    end

    describe 'symbols' do
      it 'recognizes phrases' do
        assert_tokens_equal '"hello', ["Literal.String.Symbol", '"hello']
        assert_tokens_equal '"many""quotes""?fdfad"', ["Literal.String.Symbol", '"many""quotes""?fdfad"']
        assert_tokens_equal '"', ["Literal.String.Symbol", '"']
        assert_tokens_equal '"""""', ["Literal.String.Symbol", '"""""']
      end
      it 'recognizes faults' do
        assert_tokens_equal '?fault', ["Generic.Error", '?fault']
        assert_tokens_equal '?', ["Generic.Error", '?']
        assert_tokens_equal '???', ["Generic.Error", '???']
      end
    end

    describe 'numbers' do
      it 'recognizes integers' do
        assert_tokens_equal '123', ["Literal.Number.Integer", '123']
        assert_tokens_equal '123 456', ["Literal.Number.Integer", '123'], ["Text", " "], ["Literal.Number.Integer", '456']
        assert_tokens_equal '456-789', ["Literal.Number.Integer", '456-789']
        assert_tokens_equal '416 -732', ["Literal.Number.Integer", '416'], ["Text", " "], ["Literal.Number.Integer", '-732']
      end
      it 'recognizes floats' do
        assert_tokens_equal '123.', ["Literal.Number.Float", '123.']
        assert_tokens_equal '12.56', ["Literal.Number.Float", '12.56']
        assert_tokens_equal '78e3', ["Literal.Number.Float", '78e3']
        assert_tokens_equal '78e+3', ["Literal.Number.Float", '78e+3']
        assert_tokens_equal '78e-3', ["Literal.Number.Float", '78e-3']
        assert_tokens_equal '90.4e3', ["Literal.Number.Float", '90.4e3']
        assert_tokens_equal '90.4e+30', ["Literal.Number.Float", '90.4e+30']
        assert_tokens_equal '90.4e-30', ["Literal.Number.Float", '90.4e-30']
        # same, except negative
        assert_tokens_equal '-123.', ["Literal.Number.Float", '-123.']
        assert_tokens_equal '-12.56', ["Literal.Number.Float", '-12.56']
        assert_tokens_equal '-78e3', ["Literal.Number.Float", '-78e3']
        assert_tokens_equal '-78e+3', ["Literal.Number.Float", '-78e+3']
        assert_tokens_equal '-78e-3', ["Literal.Number.Float", '-78e-3']
        assert_tokens_equal '-90.4e3', ["Literal.Number.Float", '-90.4e3']
        assert_tokens_equal '-90.4e+30', ["Literal.Number.Float", '-90.4e+30']
        assert_tokens_equal '-90.4e-30', ["Literal.Number.Float", '-90.4e-30']
      end
      it 'recognizes booleans' do
        assert_tokens_equal 'l', ['Literal.Number.Bin', 'l']
        assert_tokens_equal 'o', ['Literal.Number.Bin', 'o']
        assert_tokens_equal 'loololoolololollool', ['Literal.Number.Bin', 'loololoolololollool']
      end
    end


    describe 'comments' do
      it 'recognizes percentage comments' do
        assert_tokens_equal "% comment ;", ["Comment.Multiline", "% comment ;"]
        assert_tokens_equal "% more\nthan\none\nline ;", ["Comment.Multiline", "% more\nthan\none\nline ;"]
      end
      it 'recognizes hash comments' do
        assert_tokens_equal "# comment \n\n", ["Comment.Multiline", "# comment \n\n"]
        assert_tokens_equal "# more\nthan\none\nline \n\n", ["Comment.Multiline", "# more\nthan\none\nline \n\n"]
      end
    end
  end
end
