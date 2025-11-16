# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::ABAP do
  let(:subject) { Rouge::Lexers::ABAP.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.abap'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-abap'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'recognizes modern constructor operators' do
      # NEW operator
      assert_tokens_equal 'DATA(obj) = NEW class( )',
                          ['Keyword', 'DATA'],
                          ['Punctuation', '('],
                          ['Name', 'obj'],
                          ['Punctuation', ')'],
                          ['Text', ' '],
                          ['Operator', '='],
                          ['Text', ' '],
                          ['Keyword', 'NEW'],
                          ['Text', ' '],
                          ['Name', 'class'],
                          ['Punctuation', '('],
                          ['Text', ' '],
                          ['Punctuation', ')']

      # VALUE operator
      assert_tokens_equal 'itab = VALUE #( )',
                          ['Name', 'itab'],
                          ['Text', ' '],
                          ['Operator', '='],
                          ['Text', ' '],
                          ['Keyword', 'VALUE'],
                          ['Text', ' '],
                          ['Operator', '#'],
                          ['Punctuation', '('],
                          ['Text', ' '],
                          ['Punctuation', ')']

      # CORRESPONDING operator
      assert_tokens_equal 'struct2 = CORRESPONDING #( struct1 )',
                          ['Name', 'struct2'],
                          ['Text', ' '],
                          ['Operator', '='],
                          ['Text', ' '],
                          ['Keyword', 'CORRESPONDING'],
                          ['Text', ' '],
                          ['Operator', '#'],
                          ['Punctuation', '('],
                          ['Text', ' '],
                          ['Name', 'struct1'],
                          ['Text', ' '],
                          ['Punctuation', ')']
    end

    it 'recognizes CDS keywords' do
      # DEFINE VIEW ENTITY
      assert_tokens_equal 'DEFINE VIEW ENTITY ZTest',
                          ['Keyword', 'DEFINE'],
                          ['Text', ' '],
                          ['Keyword', 'VIEW'],
                          ['Text', ' '],
                          ['Keyword', 'ENTITY'],
                          ['Text', ' '],
                          ['Name', 'ZTest']

      # ASSOCIATION
      assert_tokens_equal 'ASSOCIATION TO ZEntity',
                          ['Keyword', 'ASSOCIATION'],
                          ['Text', ' '],
                          ['Keyword', 'TO'],
                          ['Text', ' '],
                          ['Name', 'ZEntity']

      # COMPOSITION
      assert_tokens_equal 'COMPOSITION OF ZChild',
                          ['Keyword', 'COMPOSITION'],
                          ['Text', ' '],
                          ['Keyword', 'OF'],
                          ['Text', ' '],
                          ['Name', 'ZChild']
    end

    it 'recognizes CDS and modern ABAP functions as builtins' do
      # Modern constructor functions
      assert_tokens_equal 'lv_result = conv( lv_value )',
                          ['Name', 'lv_result'],
                          ['Text', ' '],
                          ['Operator', '='],
                          ['Text', ' '],
                          ['Name.Builtin', 'conv'],
                          ['Punctuation', '('],
                          ['Text', ' '],
                          ['Name', 'lv_value'],
                          ['Text', ' '],
                          ['Punctuation', ')']

      # CDS numeric functions - note 'b' is a type keyword, use different variable name
      assert_tokens_equal 'div( arg1 arg2 )',
                          ['Name.Builtin', 'div'],
                          ['Punctuation', '('],
                          ['Text', ' '],
                          ['Name', 'arg1'],
                          ['Text', ' '],
                          ['Name', 'arg2'],
                          ['Text', ' '],
                          ['Punctuation', ')']

      # CDS currency conversion
      assert_tokens_equal 'currency_conversion( )',
                          ['Name.Builtin', 'currency_conversion'],
                          ['Punctuation', '('],
                          ['Text', ' '],
                          ['Punctuation', ')']

      # REDUCE operator
      assert_tokens_equal 'reduce( )',
                          ['Name.Builtin', 'reduce'],
                          ['Punctuation', '('],
                          ['Text', ' '],
                          ['Punctuation', ')']

      # FILTER operator
      assert_tokens_equal 'filter( )',
                          ['Name.Builtin', 'filter'],
                          ['Punctuation', '('],
                          ['Text', ' '],
                          ['Punctuation', ')']

      # CORRESPONDING function
      assert_tokens_equal 'corresponding( )',
                          ['Name.Builtin', 'corresponding'],
                          ['Punctuation', '('],
                          ['Text', ' '],
                          ['Punctuation', ')']
    end

    it 'recognizes COND and SWITCH expressions' do
      # COND expression - note 'x' is a type keyword in ABAP
      assert_tokens_equal 'lv_result = COND #( WHEN lv_var = 1 THEN a )',
                          ['Name', 'lv_result'],
                          ['Text', ' '],
                          ['Operator', '='],
                          ['Text', ' '],
                          ['Keyword', 'COND'],
                          ['Text', ' '],
                          ['Operator', '#'],
                          ['Punctuation', '('],
                          ['Text', ' '],
                          ['Keyword', 'WHEN'],
                          ['Text', ' '],
                          ['Name', 'lv_var'],
                          ['Text', ' '],
                          ['Operator', '='],
                          ['Text', ' '],
                          ['Literal.Number.Integer', '1'],
                          ['Text', ' '],
                          ['Keyword', 'THEN'],
                          ['Text', ' '],
                          ['Name', 'a'],
                          ['Text', ' '],
                          ['Punctuation', ')']

      # SWITCH expression
      assert_tokens_equal 'lv_result = SWITCH #( lv_var )',
                          ['Name', 'lv_result'],
                          ['Text', ' '],
                          ['Operator', '='],
                          ['Text', ' '],
                          ['Keyword', 'SWITCH'],
                          ['Text', ' '],
                          ['Operator', '#'],
                          ['Punctuation', '('],
                          ['Text', ' '],
                          ['Name', 'lv_var'],
                          ['Text', ' '],
                          ['Punctuation', ')']
    end

    it 'recognizes LET expressions' do
      assert_tokens_equal 'LET lv_var = 1 IN y',
                          ['Keyword', 'LET'],
                          ['Text', ' '],
                          ['Name', 'lv_var'],
                          ['Text', ' '],
                          ['Operator', '='],
                          ['Text', ' '],
                          ['Literal.Number.Integer', '1'],
                          ['Text', ' '],
                          ['Keyword', 'IN'],
                          ['Text', ' '],
                          ['Name', 'y']
    end

    it 'handles LOOP with STEP' do
      assert_tokens_equal 'LOOP AT itab STEP 2',
                          ['Keyword', 'LOOP'],
                          ['Text', ' '],
                          ['Keyword', 'AT'],
                          ['Text', ' '],
                          ['Name', 'itab'],
                          ['Text', ' '],
                          ['Keyword', 'STEP'],
                          ['Text', ' '],
                          ['Literal.Number.Integer', '2']
    end

    it 'recognizes ANNOTATION keyword' do
      assert_tokens_equal '@ANNOTATION.label',
                          ['Operator', '@'],
                          ['Keyword', 'ANNOTATION'],
                          ['Punctuation', '.'],
                          ['Name', 'label']
    end

    it 'recognizes cardinality keywords' do
      assert_tokens_equal 'MANY TO ONE',
                          ['Keyword', 'MANY'],
                          ['Text', ' '],
                          ['Keyword', 'TO'],
                          ['Text', ' '],
                          ['Keyword', 'ONE']
    end
  end
end
