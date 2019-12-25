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
                          ['Keyword.Constant', 'const'],
                          ['Text', ' '],
                          ['Name.Namespace', 'GHC'], ['Punctuation', '.'], ['Name.Namespace', 'Integer'], ['Punctuation', '.'], ['Name.Namespace', 'Type'], ['Punctuation', '.'], ['Name.Label', 'S#_con_info'],
                          ['Punctuation', ';'],
                          ['Text', "\n         "],
                          ['Keyword.Constant', 'const'],
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
                          ['Keyword.Constant', 'const'],
                          ['Text', ' '],
                          ['Name.Label', 'stg_SRT_1_info'],
                          ['Punctuation', ';'],

                          ['Text', "\n         "],
                          ['Keyword.Constant', 'const'],
                          ['Text', ' '],
                          ['Name.Namespace', 'GHC'], ['Punctuation', '.'], ['Name.Namespace', 'Integer'], ['Punctuation', '.'], ['Name.Namespace', 'Type'], ['Punctuation', '.'], ['Name.Label', 'plusInteger_closure'],
                          ['Punctuation', ';'],

                          ['Text', "\n         "],
                          ['Keyword.Constant', 'const'],
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

    it 'should lex operators and comparisons' do
      core = 'if ((Sp + -16) < SpLim) (likely: False) goto c4tE; else goto c4tF;'

      assert_tokens_equal core,
                          ['Keyword', 'if'],
                          ['Text', ' '],
                          ['Punctuation', '(('],
                          ['Name.Variable.Global', 'Sp'],
                          ['Text', ' '],
                          ['Operator', '+'],
                          ['Text', ' '],
                          ['Literal.Number.Integer', '-16'],
                          ['Punctuation', ')'],
                          ['Text', ' '],
                          ['Operator', '<'],
                          ['Text', ' '],
                          ['Name.Variable.Global', 'SpLim'],
                          ['Punctuation', ')'],
                          ['Text', ' '],
                          ['Comment', '(likely: False)'],
                          ['Text', ' '],
                          ['Keyword', 'goto'],
                          ['Text', ' '],
                          ['Name.Label', 'c4tE'],
                          ['Punctuation', ';'],
                          ['Text', ' '],
                          ['Keyword', 'else'],
                          ['Text', ' '],
                          ['Keyword', 'goto'],
                          ['Text', ' '],
                          ['Name.Label', 'c4tF'],
                          ['Punctuation', ';']
    end

    it 'should lex Hp and HpLim as global variables' do
      core = 'if (Hp > HpLim) (likely: False) goto c4vy; else goto c4vx;'

      assert_tokens_equal core,
                          ['Keyword', 'if'],
                          ['Text', ' '],
                          ['Punctuation', '('],
                          ['Name.Variable.Global', 'Hp'],
                          ['Text', ' '],
                          ['Operator', '>'],
                          ['Text', ' '],
                          ['Name.Variable.Global', 'HpLim'],
                          ['Punctuation', ')'],
                          ['Text', ' '],
                          ['Comment', '(likely: False)'],
                          ['Text', ' '],
                          ['Keyword', 'goto'],
                          ['Text', ' '],
                          ['Name.Label', 'c4vy'],
                          ['Punctuation', ';'],
                          ['Text', ' '],
                          ['Keyword', 'else'],
                          ['Text', ' '],
                          ['Keyword', 'goto'],
                          ['Text', ' '],
                          ['Name.Label', 'c4vx'],
                          ['Punctuation', ';']
    end

    it 'should lex registers as global variables' do
      core = 'R2 = R2;'

      assert_tokens_equal core,
                          ['Name.Variable.Global', 'R2'],
                          ['Text', ' '],
                          ['Operator', '='],
                          ['Text', ' '],
                          ['Name.Variable.Global', 'R2'],
                          ['Punctuation', ';']
    end

    it 'should lex calls' do
      core = 'call GHC.Integer.Type.eqInteger#_info(R3,
                     R2) returns to c4ty, args: 8, res: 8, upd: 8;'

      assert_tokens_equal core,
                          ['Keyword', 'call'],
                          ['Text', ' '],
                          ['Name.Namespace', 'GHC'], ['Punctuation', '.'], ['Name.Namespace', 'Integer'], ['Punctuation', '.'], ['Name.Namespace', 'Type'], ['Punctuation', '.'], ['Name.Label', 'eqInteger#_info'],
                          ['Punctuation', '('],
                          ['Name.Variable.Global', 'R3'],
                          ['Punctuation', ','],
                          ['Text', "\n                     "],
                          ['Name.Variable.Global', 'R2'],
                          ['Punctuation', ')'],
                          ['Text', ' '],
                          ['Keyword', 'returns'],
                          ['Text', ' '],
                          ['Keyword', 'to'],
                          ['Text', ' '],
                          ['Name.Label', 'c4ty'],
                          ['Punctuation', ','],
                          ['Text', ' '],
                          ['Name.Property', 'args'],
                          ['Punctuation', ':'],
                          ['Text', ' '],
                          ['Literal.Number.Integer', '8'],
                          ['Punctuation', ','],
                          ['Text', ' '],
                          ['Name.Property', 'res'],
                          ['Punctuation', ':'],
                          ['Text', ' '],
                          ['Literal.Number.Integer', '8'],
                          ['Punctuation', ','],
                          ['Text', ' '],
                          ['Name.Property', 'upd'],
                          ['Punctuation', ':'],
                          ['Text', ' '],
                          ['Literal.Number.Integer', '8'],
                          ['Punctuation', ';']
    end

    it 'should lex offset' do
      core = 'offset'

      assert_tokens_equal core, ['Keyword', 'offset']
    end

    it 'should lex array accesses' do
      core = 'I64[Sp] = c4tZ;'

      assert_tokens_equal core,
                          ['Keyword.Type', 'I64'],
                          ['Punctuation', '['],
                          ['Name.Variable.Global', 'Sp'],
                          ['Punctuation', ']'],
                          ['Text', ' '],
                          ['Operator', '='],
                          ['Text', ' '],
                          ['Name.Label', 'c4tZ'],
                          ['Punctuation', ';']

    end

    it 'should lex multi-line comments' do
      core = '/* for objects that are *less* than the size of a word, make sure we
 * round up to the nearest word for the size of the array.
 */'

      assert_tokens_equal core,
                          ['Comment.Multiline', core]
    end

    it 'should lex function calls that start with a register name "prefix"' do
      core = 'Sp_adj(-1);'

      assert_tokens_equal core,
                          ['Name.Label', 'Sp_adj'],
                          ['Punctuation', '('],
                          ['Literal.Number.Integer', '-1'],
                          ['Punctuation', ');']
    end

    it 'should lex #include' do
      core = '#include "Cmm.h"'

      assert_tokens_equal core,
                          ['Comment.Preproc', '#include'],
                          ['Text', ' '],
                          ['Literal.String.Delimiter', '"'],
                          ['Literal.String', 'Cmm.h'],
                          ['Literal.String.Delimiter', '"']
    end

    it 'should lex #if defined' do
      core = '#if defined(__PIC__)
import pthread_mutex_lock;
import pthread_mutex_unlock;
#endif'

      assert_tokens_equal core,
                          ['Comment.Preproc', '#if'],
                          ['Text', ' '],
                          ['Comment.Preproc', 'defined'],
                          ['Punctuation', '('],
                          ['Name.Label', '__PIC__'],
                          ['Punctuation', ')'],
                          ['Text', "\n"],
                          ['Keyword', 'import'],
                          ['Text', ' '],
                          ['Name.Label', 'pthread_mutex_lock'],
                          ['Punctuation', ';'],
                          ['Text', "\n"],
                          ['Keyword', 'import'],
                          ['Text', ' '],
                          ['Name.Label', 'pthread_mutex_unlock'],
                          ['Punctuation', ';'],
                          ['Text', "\n"],
                          ['Comment.Preproc', '#endif']
    end

    it 'should lex #else' do
      core = '#else'

      assert_tokens_equal core,
                          ['Comment.Preproc', '#else']
    end
  end
end


