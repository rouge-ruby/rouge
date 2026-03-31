# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Nix do
  let(:subject) { Rouge::Lexers::Nix.new }

  describe 'lexing' do
    include Support::Lexing

    it 'recognizes Nix identifier boundaries (#2176)' do
      assert_tokens_equal "let\n  if' = -1;\n  trueTest = 1;\n  falseTest = 0;\nin { }", ["Keyword.Declaration", "let"], ["Text", "\n  "], ["Name.Variable", "if'"], ["Text", " "], ["Operator", "="], ["Text", " "], ["Operator", "-"], ["Literal.Number.Integer", "1"], ["Punctuation", ";"], ["Text", "\n  "], ["Name.Variable", "trueTest"], ["Text", " "], ["Operator", "="], ["Text", " "], ["Literal.Number.Integer", "1"], ["Punctuation", ";"], ["Text", "\n  "], ["Name.Variable", "falseTest"], ["Text", " "], ["Operator", "="], ["Text", " "], ["Literal.Number.Integer", "0"], ["Punctuation", ";"], ["Text", "\n"], ["Keyword.Namespace", "in"], ["Text", " "], ["Punctuation", "{"], ["Text", " "], ["Punctuation", "}"]
    end
  end
end
