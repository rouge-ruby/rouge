# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::YANG do
  let(:subject) { Rouge::Lexers::YANG.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'test.yang'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'application/yang'
    end

    describe 'lexing' do
      include Support::Lexing

      it 'parse namespace uri' do
        assert_tokens_equal 'namespace urn:ietf:params:xml:ns:yang:ietf-alarms;',
          ['Keyword.Declaration', 'namespace'],
          ['Text.Whitespace', ' '],
          ['Name', 'urn:ietf:params:xml:ns:yang:ietf-alarms'],
          ['Punctuation', ';']
      end

      it 'parse namespace prefix' do
        assert_tokens_equal 'type yang:counter64;',
          ['Keyword.Declaration', 'type'],
          ['Text.Whitespace', ' '],
          ['Name.Namespace', 'yang'],
          ['Punctuation', ":"],
          ['Name', 'counter64'],
          ['Punctuation', ';']
      end

      it 'parse revision-date' do
        assert_tokens_equal 'revision 2020-03-08{',
          ['Keyword.Declaration', 'revision'],
          ['Text.Whitespace', ' '],
          ['Name.Label', '2020-03-08'],
          ['Punctuation', '{']
      end

      it 'parse float in yang-version' do
        assert_tokens_equal 'yang-version 1.1;',
          ['Keyword.Declaration', 'yang-version'],
          ['Text.Whitespace', ' '],
          ['Literal.Number.Float', '1.1'],
          ['Punctuation', ';']
      end

      it 'parse integer in value' do
        assert_tokens_equal 'value 5;',
          ['Keyword.Declaration', 'value'],
          ['Text.Whitespace', ' '],
          ['Literal.Number.Integer', '5'],
          ['Punctuation', ';']
      end

      it 'parse integer in value' do
        assert_tokens_equal 'value "5";',
          ['Keyword.Declaration', 'value'],
          ['Text.Whitespace', ' '],
          ['Literal.String.Double', '"5"'],
          ['Punctuation', ';']
      end

      it 'parse complex name' do
        assert_tokens_equal ' +abc*iu{ asd;}',
          ['Text.Whitespace', ' '],
          ['Name', '+abc*iu'],
          ['Punctuation', '{'],
          ['Text.Whitespace', ' '],
          ['Name', 'asd'],
          ['Punctuation', ';}']
      end

    end

  end
end
