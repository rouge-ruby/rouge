# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Nial do
    let(:subject) { Rouge::Lexers::Nial.new }

    describe 'guessing' do
        include Support::Guessing

        it 'guesses by filename' do
            assert_guess :filename => 'foo.ndf'
            assert_guess :filename => 'foo.nlg'
        end
    end

    describe 'lexing' do
        include Support::Lexing

        describe 'keywords' do
            it 'covers all keywords' do
                ["is", "gets", "op", "tr",
                "if", "then", "elseif", "else",
                "endif", "case", "from", "endcase",
                "begin", "end", "for", "with",
                "endfor", "while", "do", "endwhile",
                "repeat", "until", "endrepeat"].each do |kw|
                    assert_tokens_equal kw, ['Keyword', kw]
                end
            end
        end
        describe 'primitives' do
            it 'covers all operators' do
                [".",  "!", "#", "+", "*", "-", "<<",
                "/", "<", ">>", "<=", ">", "=", ">=", "@", "|", "~="].each do |op|
                    assert_tokens_equal op, ['Operator', op]
                end
            end

            it 'covers all stdlib functions' do
                ["operation", "expression", "and", "abs",
                    "allbools", "allints", "allchars", "allin",
                    "allreals", "allnumeric", "append",
                    "arcsin", "arccos", "appendfile", "apply",
                    "arctan", "atomic", "assign", "atversion",
                    "axes", "cart", "break", "blend", "breaklist",
                    "breakin", "bye", "callstack", "choose", "char",
                    "ceiling", "catenate", "charrep", "check_socket",
                    "cos", "content", "close", "clearws",
                    "clearprofile", "cols", "continue", "copyright",
                    "cosh", "cull", "count", "diverse", "deepplace",
                    "cutall", "cut", "display", "deparse",
                    "deepupdate", "descan", "depth", "diagram",
                    "div", "divide", "drop", "dropright", "edit",
                    "empty", "expression", "exit", "except", "erase",
                    "equal", "eval", "eraserecord", "execute", "exp",
                    "external", "exprs", "findall", "find",
                    "fault", "falsehood", "filestatus", "filelength",
                    "filepath", "filetally", "floor", "first",
                    "flip", "fuse", "fromraw", "front",
                    "gage", "getfile", "getdef", "getcommandline",
                    "getenv", "getname", "hitch", "grid", "getsyms",
                    "gradeup", "gt", "gte", "host", "in", "inverse",
                    "innerproduct", "inv", "ip", "ln", "link", "isboolean",
                    "isinteger", "ischar", "isfault", "isreal", "isphrase",
                    "isstring", "istruthvalue", "last", "laminate",
                    "like", "libpath", "library", "list", "load",
                    "loaddefs", "nonlocal", "max", "match", "log",
                    "lt", "lower", "lte", "mate", "min", "maxlength",
                    "mod", "mix", "minus", "nialroot", "mold", "not",
                    "numeric", "no_op", "no_expr", "notin",
                    "operation", "open", "or", "opposite", "opp",
                    "operators", "plus", "pick", "pack", "pass", "pair", "parse",
                    "paste", "phrase", "place", "picture", "placeall",
                    "power", "positions", "post", "quotient", "putfile",
                    "profile", "prod", "product", "profiletree",
                    "profiletable", "quiet_fault", "raise", "reach",
                    "random", "reciprocal", "read", "readfile",
                    "readchar", "readarray", "readfield",
                    "readscreen", "readrecord", "recip", "reshape",
                    "seek", "second", "rest", "reverse", "restart",
                    "return_status", "scan", "save", "rows", "rotate",
                    "seed", "see", "sublist", "sin", "simple", "shape",
                    "setformat", "setdeftrace", "set", "seeusercalls",
                    "seeprimcalls", "separator", "setwidth", "settrigger",
                    "setmessages", "setlogname", "setinterrupts",
                    "setprompt", "setprofile", "sinh", "single",
                    "sqrt", "solitary", "sketch", "sleep",
                    "socket_listen", "socket_accept", "socket_close",
                    "socket_bind", "socket_connect", "socket_getline",
                    "socket_receive", "socket_peek", "socket_read",
                    "socket_send", "socket_write", "solve", "split",
                    "sortup", "string", "status", "take", "symbols",
                    "sum", "system", "tan", "tally", "takeright",
                    "tanh", "tell", "times", "third", "time",
                    "toupper", "tolower", "timestamp", "tonumber",
                    "toraw", "toplevel", "transformer", "type",
                    "transpose",  "trs", "truth", "unequal",
                    "variable", "valence", "up", "updateall",
                    "update", "vacate", "value", "version", "vars",
                    "void", "watch", "watchlist", "write", "writechars",
                    "writearray", "writefile", "writefield",
                    "writescreen", "writerecord"].each do |func|
                    assert_tokens_equal func, ['Keyword.Pseudo', func]
                end
            end

            it 'covers all stdlib transformers' do
                ["accumulate", "across",
                    "bycols", "bykey",  "byrows",
                    "converse",  "down",
                    "eachboth", "eachall", "each",
                    "eachleft", "eachright",
                    "filter", "fold", "fork",
                    "grade",  "inner", "iterate",
                    "leaf",  "no_tr", "outer",
                    "partition", "rank", "recur",
                    "reduce", "reducecols", "reducerows",
                    "sort", "team", "timeit", "twig"].each do |transformer| 
                        assert_tokens_equal transformer, ['Name.Builtin', transformer]
                end
            end
            
            it 'covers all predefined constants' do
                %w(false null pi true).each do |constant|
                    assert_tokens_equal constant, ['Keyword.Constant', constant]
                end
            end
        end
        describe 'words' do
            it 'recognizes miscellaneous variable names' do
                assert_tokens_equal "hello", ['Name.Variable', "hello"]
                assert_tokens_equal "world", ['Name.Variable', "world"]
                assert_tokens_equal "foo_bar_baz1234", ['Name.Variable', "foo_bar_baz1234"]
            end
        end

        describe 'strings' do
            it 'recognizes single-quoted text' do
              assert_tokens_equal "'foo bar 12345á!#$@?'",
                ['Literal.String.Single', "'foo bar 12345á!#$@?'"]
            end
      
            it 'recognizes escape sequences' do
              assert_tokens_equal "'foo''bar'''",
                ['Literal.String.Single', "'foo"],
                ['Literal.String.Escape', "''"],
                ['Literal.String.Single', "bar"],
                ['Literal.String.Escape', "''"],
                ['Literal.String.Single', "'"]
            end

            it 'recognizes character literals' do
                assert_tokens_equal "`a", ["Literal.String.Char", "`a"]
                assert_tokens_equal "``", ["Literal.String.Char", "``"]
            end     
        end

        describe 'symbols' do
            it 'recognizes phrases' do
                assert_tokens_equal '"hello', ["Literal.String.Symbol", '"hello']
                assert_tokens_equal '"many""quotes""?fdfad"', ["Literal.String.Symbol", '"many""quotes""?fdfad"']
                assert_tokens_equal '"', ["Literal.String.Symbol", '"']
                assert_tokens_equal '"""""', ["Literal.String.Symbol", '"""""']
            end
            it 'recognizes faults' do
                assert_tokens_equal '?fault', ["Generic.Error", '?fault']
                assert_tokens_equal '?', ["Generic.Error", '?']
                assert_tokens_equal '???', ["Generic.Error", '???']
            end
        end

        describe 'numbers' do 
            it 'recognizes integers' do
                assert_tokens_equal '123', ["Literal.Number.Integer", '123']
                assert_tokens_equal '123 456', ["Literal.Number.Integer", '123'], ["Text", " "], ["Literal.Number.Integer", '456']
                assert_tokens_equal '456-789', ["Literal.Number.Integer", '456-789']
                assert_tokens_equal '416 -732', ["Literal.Number.Integer", '416'], ["Text", " "], ["Literal.Number.Integer", '-732']
            end
            it 'recognizes floats' do
                assert_tokens_equal '123.', ["Literal.Number.Float", '123.']
                assert_tokens_equal '12.56', ["Literal.Number.Float", '12.56']
                assert_tokens_equal '78e3', ["Literal.Number.Float", '78e3']
                assert_tokens_equal '78e+3', ["Literal.Number.Float", '78e+3']
                assert_tokens_equal '78e-3', ["Literal.Number.Float", '78e-3']
                assert_tokens_equal '90.4e3', ["Literal.Number.Float", '90.4e3']
                assert_tokens_equal '90.4e+30', ["Literal.Number.Float", '90.4e+30']
                assert_tokens_equal '90.4e-30', ["Literal.Number.Float", '90.4e-30']
                # same, except negative
                assert_tokens_equal '-123.', ["Literal.Number.Float", '-123.']
                assert_tokens_equal '-12.56', ["Literal.Number.Float", '-12.56']
                assert_tokens_equal '-78e3', ["Literal.Number.Float", '-78e3']
                assert_tokens_equal '-78e+3', ["Literal.Number.Float", '-78e+3']
                assert_tokens_equal '-78e-3', ["Literal.Number.Float", '-78e-3']
                assert_tokens_equal '-90.4e3', ["Literal.Number.Float", '-90.4e3']
                assert_tokens_equal '-90.4e+30', ["Literal.Number.Float", '-90.4e+30']
                assert_tokens_equal '-90.4e-30', ["Literal.Number.Float", '-90.4e-30']
            end
            it 'recognizes booleans' do
                assert_tokens_equal 'l', ['Literal.Number.Bin', 'l']
                assert_tokens_equal 'o', ['Literal.Number.Bin', 'o']
                assert_tokens_equal 'loololoolololollool', ['Literal.Number.Bin', 'loololoolololollool']
            end
        end


        describe 'comments' do
            it 'recognizes percentage comments' do
                assert_tokens_equal "% comment ;", ["Comment.Multiline", "% comment ;"]
                assert_tokens_equal "% more\nthan\none\nline ;", ["Comment.Multiline", "% more\nthan\none\nline ;"]
            end
            it 'recognizes hash comments' do
                assert_tokens_equal "# comment \n\n", ["Comment.Multiline", "# comment \n\n"]
                assert_tokens_equal "# more\nthan\none\nline \n\n", ["Comment.Multiline", "# more\nthan\none\nline \n\n"]
            end
        end
    end
end
