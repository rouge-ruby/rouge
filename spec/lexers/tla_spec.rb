# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::TLA do
  let(:subject) { Rouge::Lexers::TLA.new }

  describe 'lexing' do
    include Support::Lexing

    it 'handles single line comments' do
      assert_tokens_equal '-- comment', ['Comment.Single', '-- comment']
    end

    it 'handles multiline comments' do
      assert_tokens_equal '(* comment *)', ['Comment.Multiline', '(* comment *)']
    end

    it 'handles keywords' do
      assert_tokens_equal 'EXTENDS', ['Keyword', 'EXTENDS']
    end

    it 'handles \in, \cup, etc.' do
      assert_tokens_equal 'a \in b', ['Name', 'a'], ['Text', ' '], ['Name', '\in'], ['Text', ' '], ['Name', 'b']
    end

    it 'handles basic TLA+ spec' do
      source = <<EOF
--- MODULE asdf ---

EXTENDS TLC, Integers

CONSTANTS N
VARIABLES k

Init == k = 0
Next == IF k = N THEN k' = 0 ELSE k' = k + 1

Spec == Init /\\ [][Next]_k

===================
EOF

      # tokens of the same type get merged, so matches for
      #
      #   ["Operator", "["], ["Operator", "]"], ["Operator", "["]
      #
      # becomes
      #
      #   ["Operator", "[]["]
      #
      expected =
        ['Comment.Single', '--- MODULE asdf ---'], ['Text', "\n\n"],
        ['Keyword', 'EXTENDS'], ['Text', ' '], ['Name', 'TLC'], ['Operator', ','], ['Text', ' '], ['Name', 'Integers'], ['Text', "\n\n"],
        ['Keyword', 'CONSTANTS'], ['Text', ' '], ['Name', 'N'], ['Text', "\n"],
        ['Keyword', 'VARIABLES'], ['Text', ' '], ['Name', 'k'], ['Text', "\n\n"],
        ['Name', 'Init'], ['Text', ' '], ['Operator', '=='], ['Text', ' '], ['Name', 'k'], ['Text', ' '], ['Operator', '='], ['Text', ' '], ['Literal.Number.Integer', '0'], ['Text', "\n"],
        ['Name', 'Next'], ['Text', ' '], ['Operator', '=='], ['Text', ' '], ['Keyword', 'IF'], ['Text', ' '], ['Name', 'k'], ['Text', ' '], ['Operator', '='], ['Text', ' '], ['Name', 'N'], ['Text', ' '], ['Keyword', 'THEN'], ['Text', ' '], ['Name', "k'"], ['Text', ' '], ['Operator', '='], ['Text', ' '], ['Literal.Number.Integer', '0'], ['Text', ' '], ['Keyword', 'ELSE'], ['Text', ' '], ['Name', "k'"], ['Text', ' '], ['Operator', '='], ['Text', ' '], ['Name', 'k'], ['Text', ' '], ['Operator', '+'], ['Text', ' '], ['Literal.Number.Integer', '1'], ['Text', "\n\n"],
        ['Name', 'Spec'], ['Text', ' '], ['Operator', '=='], ['Text', ' '], ['Name', 'Init'], ['Text', ' '], ['Operator', '/\\'], ['Text', ' '], ['Operator', '[]['], ['Name', 'Next'], ['Operator', ']_'], ['Name', 'k'], ['Text', "\n\n"],
        ['Comment.Single', '==================='], ['Text', "\n"]
      assert_tokens_equal source, *expected
    end
  end
end
