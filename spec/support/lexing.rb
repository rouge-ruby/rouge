# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Support
  module Lexing
    def filter_by_token(target_token, text, lexer=nil)
      lexer ||= subject

      tokens = lexer.lex(text)

      tokens.select do |(tok, _)|
        same_token?(tok, target_token)
      end
    end

    def same_token?(token, target)
      if token.respond_to? :token_chain
        token.token_chain.include?(Rouge::Token[target])
      else
        token == target
      end
    end

    def deny_has_token(tokname, text, lexer=nil)
      refute { filter_by_token(tokname, text, lexer).any? }
    end

    def assert_has_token(tokname, text, lexer=nil)
      assert { filter_by_token(tokname, text, lexer).any? }
    end

    def assert_no_errors(*a)
      deny_has_token('Error', *a)
    end

    def assert_tokens_equal(text, *expected)
      if expected.first.is_a? Rouge::Lexer
        lexer = expected.shift
      else
        lexer = subject
      end

      actual = lexer.lex(text).map { |token, value| [ token.qualname, value ] }
      assert { expected == actual }
    end

    def assert_tokens_includes(text, *expected)
      if expected.first.is_a? Rouge::Lexer
        lexer = expected.shift
      else
        lexer = subject
      end

      actual = lexer.lex(text).map { |token, value| [ token.qualname, value ] }
      expected.all? { |e| assert_includes actual, e  }
    end
  end
end
