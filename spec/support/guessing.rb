# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Support
  module Guessing
    def assert_guess(type=nil, info={})
      if type.is_a? Hash
        info = type
        type = nil
      end

      type ||= subject.class

      assert { Rouge::Lexer.guess(info) == type }
      Rouge::Lexer.all.reverse!

      assert { Rouge::Lexer.guess(info) == type }
      Rouge::Lexer.all.reverse!
    end

    def deny_guess(type=nil, info={})
      if type.is_a? Hash
        info = type
        type = nil
      end

      type ||= subject.class

      refute { Rouge::Lexer.guess(info) == type }
      Rouge::Lexer.all.reverse!

      refute { Rouge::Lexer.guess(info) == type }
      Rouge::Lexer.all.reverse!
    end
  end
end
