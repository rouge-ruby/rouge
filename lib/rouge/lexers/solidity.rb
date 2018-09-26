# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Solidity < RegexLexer
      title "Solidity"
      desc %q(<desc for="this-lexer">Solidity is a contract-oriented, high-level language for implementing smart contracts.</desc>)
      tag 'solidity'
      filenames *%w(*.sol)
      mimetypes 'text/x-solidity'

      data_types = "address|bool|string|Int|Uint|Byte|Fixed|"\
      "Ufixed|int256|int248|int240|int232|int224|int216|int208"\
      "int200|int192|int184|int176|int168|int160|int152|int144"

      state :pragma_declaration do
        rule %r(.*\;), Keyword::Pseudo, :root
      end

      state :root do
        rule %r(^pragma ), Keyword, :pragma_declaration
        rule %r([u]?#{data_types}), Keyword::Type
      end

    end
  end
end
