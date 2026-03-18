# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Gherkin do
  let(:subject) { Rouge::Lexers::Gherkin.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.feature'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-gherkin'
    end

    it 'guesses by source' do
      assert_guess :source => '#!/usr/bin/env cucumber'
    end
  end

  describe 'lexing' do
    it 'highlights multiline steps correctly' do
      tokens = subject.lex("When this\nAnd that").to_a

      assert { tokens.size == 4 }
      assert { tokens[0] == [Token['Name.Function'], 'When'] }
      assert { tokens[1] == [Token['Text'], " this\n"] }
      assert { tokens[2] == [Token['Name.Function'], 'And'] }
      assert { tokens[3] == [Token['Text'], ' that'] }
    end

    it 'highlights placeholders correctly' do
      tokens = subject.lex('When <foo> (<bar>, <baz>)< garbage').to_a

      assert { tokens.size == 8 }
      assert { tokens[0] == [Token['Name.Function'], 'When'] }
      assert { tokens[1] == [Token['Text'], ' '] }
      assert { tokens[2] == [Token['Name.Variable'], '<foo>'] }
      assert { tokens[3] == [Token['Text'], ' ('] }
      assert { tokens[4] == [Token['Name.Variable'], '<bar>'] }
      assert { tokens[5] == [Token['Text'], ', '] }
      assert { tokens[6] == [Token['Name.Variable'], '<baz>'] }
      assert { tokens[7] == [Token['Text'], ')< garbage'] }
    end
  end
end
