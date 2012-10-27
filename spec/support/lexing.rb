module Support
  module Lexing
    def filter_by_token(tokname, text, lexer=nil)
      lexer ||= subject

      target_token = Rouge::Token[tokname]

      tokens = lexer.lex(text)

      tokens.select do |(tok, val)|
        target_token === tok
      end
    end

    def deny_has_token(tokname, text, lexer=nil)
      deny { filter_by_token(tokname, text, lexer).any? }
    end

    def assert_has_token(tokname, text, lexer=nil)
      assert { filter_by_token(tokname, text, lexer).any? }
    end

    def assert_no_errors(*a)
      deny_has_token('Error', *a)
    end
  end
end
