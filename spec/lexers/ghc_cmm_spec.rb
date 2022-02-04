# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::GHCCmm do
  let(:subject) { Rouge::Lexers::GHCCmm.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'Main.cmm'
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
                          ['Keyword', 'section'],
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
                          ['Keyword', 'section'],
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
                          ['Name.Namespace', 'Main'], ['Punctuation', '.'], ['Name.Function', 'fib_fib_entry'],
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
                          ['Keyword', 'section'],
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

    it 'should lex handwritten sections' do
      core = 'section "data" {
  no_break_on_exception: W_[1];
}'

      assert_tokens_equal core,
                          ['Keyword', 'section'],
                          ['Text', ' '],
                          ['Name.Builtin', '"data"'],
                          ['Text', ' '],
                          ['Punctuation', '{'],
                          ['Text', "\n  "],
                          ['Name.Label', 'no_break_on_exception'],
                          ['Punctuation', ':'],
                          ['Text', ' '],
                          ['Keyword.Type', 'W_'],
                          ['Punctuation', '['],
                          ['Literal.Number.Integer', '1'],
                          ['Punctuation', '];'],
                          ['Text', "\n"],
                          ['Punctuation', '}']
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
                          ['Name.Namespace', 'GHC'], ['Punctuation', '.'], ['Name.Namespace', 'Integer'], ['Punctuation', '.'], ['Name.Namespace', 'Type'], ['Punctuation', '.'], ['Name.Function', 'eqInteger#_info'],
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
      core = 'offset
'

      assert_tokens_equal core, ['Keyword', 'offset'], ['Text', "\n"]
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
                          ['Name.Function', 'Sp_adj'],
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

    it 'should lex #if' do
      core = '#if defined(__PIC__)
import pthread_mutex_lock;
import pthread_mutex_unlock;
#endif'

      assert_tokens_equal core,
                          ['Comment.Preproc', '#if'],
                          ['Text', ' '],
                          ['Name.Function', 'defined'],
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

    it 'should lex a simple #define statement' do
      core = '#define BA_ALIGN 16'

      assert_tokens_equal core,
                          ['Comment.Preproc', '#define'],
                          ['Text', ' '],
                          ['Name.Label', 'BA_ALIGN'],
                          ['Text', ' '],
                          ['Literal.Number.Integer', '16']
    end

    it 'should lex a simple #define statement with comment' do
      core = '#define /* comment */ BA_ALIGN /* comment */ 16'

      assert_tokens_equal core,
                          ['Comment.Preproc', '#define'],
                          ['Text', ' '],
                          ['Comment.Multiline', '/* comment */'],
                          ['Text', ' '],
                          ['Name.Label', 'BA_ALIGN'],
                          ['Text', ' '],
                          ['Comment.Multiline', '/* comment */'],
                          ['Text', ' '],
                          ['Literal.Number.Integer', '16']
    end

    it 'should lex a #define statement with an expression' do
      core = '#define BA_MASK  (BA_ALIGN-1)'

      assert_tokens_equal core,
                          ['Comment.Preproc', '#define'],
                          ['Text', ' '],
                          ['Name.Label', 'BA_MASK'],
                          ['Text', '  '],
                          ['Punctuation', '('],
                          ['Name.Label', 'BA_ALIGN'],
                          ['Literal.Number.Integer', '-1'],
                          ['Punctuation', ')']
    end

    it 'should lex functions with comments' do
      core = '/* comment */ stg_isEmptyMVarzh /* comment */ ( /* comment */ P_ mvar /* comment */ ) // single line comment
{'
      assert_tokens_equal core,
                          ['Comment.Multiline', '/* comment */'],
                          ['Text', ' '],
                          ['Name.Function', 'stg_isEmptyMVarzh'],
                          ['Text', ' '],
                          ['Comment.Multiline', '/* comment */'],
                          ['Text', ' '],
                          ['Punctuation', '('],
                          ['Text', ' '],
                          ['Comment.Multiline', '/* comment */'],
                          ['Text', ' '],
                          ['Keyword.Type', 'P_'],
                          ['Text', ' '],
                          ['Name.Label', 'mvar'],
                          ['Text', ' '],
                          ['Comment.Multiline', '/* comment */'],
                          ['Text', ' '],
                          ['Punctuation', ')'],
                          ['Text', ' '],
                          ['Comment.Single', '// single line comment'],
                          ['Text', "\n"],
                          ['Punctuation', '{']
    end

    it 'should lex functions and return statements' do
      core = 'stg_isEmptyMVarzh ( P_ mvar /* :: MVar a */ )
{
    if (StgMVar_value(mvar) == stg_END_TSO_QUEUE_closure) {
        return (1);
    } else {
        return (0);
    }
}'
      assert_tokens_equal core,
                          ['Name.Function', 'stg_isEmptyMVarzh'],
                          ['Text', ' '],
                          ['Punctuation', '('],
                          ['Text', ' '],
                          ['Keyword.Type', 'P_'],
                          ['Text', ' '],
                          ['Name.Label', 'mvar'],
                          ['Text', ' '],
                          ['Comment.Multiline', '/* :: MVar a */'],
                          ['Text', ' '],
                          ['Punctuation', ')'],
                          ['Text', "\n"],
                          ['Punctuation', '{'],
                          ['Text', "\n    "],
                          ['Keyword', 'if'],
                          ['Text', ' '],
                          ['Punctuation', '('],
                          ['Name.Function', 'StgMVar_value'],
                          ['Punctuation', '('],
                          ['Name.Label', 'mvar'],
                          ['Punctuation', ')'],
                          ['Text', ' '],
                          ['Operator', '=='],
                          ['Text', ' '],
                          ['Name.Label', 'stg_END_TSO_QUEUE_closure'],
                          ['Punctuation', ')'],
                          ['Text', ' '],
                          ['Punctuation', '{'],
                          ['Text', "\n        "],
                          ['Keyword', 'return'],
                          ['Text', ' '],
                          ['Punctuation', '('],
                          ['Literal.Number.Integer', '1'],
                          ['Punctuation', ');'],
                          ['Text', "\n    "],
                          ['Punctuation', '}'],
                          ['Text', ' '],
                          ['Keyword', 'else'],
                          ['Text', ' '],
                          ['Punctuation', '{'],
                          ['Text', "\n        "],
                          ['Keyword', 'return'],
                          ['Text', ' '],
                          ['Punctuation', '('],
                          ['Literal.Number.Integer', '0'],
                          ['Punctuation', ');'],
                          ['Text', "\n    "],
                          ['Punctuation', '}'],
                          ['Text', "\n"],
                          ['Punctuation', '}']
    end

    it 'should lex ccall' do
      core = 'ccall runCFinalizers(list);'

      assert_tokens_equal core,
                          ['Keyword', 'ccall'],
                          ['Text', ' '],
                          ['Name.Function', 'runCFinalizers'],
                          ['Punctuation', '('],
                          ['Name.Label', 'list'],
                          ['Punctuation', ');']
    end

    it 'should lex jump' do
      core = 'jump stg_yield_noregs();'

      assert_tokens_equal core,
                          ['Keyword', 'jump'],
                          ['Text', ' '],
                          ['Name.Function', 'stg_yield_noregs'],
                          ['Punctuation', '();']
    end

    it 'should lex foreign calls' do
      core = '(len) = foreign "C" heap_view_closureSize(UNTAG(clos) "ptr");'

      assert_tokens_equal core,
                          ['Punctuation', '('],
                          ['Name.Label', 'len'],
                          ['Punctuation', ')'],
                          ['Text', ' '],
                          ['Operator', '='],
                          ['Text', ' '],
                          ['Keyword', 'foreign'],
                          ['Text', ' '],
                          ['Literal.String.Delimiter', '"'],
                          ['Literal.String', 'C'],
                          ['Literal.String.Delimiter', '"'],
                          ['Text', ' '],
                          ['Name.Function', 'heap_view_closureSize'],
                          ['Punctuation', '('],
                          ['Name.Function', 'UNTAG'],
                          ['Punctuation', '('],
                          ['Name.Label', 'clos'],
                          ['Punctuation', ')'],
                          ['Text', ' '],
                          ['Literal.String.Delimiter', '"'],
                          ['Literal.String', 'ptr'],
                          ['Literal.String.Delimiter', '"'],
                          ['Punctuation', ');']
    end

    it 'should lex prim calls' do
      core = 'prim %memcpy(BYTE_ARR_CTS(new_mba), BYTE_ARR_CTS(mba),
             StgArrBytes_bytes(mba), SIZEOF_W);'

      assert_tokens_equal core,
                          ['Keyword', 'prim'],
                          ['Text', ' '],
                          ['Name.Builtin', '%memcpy'],
                          ['Punctuation', '('],
                          ['Name.Function', 'BYTE_ARR_CTS'],
                          ['Punctuation', '('],
                          ['Name.Label', 'new_mba'],
                          ['Punctuation', '),'],
                          ['Text', ' '],
                          ['Name.Function', 'BYTE_ARR_CTS'],
                          ['Punctuation', '('],
                          ['Name.Label', 'mba'],
                          ['Punctuation', '),'],
                          ['Text', "\n             "],
                          ['Name.Function', 'StgArrBytes_bytes'],
                          ['Punctuation', '('],
                          ['Name.Label', 'mba'],
                          ['Punctuation', '),'],
                          ['Text', ' '],
                          ['Name.Label', 'SIZEOF_W'],
                          ['Punctuation', ');']
    end

    it 'should lex switch statements and .. operators' do
      core = 'switch [INVALID_OBJECT .. N_CLOSURE_TYPES]
        (TO_W_( %INFO_TYPE(%STD_INFO(info)) )) {
        case
            IND,
            IND_STATIC:
        {
            fun = StgInd_indirectee(fun);
            goto again;
        }
        default:
        {
            jump %ENTRY_CODE(info) (UNTAG(fun));
        }
    }'

      assert_tokens_equal core,
                          ['Keyword', 'switch'],
                          ['Text', ' '],
                          ['Punctuation', '['],
                          ['Name.Label', 'INVALID_OBJECT'],
                          ['Text', ' '],
                          ['Operator', '..'],
                          ['Text', ' '],
                          ['Name.Label', 'N_CLOSURE_TYPES'],
                          ['Punctuation', ']'],
                          ['Text', "\n        "],
                          ['Punctuation', '('],
                          ['Name.Function', 'TO_W_'],
                          ['Punctuation', '('],
                          ['Text', ' '],
                          ['Name.Builtin', '%INFO_TYPE'],
                          ['Punctuation', '('],
                          ['Name.Builtin', '%STD_INFO'],
                          ['Punctuation', '('],
                          ['Name.Label', 'info'],
                          ['Punctuation', '))'],
                          ['Text', ' '],
                          ['Punctuation', '))'],
                          ['Text', ' '],
                          ['Punctuation', '{'],
                          ['Text', "\n        "],
                          ['Keyword', 'case'],
                          ['Text', "\n            "],
                          ['Name.Label', 'IND'],
                          ['Punctuation', ','],
                          ['Text', "\n            "],
                          ['Name.Label', 'IND_STATIC'],
                          ['Punctuation', ':'],
                          ['Text', "\n        "],
                          ['Punctuation', '{'],
                          ['Text', "\n            "],
                          ['Name.Label', 'fun'],
                          ['Text', ' '],
                          ['Operator', '='],
                          ['Text', ' '],
                          ['Name.Function', 'StgInd_indirectee'],
                          ['Punctuation', '('],
                          ['Name.Label', 'fun'],
                          ['Punctuation', ');'],
                          ['Text', "\n            "],
                          ['Keyword', 'goto'],
                          ['Text', ' '],
                          ['Name.Label', 'again'],
                          ['Punctuation', ';'],
                          ['Text', "\n        "],
                          ['Punctuation', '}'],
                          ['Text', "\n        "],
                          ['Keyword', 'default'],
                          ['Punctuation', ':'],
                          ['Text', "\n        "],
                          ['Punctuation', '{'],
                          ['Text', "\n            "],
                          ['Keyword', 'jump'],
                          ['Text', ' '],
                          ['Name.Builtin', '%ENTRY_CODE'],
                          ['Punctuation', '('],
                          ['Name.Label', 'info'],
                          ['Punctuation', ')'],
                          ['Text', ' '],
                          ['Punctuation', '('],
                          ['Name.Function', 'UNTAG'],
                          ['Punctuation', '('],
                          ['Name.Label', 'fun'],
                          ['Punctuation', '));'],
                          ['Text', "\n        "],
                          ['Punctuation', '}'],
                          ['Text', "\n    "],
                          ['Punctuation', '}']
    end

    it 'should lex switch statements with two expressions' do
      core = 'switch [0 .. N_CLOSURE_TYPES] type {'

      assert_tokens_equal core,
                          ['Keyword', 'switch'],
                          ['Text', ' '],
                          ['Punctuation', '['],
                          ['Literal.Number.Integer', '0'],
                          ['Text', ' '],
                          ['Operator', '..'],
                          ['Text', ' '],
                          ['Name.Label', 'N_CLOSURE_TYPES'],
                          ['Punctuation', ']'],
                          ['Text', ' '],
                          ['Name.Label', 'type'],
                          ['Text', ' '],
                          ['Punctuation', '{']
    end

    it 'should lex a "never returns" ccall' do
      core = 'ccall barf("PAP object (%p) entered!", R1) never returns;'

      assert_tokens_equal core,
                          ['Keyword', 'ccall'],
                          ['Text', ' '],
                          ['Name.Function', 'barf'],
                          ['Punctuation', '('],
                          ['Literal.String.Delimiter', '"'],
                          ['Literal.String', 'PAP object ('],
                          ['Literal.String.Symbol', '%p'],
                          ['Literal.String', ') entered!'],
                          ['Literal.String.Delimiter', '"'],
                          ['Punctuation', ','],
                          ['Text', ' '],
                          ['Name.Variable.Global', 'R1'],
                          ['Punctuation', ')'],
                          ['Text', ' '],
                          ['Keyword', 'never'],
                          ['Text', ' '],
                          ['Keyword', 'returns'],
                          ['Punctuation', ';']
    end

    it 'should lex type annotations' do
      core = '0::CBool'

      assert_tokens_equal core,
                          ['Literal.Number.Integer', '0'],
                          ['Operator', '::'],
                          ['Keyword.Type', 'CBool']
    end

    it 'should lex unwind' do
      core = 'unwind Sp = Sp + WDS(1);'

      assert_tokens_equal core,
                          ['Keyword', 'unwind'],
                          ['Text', ' '],
                          ['Name.Variable.Global', 'Sp'],
                          ['Text', ' '],
                          ['Operator', '='],
                          ['Text', ' '],
                          ['Name.Variable.Global', 'Sp'],
                          ['Text', ' '],
                          ['Operator', '+'],
                          ['Text', ' '],
                          ['Name.Function', 'WDS'],
                          ['Punctuation', '('],
                          ['Literal.Number.Integer', '1'],
                          ['Punctuation', ');']
    end

    it 'should lex functions with explicit stack handling' do
      core = 'stg_maskAsyncExceptionszh /* explicit stack */
{'

      assert_tokens_equal core,
                          ['Name.Function', 'stg_maskAsyncExceptionszh'],
                          ['Text', ' '],
                          ['Comment.Multiline', '/* explicit stack */'],
                          ['Text', "\n"],
                          ['Punctuation', '{']
    end

    it 'should lex functions with explicit stack handling and multiline comment' do
      core = 'stg_raisezh
/*
 * comment
 */
{'

      assert_tokens_equal core,
                          ['Name.Function', 'stg_raisezh'],
                          ['Text', "\n"],
                          ['Comment.Multiline', "/*\n * comment\n */"],
                          ['Text', "\n"],
                          ['Punctuation', '{']
    end

    it 'should lex functions that are prefixed with % as builtin' do
      core = 'jump %GET_ENTRY(UNTAG(R1)) [R1];'

      assert_tokens_equal core,
                          ['Keyword', 'jump'],
                          ['Text', ' '],
                          ['Name.Builtin', '%GET_ENTRY'],
                          ['Punctuation', '('],
                          ['Name.Function', 'UNTAG'],
                          ['Punctuation', '('],
                          ['Name.Variable.Global', 'R1'],
                          ['Punctuation', '))'],
                          ['Text', ' '],
                          ['Punctuation', '['],
                          ['Name.Variable.Global', 'R1'],
                          ['Punctuation', '];']
    end

    it 'should lex typed memory accesses' do
      core = 'Sp(i) = W_[p];'

      assert_tokens_equal core,
                          ['Name.Variable.Global', 'Sp'],
                          ['Punctuation', '('],
                          ['Name.Label', 'i'],
                          ['Punctuation', ')'],
                          ['Text', ' '],
                          ['Operator', '='],
                          ['Text', ' '],
                          ['Keyword.Type', 'W_'],
                          ['Punctuation', '['],
                          ['Name.Label', 'p'],
                          ['Punctuation', '];']
    end

    it 'should lex return' do
      core = 'return(h);'

      assert_tokens_equal core,
                          ['Keyword', 'return'],
                          ['Punctuation', '('],
                          ['Name.Label', 'h'],
                          ['Punctuation', ');']

      core = 'return ();'

      assert_tokens_equal core,
                          ['Keyword', 'return'],
                          ['Text', ' '],
                          ['Punctuation', '();']
    end

    it 'should lex literal floating point numbers' do
      core = 'const 1.5 :: W64;'

      assert_tokens_equal core,
                          ['Keyword.Constant', 'const'],
                          ['Text', ' '],
                          ['Literal.Number.Float', '1.5'],
                          ['Text', ' '],
                          ['Operator', '::'],
                          ['Text', ' '],
                          ['Keyword.Type', 'W64'],
                          ['Punctuation', ';']
    end

    it 'should lex names in statements correctly' do
      core = 'R4 = GHC.Types.True_closure+2;'

      assert_tokens_equal core,
                          ['Name.Variable.Global', 'R4'],
                          ['Text', ' '],
                          ['Operator', '='],
                          ['Text', ' '],
                          ['Name.Namespace', 'GHC'],
                          ['Punctuation', '.'],
                          ['Name.Namespace', 'Types'],
                          ['Punctuation', '.'],
                          ['Name.Label', 'True_closure'],
                          ['Operator', '+'],
                          ['Literal.Number.Integer', '2'],
                          ['Punctuation', ';']
    end

    it 'should lex info_tbls' do
      core =
          '{ info_tbls: [(c3zg,
  label: Main.string_info
  rep: HeapRep static { Thunk }
  srt: Nothing)]
  stack_info: arg_space: 8 updfr_space: Just 8
}'
      assert_tokens_equal core,
                          ['Punctuation', '{ '],
                          ['Name.Entity', 'info_tbls'],
                          ['Punctuation', ':'],
                          ['Text', ' '],
                          ['Punctuation', '[('],
                          ['Name.Label', 'c3zg'],
                          ['Punctuation', ','],
                          ['Text', "\n  "],
                          ['Name.Property', 'label'],
                          ['Punctuation', ':'],
                          ['Text', ' '],
                          ['Name.Namespace', 'Main'],
                          ['Punctuation', '.'],
                          ['Name.Label', 'string_info'],
                          ['Text', "\n  "],
                          ['Name.Property', 'rep'],
                          ['Punctuation', ':'],
                          ['Text', ' HeapRep static '],
                          ['Punctuation', '{'],
                          ['Text', ' Thunk '],
                          ['Punctuation', '}'],
                          ['Text', "\n  "],
                          ['Name.Property', 'srt'],
                          ['Punctuation', ':'],
                          ['Text', ' Nothing'],
                          ['Punctuation', ')]'],
                          ['Text', "\n  "],
                          ['Name.Entity', 'stack_info'],
                          ['Punctuation', ':'],
                          ['Text', ' '],
                          ['Name.Property', 'arg_space'],
                          ['Punctuation', ':'],
                          ['Text', ' '],
                          ['Literal.Number.Integer', '8'],
                          ['Text', ' '],
                          ['Name.Property', 'updfr_space'],
                          ['Punctuation', ':'],
                          ['Text', ' Just '],
                          ['Literal.Number.Integer', '8'],
                          ['Text', "\n"],
                          ['Punctuation', '}']
    end

    it 'should lex a ccall with hints' do
      core = '(_c3zB::I64) = call "ccall" arg hints:  [PtrHint, PtrHint]  result hints:  [PtrHint] newCAF(BaseReg, R1);'

      assert_tokens_equal core,
                          ['Punctuation', '('],
                          ['Name.Label', '_c3zB'],
                          ['Operator', '::'],
                          ['Keyword.Type', 'I64'],
                          ['Punctuation', ')'],
                          ['Text', ' '],
                          ['Operator', '='],
                          ['Text', ' '],
                          ['Keyword', 'call'],
                          ['Text', ' '],
                          ['Literal.String.Delimiter', '"'],
                          ['Literal.String', 'ccall'],
                          ['Literal.String.Delimiter', '"'],
                          ['Text', ' '],
                          ['Name.Property', 'arg'],
                          ['Text', ' '],
                          ['Name.Property', 'hints'],
                          ['Punctuation', ':'],
                          ['Text', '  '],
                          ['Punctuation', '['],
                          ['Name.Label', 'PtrHint'],
                          ['Punctuation', ','],
                          ['Text', ' '],
                          ['Name.Label', 'PtrHint'],
                          ['Punctuation', ']'],
                          ['Text', '  '],
                          ['Name.Property', 'result'],
                          ['Text', ' '],
                          ['Name.Property', 'hints'],
                          ['Punctuation', ':'],
                          ['Text', '  '],
                          ['Punctuation', '['],
                          ['Name.Label', 'PtrHint'],
                          ['Punctuation', ']'],
                          ['Text', ' '],
                          ['Name.Function', 'newCAF'],
                          ['Punctuation', '('],
                          ['Name.Variable.Global', 'BaseReg'],
                          ['Punctuation', ','],
                          ['Text', ' '],
                          ['Name.Variable.Global', 'R1'],
                          ['Punctuation', ');']
    end

    it 'should lex escaped newlines' do
      core = '#define SELECTOR_CODE_NOUPD(offset)                                     \
'
      assert_tokens_equal core,
                          ['Comment.Preproc', '#define'],
                          ['Text', ' '],
                          ['Name.Label', 'SELECTOR_CODE_NOUPD'],
                          ['Punctuation', '('],
                          ['Name.Label', 'offset'],
                          ['Punctuation', ')'],
                          ['Text', "                                     \\\n"]
    end

    it 'should respect #define when it lexes types' do
      core = '#define Char_hash_con_info _imp__ghczmprim_GHCziTypes_Czh_con_info
#define Int_hash_con_info _imp__ghczmprim_GHCziTypes_Izh_con_info'

      assert_tokens_equal core,
                          ['Comment.Preproc', '#define'],
                          ['Text', ' '],
                          ['Name.Label', 'Char_hash_con_info'],
                          ['Text', ' '],
                          ['Name.Label', '_imp__ghczmprim_GHCziTypes_Czh_con_info'],
                          ['Text', "\n"],
                          ['Comment.Preproc', '#define'],
                          ['Text', ' '],
                          ['Name.Label', 'Int_hash_con_info'],
                          ['Text', ' '],
                          ['Name.Label', '_imp__ghczmprim_GHCziTypes_Izh_con_info']
    end

    it 'should respect functions when it lexes types' do
      core = 'SAVE_STGREGS
SAVE_THREAD_STATE();'

      assert_tokens_equal core,
                          ['Name.Label', 'SAVE_STGREGS'],
                          ['Text', "\n"],
                          ['Name.Function', 'SAVE_THREAD_STATE'],
                          ['Punctuation', '();']
    end

    it 'should lex inline function calls' do
      core = 'StgTSO_alloc_limit(CurrentTSO) `lt` (0::I64)'

      assert_tokens_equal core,
                          ['Name.Function', 'StgTSO_alloc_limit'],
                          ['Punctuation', '('],
                          ['Name.Variable.Global', 'CurrentTSO'],
                          ['Punctuation', ')'],
                          ['Text', ' '],
                          ['Punctuation', '`'],
                          ['Name.Function', 'lt'],
                          ['Punctuation', '`'],
                          ['Text', ' '],
                          ['Punctuation', '('],
                          ['Literal.Number.Integer', '0'],
                          ['Operator', '::'],
                          ['Keyword.Type', 'I64'],
                          ['Punctuation', ')']
    end

    it 'should lex <highSp> (codegen variables)' do
      core = '<highSp>'

      assert_tokens_equal core,
                          ['Name.Builtin', '<highSp>']
    end

    it 'should lex special character ids in names with module prefix' do
      core = 'GHC.Tuple.()_closure+1;'

      assert_tokens_equal core,
                          ['Name.Namespace', 'GHC'],
                          ['Punctuation', '.'],
                          ['Name.Namespace', 'Tuple'],
                          ['Punctuation', '.'],
                          ['Name.Label', '()_closure'],
                          ['Operator', '+'],
                          ['Literal.Number.Integer', '1'],
                          ['Punctuation', ';']
    end

    it 'should lex complex function names' do
      core = 'foo()_(1);'

      assert_tokens_equal core,
                          ['Name.Function', 'foo()_'],
                          ['Punctuation', '('],
                          ['Literal.Number.Integer', '1'],
                          ['Punctuation', ');']
    end

    it 'should lex complex function names' do
      core = 'foo()_(1);'

      assert_tokens_equal core,
                          ['Name.Function', 'foo()_'],
                          ['Punctuation', '('],
                          ['Literal.Number.Integer', '1'],
                          ['Punctuation', ');']

      core = 'foo(,)3_(1);'

      assert_tokens_equal core,
                          ['Name.Function', 'foo(,)3_'],
                          ['Punctuation', '('],
                          ['Literal.Number.Integer', '1'],
                          ['Punctuation', ');']

      core = '()_closure+1;'

      assert_tokens_equal core,
                          ['Name.Label', '()_closure'],
                          ['Operator', '+'],
                          ['Literal.Number.Integer', '1'],
                          ['Punctuation', ';']
    end

    it 'should lex complex names in an expression' do
      core = 'const GHC.Types.[]_closure+1;'

      assert_tokens_equal core,
                          ['Keyword.Constant', 'const'],
                          ['Text', ' '],
                          ['Name.Namespace', 'GHC'],
                          ['Punctuation', '.'],
                          ['Name.Namespace', 'Types'],
                          ['Punctuation', '.'],
                          ['Name.Label', '[]_closure'],
                          ['Operator', '+'],
                          ['Literal.Number.Integer', '1'],
                          ['Punctuation', ';']

      core = 'R1 = ()_closure+1;'

      assert_tokens_equal core,
                          ['Name.Variable.Global', 'R1'],
                          ['Text', ' '],
                          ['Operator', '='],
                          ['Text', ' '],
                          ['Name.Label', '()_closure'],
                          ['Operator', '+'],
                          ['Literal.Number.Integer', '1'],
                          ['Punctuation', ';']
    end
  end
end
