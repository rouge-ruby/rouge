module Rouge
  module Lexers
    class HyLang
      KEYWORDS = Set.new %w(
        False None True and as assert break class continue def
        del elif else except finally for from global if import
        in is lambda nonlocal not or pass raise return try
      )

      BUILTINS = Set.new %w(
        != % %= & &= * ** **= *= *map
        + += , - -= -> ->> . / //
        //= /= < << <<= <= = > >= >>
        >>= @ @= ^ ^= accumulate apply as-> assoc butlast
        calling-module-name car cdr chain coll? combinations comp complement compress cond
        cons cons? constantly count cut cycle dec defclass defmacro defmacro!
        defmacro/g! defmain defn defreader dict-comp disassemble dispatch-reader-macro distinct do doto
        drop drop-last drop-while empty? eval eval-and-compile eval-when-compile even? every? filter
        first flatten float? fn for* fraction genexpr gensym get group-by
        identity if* if-not if-python2 inc input instance? integer integer-char? integer?
        interleave interpose islice iterable? iterate iterator? juxt keyword keyword? last
        let lif lif-not list* list-comp macro-error macroexpand macroexpand-1 map merge-with
        multicombinations name neg? none? not-in not? nth numeric? odd? partition
        permutations pos? product quasiquote quote range read read-str reduce remove
        repeat repeatedly require rest second set-comp setv some string string?
        symbol? take take-nth take-while tee unless unquote unquote-splicing when with*
        with-decorator with-gensyms xor yield-from zero? zip zip-longest | |= ~
      )
    end
  end
end
