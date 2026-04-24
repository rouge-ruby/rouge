module Rouge
  module Lexers
    class AppleScript
      RESERVED = Set.new %w(
        about above after against and apart from around as aside from
        at back before beginning behind below beneath beside between but
        by considering contain contains contains continue copy div does
        eighth else end equal equals error every exit false fifth first
        for fourth from front get given global if ignoring in instead of
        into is it its last local me middle mod my ninth not of on onto
        or out of over prop property put ref reference repeat return
        returning script second set seventh since sixth some tell tenth
        that the then third through thru timeout times to transaction
        true try until where while whose with without
      )

      MULTI_WORD_BUILTINS_RE = dangerous_alternation_regexp([
        /text +item +delimiters/,
        /current +application/,
        /missing +value/,
        /do +shell +script/,
        /display +dialog/,
      ])

      # ref: https://developer.apple.com/library/archive/documentation/AppleScript/Conceptual/AppleScriptLangGuide/conceptual/ASLR_fundamentals.html#//apple_ref/doc/uid/TP40000983-CH218-BAJBDEJI
      BUILTINS = Set.new %w(
        AppleScript
        pi
        result
        version
        application
        character
      )

      OPERATOR_RE = dangerous_alternation_regexp([
        "and",
        "or",
        "is equal",
        "equals",
        /(is )?equal to/,
        "is not",
        "isn't",
        /isn't equal( to)?/,
        /is not equal( to)?/,
        "doesn't equal",
        "does not equal",
        /(is )?greater than/,
        "comes after",
        /is not less than or equal( to)?/,
        /isn't less than or equal( to)?/,
        /(is )?less than/,
        "comes before",
        "is not greater than or equal( to)?",
        "isn't greater than or equal( to)?",
        /(is )?greater than or equal( to)?/,
        "is not less than",
        "isn't less than",
        "does not come before",
        "doesn't come before",
        /(is )?less than or equal( to)?/,
        "is not greater than",
        "isn't greater than",
        "does not come after",
        "doesn't come after",
        "starts? with",
        "begins? with",
        "ends? with",
        "contains?",
        "does not contain",
        "doesn't contain",
        "is in",
        "is contained by",
        "is not in",
        "is not contained by",
        "isn't contained by",
        "div",
        "mod",
        "not",
        /(a )?(ref( to)?|reference to)/,
        "is",
        "does",
      ])
    end
  end
end
