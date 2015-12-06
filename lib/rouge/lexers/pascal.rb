# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Pascal < RegexLexer
      tag 'pascal'
      title "Pascal"
      desc 'a procedural programming language commonly used as a teaching language.'
      filenames '*.pas'

      mimetypes 'text/x-pascal'

      id = /@?[_a-z]\w*/i

      keywords = %w(
        absolute abstract all and and_then array as asm assembler attribute begin
        bindable case class const constructor destructor delay div do downto else
        end except export exports external function far file finalization finally
        for forward goto if inc implementation import in index inherited initialization
        inline interface interrupt is label library mod module near not object of only
        operator or or_else otherwise packed pow private procedure program property
        protected public published qualified record repeat resident restricted
        segment set shl shr then to try type unit until uses value var view virtual
        while with xor write writeln
      )

      keywords_type = %w(
        ansichar ansistring bool boolean byte bytebool cardinal char comp currency
        double dword extended int64 integer iunknown longbool longint longword pansichar
        pansistring pbool pboolean pbyte pbytearray pcardinal pchar pcomp pcurrency
        pdate pdatetime pdouble pdword pextended phandle pint64 pinteger plongint plongword
        pointer ppointer pshortint pshortstring psingle psmallint pstring pvariant pwidechar
        pwidestring pword pwordarray pwordbool real real48 shortint shortstring single
        smallint string tclass tdate tdatetime textfile thandle tobject ttime variant
        widechar widestring word wordbool
      )

      state :whitespace do
        # Spaces
        rule /\s+/m, Text
        # // Comments
        rule %r((//).*$\n?), Comment::Single
        # -- Comments
        rule %r((--).*$\n?), Comment::Single
        # (* Comments *)
        rule %r(\(\*.*?\*\))m, Comment::Multiline
        # { Comments }
        rule %r(\{.*?\})m, Comment::Multiline
      end

      state :root do
        mixin :whitespace

        rule %r{((0(x|X)[0-9a-fA-F]*)|(([0-9]+\.?[0-9]*)|(\.[0-9]+))((e|E)(\+|-)?[0-9]+)?)(L|l|UL|ul|u|U|F|f|ll|LL|ull|ULL)?}, Num
        rule %r{[~!@#\$%\^&\*\(\)\+`\-={}\[\]:;<>\?,\.\/\|\\]}, Punctuation
        rule %r{'([^']|'')*'}, Str
        rule /(true|false|nil)\b/i, Name::Builtin
        rule /\b(#{keywords.join('|')})\b/i, Keyword
        rule /\b(#{keywords_type.join('|')})\b/i, Keyword::Type
        rule id, Name
      end
    end
  end
end
