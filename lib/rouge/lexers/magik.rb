# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Magik < RegexLexer
      title "Magik"
      desc "Smallworld Magik"
      tag 'magik'
      filenames '*.magik'
      mimetypes 'text/x-magik', 'application/x-magik'

      KEYWORDS = Set.new %w(
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
        _for _over _while _loop _finally _endloop _loopbody _continue _leave
        _return
        _class
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


      digits = /[0-9]+/
      radix = /r[0-9a-z]+/i
      exponent = /(e|&)[+-]?#{digits}/i
      decimal = /\.#{digits}/
      number = /#{digits}(#{radix}|#{exponent}|#{decimal})*/

      simple_identifier = /(?>(?:[a-z0-9_!?]|\\.)+)/i
      piped_identifier = /\|[^\|\n]*\|/
      identifier = /(?:#{simple_identifier}|#{piped_identifier})+/i

      state :root do
        rule %r/##(.*)?/, Comment::Doc
        rule %r/#(.*)?/, Comment::Single

        rule %r/(_method)(\s+)/ do
          groups Keyword, Text::Whitespace
          push :method_name
        end

        keywords %r/_\w+/ do
          rule KEYWORDS, Keyword
        end

        rule /"[^"\n]*?"/, Literal::String
        rule /'[^'\n]*?'/, Literal::String
        rule /:#{identifier}/, Str::Symbol
        rule /@[\s]*#{identifier}:#{identifier}/, Name::Label
        rule /@[\s]*#{identifier}/, Name::Label
        rule /%u[0-9a-z]{4}|%[^\s]+/i, Literal::String::Char
        rule number, Literal::Number
        rule /#{identifier}:#{identifier}/, Name
        rule identifier, Name

        rule %r/[\[\]{}()\.,;]/, Punctuation
        rule %r/\$/, Punctuation
        rule %r/(<<|^<<)/, Operator
        rule %r/(>>)/, Operator
        rule %r/[-~+\/*%=&^<>]|!=/, Operator

        rule %r/[\s]+/, Text::Whitespace
      end

      state :method_name do
        rule %r/(#{identifier})(\.)(#{identifier})/ do
          groups Name::Class, Punctuation, Name::Function
          pop!
        end
      end
    end
  end
end
