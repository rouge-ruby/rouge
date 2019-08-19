# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Awk do
  let(:subject) { Rouge::Lexers::Awk.new }

  describe 'lexing' do
    include Support::Lexing

    it %(doesn't let a bad regex mess up the whole lex) do
      assert_has_token 'Error',          "a = /foo;\n1"
      assert_has_token 'Literal.Number', "a = /foo;\n1"
    end
  end

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.awk'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'application/x-awk'
    end

    it 'guesses by source' do
      assert_guess :source => '#!/usr/bin/awk'
      assert_guess :source => '#!/usr/bin/env awk'
    end
  end
end
