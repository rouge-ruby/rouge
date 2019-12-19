# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::GHCCore do
  let(:subject) { Rouge::Lexers::GHCCore.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'Main.dump-simpl'
      assert_guess :filename => 'Main.dump-ds'
      assert_guess :filename => 'Main.dump-cse'
      assert_guess :filename => 'Main.dump-spec'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    # see ruby_spec.rb
    it 'should lex section markers as comments' do
      core = '==================== Tidy Core ===================='
      assert_tokens_equal core, ['Generic.Heading', core]

      core = '==================== Common sub-expression ===================='
      assert_tokens_equal core, ['Generic.Heading', core]
    end

    it 'should lex timestamps as comments' do
      core = '2019-11-23 17:25:18.138996323 UTC'
      assert_tokens_equal core, ['Comment.Single', core]
    end

    it 'should lex result sizes as comments' do
      core = "Result size of Tidy Core
  = {terms: 8,052, types: 9,956, coercions: 0, joins: 41/225}"

      assert_tokens_equal core, ['Comment.Multiline', core]
    end

    it 'should lex single line comments' do
      core = '-- RHS size: {terms: 6, types: 42, coercions: 0, joins: 0/0}'
      assert_tokens_equal core, ['Comment.Single', core]
    end

    it "should lex type declarations with type constraints" do
      core = 'GHC.Real.$p1RealFrac :: forall a. RealFrac a => Real a'
      assert_tokens_equal core,
                          ['Name.Function', 'GHC.Real.$p1RealFrac'],
                          ['Text', ' '],
                          ['Operator', '::'],
                          ['Text', ' '],
                          ['Keyword', 'forall'],
                          ['Text', ' '],
                          ['Name.Variable', 'a'],
                          ['Punctuation', '.'],
                          ['Text', ' '],
                          ['Keyword.Type', 'RealFrac'],
                          ['Text', ' '],
                          ['Name.Variable', 'a'],
                          ['Text', ' '],
                          ['Operator', '=>'],
                          ['Text', ' '],
                          ['Keyword.Type', 'Real'],
                          ['Text', ' '],
                          ['Name.Variable', 'a']
    end

    it "should lex type declarations with hints and special characters in the name" do
      core = 'GHC.Real.$w$slcm1 [InlPrag=NOINLINE[1]] :: Int -> Int# -> Int#'

      assert_tokens_equal core,
                          ['Name.Function', 'GHC.Real.$w$slcm1'],
                          ['Text', ' '],
                          ['Comment.Special', '[InlPrag=NOINLINE[1]]'],
                          ['Text', ' '],
                          ['Operator', '::'],
                          ['Text', ' '],
                          ['Keyword.Type', 'Int'],
                          ['Text', ' '],
                          ['Operator', '->'],
                          ['Text', ' '],
                          ['Keyword.Type', 'Int#'],
                          ['Text', ' '],
                          ['Operator', '->'],
                          ['Text', ' '],
                          ['Keyword.Type', 'Int#']

    end

    it "should lex type declarations with # as type" do
      core = 'GHC.Real.$w$s$c/ [InlPrag=NOUSERINLINE[2]]
  :: Integer
     -> Integer -> Integer -> Integer -> (# Integer, Integer #)
'

      assert_tokens_equal core,
                          ['Name.Function', 'GHC.Real.$w$s$c/'],
                          ['Text', ' '],
                          ['Comment.Special', '[InlPrag=NOUSERINLINE[2]]'],
                          ['Text', "\n  "],
                          ['Operator', '::'],
                          ['Text', ' '],
                          ['Keyword.Type', 'Integer'],
                          ['Text', "\n     "],
                          ['Operator', '->'],
                          ['Text', ' '],
                          ['Keyword.Type', 'Integer'],
                          ['Text', ' '],
                          ['Operator', '->'],
                          ['Text', ' '],
                          ['Keyword.Type', 'Integer'],
                          ['Text', ' '],
                          ['Operator', '->'],
                          ['Text', ' '],
                          ['Keyword.Type', 'Integer'],
                          ['Text', ' '],
                          ['Operator', '->'],
                          ['Text', ' '],
                          ['Punctuation', '('],
                          ['Name.Variable', '#'],
                          ['Text', ' '],
                          ['Keyword.Type', 'Integer'],
                          ['Punctuation', ','],
                          ['Text', ' '],
                          ['Keyword.Type', 'Integer'],
                          ['Text', ' '],
                          ['Name.Variable', '#'],
                          ['Punctuation', ')'],
                          ['Text', "\n"]
    end

    it 'should lex type declarations with parentheses and arrows' do
      core = 'properFraction
  :: forall a b. (RealFrac a, Integral b) => a -> (b, a)'

      assert_tokens_equal core,
                          ['Name.Function', 'properFraction'],
                          ['Text', "\n  "],
                          ['Operator', '::'],
                          ['Text', ' '],
                          ['Keyword', 'forall'],
                          ['Text', ' '],
                          ['Name.Variable', 'a'],
                          ['Text', ' '],
                          ['Name.Variable', 'b'],
                          ['Punctuation', '.'],
                          ['Text', ' '],
                          ['Punctuation', '('],
                          ['Keyword.Type', 'RealFrac'],
                          ['Text', ' '],
                          ['Name.Variable', 'a'],
                          ['Punctuation', ','],
                          ['Text', ' '],
                          ['Keyword.Type', 'Integral'],
                          ['Text', ' '],
                          ['Name.Variable', 'b'],
                          ['Punctuation', ')'],
                          ['Text', ' '],
                          ['Operator', '=>'],
                          ['Text', ' '],
                          ['Name.Variable', 'a'],
                          ['Text', ' '],
                          ['Operator', '->'],
                          ['Text', ' '],
                          ['Punctuation', '('],
                          ['Name.Variable', 'b'],
                          ['Punctuation', ','],
                          ['Text', ' '],
                          ['Name.Variable', 'a'],
                          ['Punctuation', ')']
    end

    it 'should lex function definitions with special characters in the name' do
      core = 'GHC.Real.$W:%
  ='

      assert_tokens_equal core,
                          ['Name.Function', 'GHC.Real.$W:%'],
                          ['Text', "\n  "],
                          ['Operator', '=']
    end

    it 'should lex full functions' do
      core = 'GHC.Real.$p1RealFrac
  = \ (@ a_a1S3) (v_B1 :: RealFrac a_a1S3) ->
      case v_B1 of v_B1
      { GHC.Real.C:RealFrac v_B2 v_B3 v_B4 v_B5 v_B6 v_B7 v_B8 ->
      v_B2
      }'

      assert_tokens_equal core,
                          # Function
                          ['Name.Function', 'GHC.Real.$p1RealFrac'],
                          ['Text', "\n  "],
                          ['Operator', '='],
                          ['Text', ' '],
                          # Lambda
                          ['Operator', '\\'],
                          ['Text', ' '],
                          ['Punctuation', '('],
                          ['Operator', '@'],
                          ['Text', ' '],
                          ['Name.Variable', 'a_a1S3'],
                          ['Punctuation', ')'],
                          ['Text', ' '],
                          ['Punctuation', '('],
                          ['Name.Variable', 'v_B1'],
                          ['Text', ' '],
                          ['Operator', '::'],
                          ['Text', ' '],
                          ['Keyword.Type', 'RealFrac'],
                          ['Text', ' '],
                          ['Name.Variable', 'a_a1S3'],
                          ['Punctuation', ')'],
                          ['Text', ' '],
                          ['Operator', '->'],
                          ['Text', "\n      "],
                          # Case
                          ['Keyword', 'case'],
                          ['Text', ' '],
                          ['Name.Variable', 'v_B1'],
                          ['Text', ' '],
                          ['Keyword', 'of'],
                          ['Text', ' '],
                          ['Name.Variable', 'v_B1'],
                          ['Text', "\n      "],
                          ['Punctuation', '{'],
                          ['Text', ' '],
                          ["Keyword.Type", "GHC"], ["Punctuation", "."], ["Keyword.Type", "Real"], ["Punctuation", "."], ["Keyword.Type", "C:RealFrac"],
                          ['Text', ' '],
                          ['Name.Variable', 'v_B2'],
                          ['Text', ' '],
                          ['Name.Variable', 'v_B3'],
                          ['Text', ' '],
                          ['Name.Variable', 'v_B4'],
                          ['Text', ' '],
                          ['Name.Variable', 'v_B5'],
                          ['Text', ' '],
                          ['Name.Variable', 'v_B6'],
                          ['Text', ' '],
                          ['Name.Variable', 'v_B7'],
                          ['Text', ' '],
                          ['Name.Variable', 'v_B8'],
                          ['Text', ' '],
                          ['Operator', '->'],
                          ['Text', "\n      "],
                          # Body
                          ['Name.Variable', 'v_B2'],
                          ['Text', "\n      "],
                          ['Punctuation', '}']
    end

    it 'should lex annotations' do
      core = '[GblId[ClassOp],
 Arity=1,
 Caf=NoCafRefs,
 Str=<S(SLLLLLL),U(U,A,A,A,A,A,A)>,
 RULES: Built in rule for GHC.Real.$p1RealFrac: "Class op $p1RealFrac"]'

      assert_tokens_equal core, ['Comment.Special', core]
    end

    it 'should lex integers' do
      core = "GHC.Real.$tc':%
  = GHC.Types.TyCon
      11952989868638128372##
      6861245286732044789##
      GHC.Real.$trModule
      GHC.Real.$tc':%2
      1#
      GHC.Real.$tc':%1"

      assert_tokens_equal core,
                          ['Name.Function', "GHC.Real.$tc':%"],
                          ['Text', "\n  "],
                          ['Operator', '='],
                          ['Text', ' '],
                          ["Keyword.Type", "GHC"], ["Punctuation", "."], ["Keyword.Type", "Types"], ["Punctuation", "."], ["Keyword.Type", "TyCon"],
                          ['Text', "\n      "],
                          ['Literal.Number.Integer', '11952989868638128372##'],
                          ['Text', "\n      "],
                          ['Literal.Number.Integer', '6861245286732044789##'],
                          ['Text', "\n      "],
                          ["Keyword.Type", "GHC"], ["Punctuation", "."], ["Keyword.Type", "Real"], ["Punctuation", "."], ['Name.Variable', '$trModule'],
                          ['Text', "\n      "],
                          ["Keyword.Type", "GHC"], ["Punctuation", "."], ["Keyword.Type", "Real"], ["Punctuation", "."], ['Name.Variable', "$tc':%2"],
                          ['Text', "\n      "],
                          ['Literal.Number.Integer', '1#'],
                          ['Text', "\n      "],
                          ["Keyword.Type", "GHC"], ["Punctuation", "."], ["Keyword.Type", "Real"], ["Punctuation", "."], ['Name.Variable', "$tc':%1"]
    end

    it 'should lex floats' do
      core = 'number = ghc-prim-0.5.3:GHC.Types.D# 1.5##'

      assert_tokens_equal core,
                          ['Name.Function', 'number'],
                          ['Text', ' '],
                          ['Operator', '='],
                          ['Text', ' '],
                          ['Name.Namespace', 'ghc-prim-0.5.3'],
                          ['Punctuation', ':'],
                          ['Keyword.Type', 'GHC'], ['Punctuation', '.'], ['Keyword.Type', 'Types'], ['Punctuation', '.'], ['Keyword.Type', 'D#'],
                          ['Text', ' '],
                          ['Literal.Number.Float', '1.5##']

    end

    it 'should lex strings' do
      core = 'lvl_s2UY = "I am a \"String\""#'

      assert_tokens_equal core,
                          ['Name.Function', "lvl_s2UY"],
                          ['Text', ' '],
                          ['Operator', '='],
                          ['Text', ' '],
                          ['Literal.String', "\"I am a \\\"String\\\"\"#"]
    end

    it 'should lex character literals' do
      core = "Main.main4 = GHC.Show.$wshowLitChar 'C'# Main.main5"

      assert_tokens_equal core,
                          ['Name.Function', 'Main.main4'],
                          ['Text', ' '],
                          ['Operator', '='],
                          ['Text', ' '],
                          ['Keyword.Type', 'GHC'], ['Punctuation', '.'], ['Keyword.Type', 'Show'], ['Punctuation', '.'], ['Name.Variable', '$wshowLitChar'],
                          ['Text', ' '],
                          ['Literal.String.Char', "'C'#"],
                          ['Text', ' '],
                          ['Keyword.Type', 'Main'], ['Punctuation', '.'], ['Name.Variable', 'main5']
    end

    it 'should lex recursive bindings' do
      core = 'Rec {

end Rec }'

      assert_tokens_equal core,
                          ['Keyword', 'Rec'],
                          ['Text', ' '],
                          ['Punctuation', '{'],
                          ['Text', "\n\n"],
                          ['Keyword', 'end'],
                          ['Text', ' '],
                          ['Keyword', 'Rec'],
                          ['Text', ' '],
                          ['Punctuation', '}']
    end

    it 'should lex GHC rules' do
      core = '"SPEC $c== @ Integer"
    forall ($dEq_s61e :: Eq Integer).
      GHC.Real.$fEqRatio_$c== @ Integer $dEq_s61e
      = GHC.Real.$fEqRatio_$s$c=='

      assert_tokens_equal core,
                          ['Name.Label', "\"SPEC $c== @ Integer\""],
                          ['Text', "\n    "],
                          ['Keyword', 'forall'],
                          ['Text', ' '],
                          ['Punctuation', '('],
                          ['Name.Variable', '$dEq_s61e'],
                          ['Text', ' '],
                          ['Operator', '::'],
                          ['Text', ' '],
                          ['Keyword.Type', 'Eq'],
                          ['Text', ' '],
                          ['Keyword.Type', 'Integer'],
                          ['Punctuation', ').'],
                          ['Text', "\n      "],
                          ['Keyword.Type', 'GHC'], ['Punctuation', '.'], ['Keyword.Type', 'Real'], ['Punctuation', '.'], ['Name.Variable', '$fEqRatio_$c=='],
                          ['Text', ' '],
                          ['Operator', '@'],
                          ['Text', ' '],
                          ['Keyword.Type', 'Integer'],
                          ['Text', ' '],
                          ['Name.Variable', '$dEq_s61e'],
                          ['Text', "\n      "],
                          ['Operator', '='],
                          ['Text', ' '],
                          ['Keyword.Type', 'GHC'], ['Punctuation', '.'], ['Keyword.Type', 'Real'], ['Punctuation', '.'], ['Name.Variable', '$fEqRatio_$s$c==']
    end

    it 'should lex names with numbers' do
      core = 'Main.main1
  = ghc-prim-0.5.3:GHC.Types.: @ Char GHC.Show.$fShow(,)3 Main.main2'

      assert_tokens_equal core,
                          ['Name.Function', 'Main.main1'],
                          ['Text', "\n  "],
                          ['Operator', '='],
                          ['Text', " "],
                          ['Name.Namespace', 'ghc-prim-0.5.3'],
                          ['Punctuation', ':'],
                          ['Keyword.Type', 'GHC'], ['Punctuation', '.'], ['Keyword.Type', 'Types'], ['Punctuation', '.'], ['Name.Variable', ':'],
                          ['Text', ' '],
                          ['Operator', '@'],
                          ['Text', " "],
                          ['Keyword.Type', 'Char'],
                          ['Text', " "],
                          ['Keyword.Type', 'GHC'], ['Punctuation', '.'], ['Keyword.Type', 'Show'], ['Punctuation', '.'], ['Name.Variable', '$fShow(,)3'],
                          ['Text', " "],
                          ['Keyword.Type', 'Main'], ['Punctuation', '.'], ['Name.Variable', 'main2']
    end

    it 'should lex array types' do
      core = 'Main.main5 :: [Char]'

      assert_tokens_equal core,
                          ['Name.Function', 'Main.main5'],
                          ['Text', ' '],
                          ['Operator', '::'],
                          ['Text', ' '],
                          ['Keyword.Type', '[Char]']
    end
  end
end
