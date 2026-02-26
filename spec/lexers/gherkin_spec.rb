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
      assert { tokens[0][0] == Token['Name.Function'] }
      assert { tokens[1][0] == Token['Text'] }
      assert { tokens[2][0] == Token['Name.Function'] }
      assert { tokens[3][0] == Token['Text'] }
    end

    it 'highlights placeholders correctly' do
      tokens = subject.lex('When <foo> (<bar>, <baz>)< garbage').to_a

      assert { tokens.size == 7 }
      assert { tokens[0][0] == Token['Name.Function'] }
      assert { tokens[1][0] == Token['Name.Variable'] }
      assert { tokens[2][0] == Token['Text'] }
      assert { tokens[3][0] == Token['Name.Variable'] }
      assert { tokens[4][0] == Token['Text'] }
      assert { tokens[5][0] == Token['Name.Variable'] }
      assert { tokens[6][0] == Token['Text'] }
    end

    it 'highlights annotated strings correctly' do
      source = <<~GHERKIN
        Given I have some code
        """ruby
        class Calculator
        end
        """
      GHERKIN
      
      find_calls = []
      original_find = Rouge::Lexer.method(:find)
      Rouge::Lexer.define_singleton_method(:find) do |lang|
        find_calls << lang
        original_find.call(lang)
      end
      
      tokens = subject.lex(source).to_a
        
      assert { tokens.size == 11 }
      assert { tokens[0][0] == Token['Name.Function'] }
      assert { tokens[2][0] == Token['Literal.String'] }
      assert { tokens[1][0] == Token['Text'] }
      assert { tokens[3][0] == Token['Keyword'] }
      assert { tokens[4][0] == Token['Text'] }
      assert { tokens[5][0] == Token['Name.Class'] }
      assert { tokens[6][0] == Token['Text'] }
      assert { tokens[7][0] == Token['Keyword'] }
      assert { tokens[8][0] == Token['Text'] }
      assert { tokens[9][0] == Token['Literal.String'] }
      assert { tokens[10][0] == Token['Text'] }
      assert { find_calls.include?('ruby') }
    end
  end
end
