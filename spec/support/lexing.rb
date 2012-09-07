module Support
  module Lexing
    def assert_no_errors(text, lexer=nil)
      lexer ||= subject

      tokens = lexer.lex(text)

      errors = tokens.select do |(tok, val)|
        tok.name.include? 'Error'
      end

      assert { errors.empty? }

      tokens
    end
  end
end
