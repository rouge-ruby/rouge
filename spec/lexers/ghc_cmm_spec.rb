# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::GHCCmm do
  let(:subject) { Rouge::Lexers::GHCCmm.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'Main.dump-cmm'
      assert_guess :filename => 'Main.dump-cmm-switch'
      assert_guess :filename => 'Main.dump-cmm-sp'
      assert_guess :filename => 'Main.dump-cmm-sink'
      assert_guess :filename => 'Main.dump-cmm-raw'
      assert_guess :filename => 'Main.dump-cmm-info'
      assert_guess :filename => 'Main.dump-cmm-from-stg'
      assert_guess :filename => 'Main.dump-cmm-cps'
      assert_guess :filename => 'Main.dump-cmm-cfg'
      assert_guess :filename => 'Main.dump-cmm-cbe'
      assert_guess :filename => 'Main.dump-cmm-caf'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'should lex section markers as headings' do
      core = '==================== Output Cmm ===================='
      assert_tokens_equal core, ['Generic.Heading', core]
    end

    it 'should lex timestamps as comments' do
      core = '2019-12-24 13:23:29.666399 UTC'
      assert_tokens_equal core, ['Comment.Single', core]
    end

    it 'should lex brackets as punctuation' do
      core = '[]'
      assert_tokens_equal core, ['Punctuation', '[]']
    end

    it 'should lex a simple section' do
      core = '[section ""data" . Main.fib1_closure" {
     Main.fib1_closure:
         const GHC.Integer.Type.S#_con_info;
         const 0;
 }]'

      assert_tokens_equal core,
                          ['Punctuation', '['],
                          ['Keyword.Reserved', 'section'],
                          ['Text', ' '],
                          ['Literal.String.Double', '"'],
                          ['Name.Builtin', '"data"'],
                          ['Text', ' '],
                          ['Punctuation', '.'],
                          ['Text', ' '],
                          ['Name.Namespace', 'Main'], ['Punctuation', '.'], ['Name.Label', 'fib1_closure'],
                          ['Literal.String.Double', '"'],
                          ['Text', ' '],
                          ['Punctuation', '{'],
                          ['Text', "\n     "],
                          ['Name.Namespace', 'Main'], ['Punctuation', '.'], ['Name.Label', 'fib1_closure'],
                          ['Punctuation', ':'],
                          ['Text', "\n         "],
                          ['Keyword.Reserved', 'const'],
                          ['Text', ' '],
                          ['Name.Namespace', 'GHC'], ['Punctuation', '.'], ['Name.Namespace', 'Integer'], ['Punctuation', '.'], ['Name.Namespace', 'Type'], ['Punctuation', '.'], ['Name.Label', 'S#_con_info'],
                          ['Punctuation', ';'],
                          ['Text', "\n         "],
                          ['Keyword.Reserved', 'const'],
                          ['Text', ' '],
                          ['Literal.Number.Integer', '0'],
                          ['Punctuation', ';'],
                          ['Text', "\n "],
                          ['Punctuation', '}]']
    end

    it 'should lex sections with function definitions' do
      core = '[section ""data" . u4uh_srt" {
     u4uh_srt:
         const stg_SRT_1_info;
         const GHC.Integer.Type.plusInteger_closure;
         const 0;
 },
 Main.fib_fib_entry() //  [R2]'

      assert_tokens_equal core,
                          ['Punctuation', '['],
                          ['Keyword.Reserved', 'section'],
                          ['Text', ' '],
                          ['Literal.String.Double', '"'],
                          ['Name.Builtin', '"data"'],
                          ['Text', ' '],
                          ['Punctuation', '.'],
                          ['Text', ' '],
                          ['Name.Label', 'u4uh_srt'],
                          ['Literal.String.Double', '"'],
                          ['Text', ' '],
                          ['Punctuation', '{'],

                          ['Text', "\n     "],
                          ['Name.Label', 'u4uh_srt'],
                          ['Punctuation', ':'],
                          ['Text', "\n         "],
                          ['Keyword.Reserved', 'const'],
                          ['Text', ' '],
                          ['Name.Label', 'stg_SRT_1_info'],
                          ['Punctuation', ';'],

                          ['Text', "\n         "],
                          ['Keyword.Reserved', 'const'],
                          ['Text', ' '],
                          ['Name.Namespace', 'GHC'], ['Punctuation', '.'], ['Name.Namespace', 'Integer'], ['Punctuation', '.'], ['Name.Namespace', 'Type'], ['Punctuation', '.'], ['Name.Label', 'plusInteger_closure'],
                          ['Punctuation', ';'],

                          ['Text', "\n         "],
                          ['Keyword.Reserved', 'const'],
                          ['Text', ' '],
                          ['Literal.Number.Integer', '0'],
                          ['Punctuation', ';'],

                          ['Text', "\n "],
                          ['Punctuation', '},'],

                          ['Text', "\n "],
                          ['Name.Namespace', 'Main'], ['Punctuation', '.'], ['Name.Label', 'fib_fib_entry'],
                          ['Punctuation', '()'],
                          ['Text', ' '],
                          ['Comment.Single', '//  [R2]']
    end

    it 'should lex cstring sections' do
      core = '[section ""cstring" . Main.$trModule2_bytes" {
     Main.$trModule2_bytes:
         I8[] [77,97,105,110]
 }]'
      assert_tokens_equal core,
                          ['Punctuation', '['],
                          ['Keyword.Reserved', 'section'],
                          ['Text', ' '],
                          ['Literal.String.Double', '"'],
                          ['Name.Builtin', '"cstring"'],
                          ['Text', ' '],
                          ['Punctuation', '.'],
                          ['Text', ' '],
                          ['Name.Namespace', 'Main'], ['Punctuation', '.'], ['Name.Label', '$trModule2_bytes'],
                          ['Literal.String.Double', '"'],
                          ['Text', ' '],
                          ['Punctuation', '{'],
                          ['Text', "\n     "],
                          ['Name.Namespace', 'Main'], ['Punctuation', '.'], ['Name.Label', '$trModule2_bytes'],
                          ['Punctuation', ':'],
                          ['Text', "\n         "],
                          ['Keyword.Type', 'I8[]'],
                          ['Text', ' '],
                          ['Punctuation', '['],
                          ['Literal.Number.Integer', '77'],
                          ['Punctuation', ','],
                          ['Literal.Number.Integer', '97'],
                          ['Punctuation', ','],
                          ['Literal.Number.Integer', '105'],
                          ['Punctuation', ','],
                          ['Literal.Number.Integer', '110'],
                          ['Punctuation', ']'],
                          ['Text', "\n "],
                          ['Punctuation', '}]']
    end
  end
end


