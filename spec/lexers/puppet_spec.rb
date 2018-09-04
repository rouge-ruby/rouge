# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Puppet do
  let(:subject) { Rouge::Lexers::Puppet.new }

  describe 'lexing' do
    include Support::Lexing

    describe 'assignment' do
      describe 'equals' do
        it 'can assign a simple string' do
          assert_tokens_equal "$foo = 'bar'",
            ['Name.Variable', '$foo'],
            ['Text', ' '],
            ['Operator', '='],
            ['Text', ' '],
            ['Literal.String.Single', "'bar'"]
        end

        it 'can assign an array' do
          assert_tokens_equal "$foo = [\n  'bar',\n  'baz',\n  ]",
            ['Name.Variable', '$foo'],
            ['Text', ' '],
            ['Operator', '='],
            ['Text', ' '],
            ['Punctuation', '['],
            ['Text', "\n  "],
            ['Literal.String.Single', "'bar'"],
            ['Punctuation', ','],
            ['Text', "\n  "],
            ['Literal.String.Single', "'baz'"],
            ['Punctuation', ','],
            ['Text', "\n  "],
            ['Punctuation', ']']
        end

        it 'can assign a class variable Puppet 4 style' do
          assert_tokens_equal "Array[String] $foo = $bar::baz::qux,",
            ['Name.Class', 'Array'],    # Array[String] obviously is
            ['Punctuation', '['],       # not really a Name.Class[Name.Class]!
            ['Name.Class', 'String'],   # Puppet 4 Syntax highlighting seems
            ['Punctuation', ']'],       # look okay by accident here.
            ['Text', ' '],              #
            ['Name.Variable', '$foo'],
            ['Text', ' '],
            ['Operator', '='],
            ['Text', ' '],
            ['Name.Variable', '$bar::baz::qux'],
            ['Punctuation', ',']
        end
      end
    end
  end

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.pp'
    end

    it 'guesses by source' do
      assert_guess :source => '#!/usr/local/bin/puppet apply'
      assert_guess :source => '#!/usr/bin/puppet-apply'
    end
  end
end
