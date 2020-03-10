# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Ruby do
  let(:subject) { Rouge::Lexers::Ruby.new }

  describe 'lexing' do
    include Support::Lexing

    describe 'method calling' do
      describe 'leading dot' do
        it 'handles whitespace between the receiver and the method' do
          assert_tokens_equal "foo\n  .bar()",
            ['Name', 'foo'],
            ['Text', "\n  "],
            ['Punctuation', '.'],
            ['Name.Function', 'bar'],
            ['Punctuation', '()']
        end

        it 'handles whitespace between the receiver and multiple chained methods' do
          assert_tokens_equal "foo\n  .bar()\n  .baz",
            ['Name', 'foo'],
            ['Text', "\n  "],
            ['Punctuation', '.'],
            ['Name.Function', 'bar'],
            ['Punctuation', '()'],
            ['Text', "\n  "],
            ['Punctuation', '.'],
            ['Name.Function', 'baz']
        end
      end

      describe 'trailing dot' do
        it 'handles whitespace between the receiver and the method' do
          assert_tokens_equal "foo.\n  bar()",
            ['Name', 'foo'],
            ['Punctuation', '.'],
            ['Text', "\n  "],
            ['Name.Function', 'bar'],
            ['Punctuation', '()']
        end

        it 'handles whitespace between the receiver and multiple chained methods' do
          assert_tokens_equal "foo.\n  bar().\n  baz",
            ['Name', 'foo'],
            ['Punctuation', '.'],
            ['Text', "\n  "],
            ['Name.Function', 'bar'],
            ['Punctuation', '().'],
            ['Text', "\n  "],
            ['Name.Function', 'baz']
        end
      end
    end

    describe 'ranges' do
      it 'handles .. as range operator' do
        assert_tokens_equal "1..10",
          ['Literal.Number.Integer', '1'],
          ['Operator', '..'],
          ['Literal.Number.Integer', '10']
      end

      it 'handles ... as range operator' do
        assert_tokens_equal "'a'...'z'",
          ['Literal.String.Single', "'a'"],
          ['Operator', '...'],
          ['Literal.String.Single', "'z'"]
      end
    end

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

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.rb'
      assert_guess :filename => 'foo.ruby'
      assert_guess :filename => 'foo.rbw'
      assert_guess :filename => 'foo.gemspec'
      assert_guess :filename => 'foo.podspec'
      assert_guess :filename => 'Rakefile'
      assert_guess :filename => 'Guardfile'
      assert_guess :filename => 'Gemfile'
      assert_guess :filename => 'foo.rake'
      assert_guess :filename => 'Capfile'
      assert_guess :filename => 'Podfile'
      assert_guess :filename => 'Vagrantfile'
      assert_guess :filename => 'config.ru'
      assert_guess :filename => 'foo.pdf.prawn'
      assert_guess :filename => 'Berksfile'
      assert_guess :filename => 'Deliverfile'
      assert_guess :filename => 'Fastfile'
      assert_guess :filename => 'Appfile'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-ruby'
      assert_guess :mimetype => 'application/x-ruby'
    end

    it 'guesses by source' do
      assert_guess :source => '#!/usr/local/bin/ruby'
    end
  end
end
