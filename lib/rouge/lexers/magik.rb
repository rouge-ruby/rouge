# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Magik < RegexLexer
      title "Magik"
      desc "Smallworld Magik"
      tag 'magik'
      aliases 'magik'
      filenames '*.magik'
      mimetypes 'text/x-magik', 'application/x-magik'

      keywords = %w(
           _package
           _pragma
           _block _endblock
           _handling _default
           _protect _protection _endprotect
           _try _with _when _endtry
           _catch _endcatch
           _throw
           _lock _endlock
           _if _then _elif _else _endif
           _for _over _loop _endloop _loopbody _continue _leave
           _return
           _local _constant _recursive _global _dynamic _import
           _private _iter _abstract _method _endmethod
           _proc _endproc
           _gather _scatter _allresults _optional
           _thisthread _self _clone _super
           _primitive
           _unset _true _false _maybe
           _is _isnt _not _and _or _xor _cf _andif _orif
           _div _mod
        )

      string_double = /"[^"\n]*"/
      string_single = /'[^'\n]*'/

      digits = /[0-9]+/
      hex_digits = /[0-9a-f]+/i
      radix = /r#{hex_digits}/i
      exponent = /(e|&)[+-]?#{digits}/i
      decimal = /\.#{digits}/
      number = /#{digits}(#{radix}|#{exponent}|#{decimal})*/

      character = /%u[0-9a-z]{4}|%[^\s]+/i

      simple_identifier = /(?>(?:[a-z0-9_!?]|\\.)+)/i
      piped_identifier = /\|[^\|\n]*\|/
      identifier = /(?:#{simple_identifier}|#{piped_identifier})+/i
      package_identifier = /#{identifier}:#{identifier}/
      symbol = /:#{identifier}/i
      global_ref = /@[\s]*#{identifier}:#{identifier}/
      label = /@[\s]*#{identifier}/

      state :root do
        rule /##(.*)?\n?/, Comment::Doc
        rule /#(.*)?\n?/, Comment::Single

        rule /(_method)(\s+)/ do
          groups Keyword, Text::Whitespace
          push :method_name
        end

        rule /(?:#{keywords.join('|')})\b/, Keyword

        rule string_double, Literal::String
        rule string_single, Literal::String
        rule symbol, Str::Symbol
        rule global_ref, Name::Label
        rule label, Name::Label
        rule character, Literal::String::Char
        rule number, Literal::Number
        rule package_identifier, Name
        rule identifier, Name

        rule /[\[\]{}()\.,;]/, Punctuation
        rule /\$/, Punctuation
        rule /(<<|^<<)/, Operator
        rule /(>>)/, Operator
        rule /[-~+\/*%=&^<>]|!=/, Operator

        rule /[\s]+/, Text::Whitespace
      end

      state :method_name do
        rule /(#{identifier})(\.)(#{identifier})/ do
          groups Name::Class, Punctuation, Name::Function
          pop!
        end
      end
    end
  end
end
