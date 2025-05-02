# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::APL do
  let(:subject) { Rouge::Lexers::APL.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.apl'
      assert_guess :filename => 'foo.apla'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    describe 'primitives' do
      it 'covers all primitive functions' do
        '+-×÷*⍟⌹○!?|⌈⌊⊥⊤⊣⊢=≠≤<>≥≡≢∨∧⍲⍱↑↓⊂⊃⊆⌷⍋⍒⍳⍸∊⍷∪∩~,⍪⍴⌽⊖⍉⎕⍎⍕'.chars.each do |f|
          assert_tokens_equal f, ['Keyword', f]
        end
      end
      it 'covers all primitive operators' do
        '¨⍨⍣∘⍤⍥@⌸⍨⍣⌿⍀/\\∘⍠&⌶⌺@'.chars.each do |op|
          assert_tokens_equal op, ['Operator', op]
        end
      end
    end

    describe 'strings' do
      it 'recognizes correct strings' do
        assert_tokens_equal "'single quotes'", ['Literal.String.Single', "'single quotes'"]
        assert_tokens_equal "'single '' quotes'", 
        ['Literal.String.Single', "'single "],
        ['Literal.String.Escape', "''"],
        ['Literal.String.Single', " quotes'"]
      end
      it 'recognizes incorrect strings' do
        assert_tokens_equal "'single quote", ['Literal.String.Single', "'single quote"]
      end
    end

    describe 'numbers' do
      it 'recognizes integers' do
        assert_tokens_equal "123", ['Literal.Number', "123"]
        assert_tokens_equal "123456", ['Literal.Number', "123456"]
      end
      it 'recognizes floats' do
        assert_tokens_equal "123.456", ['Literal.Number', '123.456']
        assert_tokens_equal "¯123.456", ['Literal.Number', '¯123.456']
        assert_tokens_equal "123E5", ['Literal.Number', '123E5']
        assert_tokens_equal "123e5", ['Literal.Number', '123e5']
        assert_tokens_equal "¯12.3e5", ['Literal.Number', '¯12.3e5']
      end
      it 'recognizes imaginary numbers' do
        assert_tokens_equal "124j456", ['Literal.Number', '124j456']
        assert_tokens_equal "¯124j456", ['Literal.Number', '¯124j456']
        assert_tokens_equal "¯124j¯456", ['Literal.Number', '¯124j¯456']
      end
    end

    describe 'comments' do
      it 'recognizes shebang' do
        assert_tokens_equal "#!/usr/bin/env mapl", ["Comment.Special", "#!/usr/bin/env mapl"]
      end
      it 'recognizes line comments' do
        assert_tokens_equal "⍝ line comment", ["Comment.Single", "⍝ line comment"]
        assert_tokens_equal "123 ⍝ line comment",
        ["Literal.Number", "123"],
        ["Text", " "],
        ["Comment.Single", "⍝ line comment"]
      end
    end
  end
end
