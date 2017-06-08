# -*- coding: utf-8 -*- #

describe Rouge::Lexers::RunKitJS do
  let(:subject) { Rouge::Lexers::RunKitJS.new }

  describe 'lexing' do
    include Support::Lexing

    it %(doesn't let a bad regex mess up the whole lex) do
      assert_has_token 'Error',          "var a = /foo;\n1"
      assert_has_token 'Literal.Number', "var a = /foo;\n1"
    end
  end

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename and does not replace existing specialized lexers' do
      assert_guess Rouge::Lexers::JSX, :filename => 'foo.jsx'
      assert_guess Rouge::Lexers::JSON, :filename => 'foo.json'
      assert_guess Rouge::Lexers::Javascript, :filename => 'foo.js'
    end

  end
end
