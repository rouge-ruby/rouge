# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Javascript do
  let(:subject) { Rouge::Lexers::Javascript.new }

  describe 'lexing' do
    include Support::Lexing

    it %(doesn't let a bad regex mess up the whole lex) do
      assert_has_token 'Error',          "var a = /foo;\n1"
      assert_has_token 'Literal.Number', "var a = /foo;\n1"
    end

    it 'lexes strings with backticks' do
      assert_tokens_equal %(`Value`),
                          ['Literal.String.Backtick', "`Value`"]

    end

    it 'lexes interpolated expressions' do
      assert_tokens_equal %(`Value: ${10+20}`),
                          ['Literal.String.Backtick', "`Value: "],
                          ['Literal.String.Interpol', '${'],
                          ['Literal.Number.Integer', '10'],
                          ['Operator', '+'],
                          ['Literal.Number.Integer', '20'],
                          ['Literal.String.Interpol', '}'],
                          ['Literal.String.Backtick', "`"]
    end

    it 'lexes multiline strings' do
      assert_tokens_equal %(`Value: \n${10+20}\n`),
                          ['Literal.String.Backtick', "`Value: \n"],
                          ['Literal.String.Interpol', '${'],
                          ['Literal.Number.Integer', '10'],
                          ['Operator', '+'],
                          ['Literal.Number.Integer', '20'],
                          ['Literal.String.Interpol', '}'],
                          ['Literal.String.Backtick', "\n`"]
    end

  end

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.js'
      assert_guess Rouge::Lexers::JSON, :filename => 'foo.json'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/javascript'
      assert_guess Rouge::Lexers::JSON, :mimetype => 'application/json'
      assert_guess Rouge::Lexers::JSON, :mimetype => 'application/vnd.api+json'
    end

    it 'guesses by source' do
      assert_guess :source => '#!/usr/bin/env node'
      assert_guess :source => '#!/usr/local/bin/jsc'
      assert_guess Rouge::Lexers::JSON, :source => '{ "foo": "bar" }'
    end
  end
end
