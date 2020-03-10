# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Markdown do
  let(:subject) { Rouge::Lexers::Markdown.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.md'
      assert_guess :filename => 'foo.mkd'
      assert_guess :filename => 'foo.markdown'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-markdown'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'recognizes code blocks' do
      assert_has_token("Name.Label","\n```ruby\nfoo\n```\n")
    end

    it 'recognizes code blocks starting at the first character of the input string' do
      assert_has_token("Name.Label","```ruby\nfoo\n```\n")
    end

    it 'recognizes code block when lexer is continued' do
      subject.lex("```ruby\n").to_a
      actual = subject.continue_lex("@foo\n```\n").map { |token, value| [ token.qualname, value ] }
      assert { ["Name.Variable.Instance", "@foo"] == actual.first }
    end

    it 'guesses sub-lexer based on code-block content' do
      assert_has_token("Comment.Single","```\n#!/usr/bin/env ruby\n```\n")
    end

    it 'picks a sub-lexer when the code-block-content is ambiguous' do
      source = "Index: ): Awaitable<\n"
      assert_raises Rouge::Guesser::Ambiguous do
        Rouge::Lexer.find_fancy(nil, source)
      end
      assert_no_errors "```\n#{source}```\n"
    end

    it 'recognizes backticks instead of code block if inside string' do
      assert_has_token("Literal.String.Backtick","\nx```ruby\nfoo\n```\n")
      deny_has_token("Name.Label","\nx```ruby\nfoo\n```\n")
    end
  end
end
