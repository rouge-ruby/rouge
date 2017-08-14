# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class SuperCollider < RegexLexer
      tag 'supercollider'
      filenames '*.sc', '*.scd'

      title "SuperCollider"
      desc 'A cross-platform interpreted programming language for sound synthesis, algorithmic composition, and realtime performance'

      keywords = Set.new %w(
        case do for forBy loop if while
        var arg classvar const super this
      )

      constants = Set.new %w(
        true false nil inf thisThread
        thisMethod thisFunction thisProcess
        thisFunctionDef currentEnvironment
        topEnvironment
      )

      start { push :bol }

      # beginning of line
      state :bol do
        mixin :inline_whitespace

        rule(//) { pop! }
      end

      state :inline_whitespace do
        rule /\s+/m, Text
        mixin :has_comments
      end

      state :whitespace do
        rule /\n+/m, Text, :bol
        rule %r(\/\/\.*?$), Comment::Single, :bol
        mixin :inline_whitespace
      end

      state :has_comments do
        rule %r(/[*]), Comment::Multiline, :nested_comment
      end

      state :nested_comment do
        mixin :has_comments
        rule %r([*]/), Comment::Multiline, :pop!
        rule %r([^*/]+)m, Comment::Multiline
        rule /./, Comment::Multiline
      end

      state :root do
        mixin :whitespace

        rule /$(\\.|.)/, Str::Char
        rule /(\d+\*|\d*\.\d+)(e[+-]?[0-9]+)?/i, Num::Float
        rule /\d+e[+-]?[0-9]+/i, Num::Float
        rule /0x[0-9A-Fa-f]+/, Num::Hex
        rule /0b[01]+/, Num::Bin
        rule /\d+/, Num::Integer

#        from IDE's highlighter
#    Token::RadixFloat, "^\\b\\d+r[0-9a-zA-Z]*(\\.[0-9A-Z]*)?" );
#    Token::Float, "^\\b((\\d+(\\.\\d+)?([eE][-+]?\\d+)?(pi)?)|pi)\\b" );
#    Token::HexInt, "^\\b0(x|X)(\\d|[a-f]|[A-F])+" );
#    Token::SymbolArg, "^\\b[A-Za-z_]\\w*\\:" );
#    Token::Name, "^[a-z]\\w*" );
#    Token::Class, "^\\b[A-Z]\\w*" );
#    Token::Primitive, "^\\b_\\w+" );
#    Token::Symbol, "^\\\\\\w*" );
#    Token::Char, "^\\$\\\\?." );
#    Token::EnvVar, "^~\\w+" );
#    Token::SingleLineComment, "^//[^\r\n]*" );
#    Token::MultiLineCommentStart, "^/\\*" );
#    Token::Operator, "^[\\+-\\*/&\\|\\^%<>=]+" );

      end
    end
  end
end

