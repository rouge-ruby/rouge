# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Dart < RegexLexer
      desc "The Dart programming language (java.com)"

      tag 'dart'
      filenames '*.dart'
      mimetypes 'text/x-dart'

      keywords = %w(
        as assert break case catch continue default do else finally for
        if in is new rethrow return super switch this throw try while with
      )

      declarations = %w(
        abstract dynamic const external extends factory final get implements
        native operator set static typedef var
      )

      types = %w(bool double Dynamic enum int num Object Set String void)

      id = /[a-zA-Z_][a-zA-Z0-9_]*/

      state :root do
        rule %r(^
          (\s*(?:[a-zA-Z_][a-zA-Z0-9_.\[\]]*\s+)+?) # return arguments
          ([a-zA-Z_][a-zA-Z0-9_]*)                  # method name
          (\s*)(\()                                 # signature start
        )mx do |m|
          # TODO: do this better, this shouldn't need a delegation
          delegate Dart, m[1]
          token Name::Function, m[2]
          token Text, m[3]
          token Punctuation, m[4]
        end

        rule /\s+/, Text
        rule %r(//.*?$), Comment::Single
        rule %r(/\*.*?\*/)m, Comment::Multiline
        rule /"(\\\\|\\"|[^"])*"/, Str::Double
        rule /'(\\\\|\\'|[^'])*'/, Str::Single
        rule /(?:#{keywords.join('|')})\b/, Keyword
        rule /(?:#{declarations.join('|')})\b/, Keyword::Declaration
        rule /(?:#{types.join('|')})\b/, Keyword::Type
        rule /(?:true|false|null)\b/, Keyword::Constant
        rule /(?:class|interface)\b/, Keyword::Declaration, :class
        rule /(?:import|export|library|part|source)\b/, Keyword::Namespace
        rule /(\.)(#{id})/ do
          groups Operator, Name::Attribute
        end
        rule /#{id}:/, Name::Label
        rule /\$?#{id}/, Name
        rule /[~^*!%&\[\](){}<>\|+=:;,.\/?-]/, Operator
        rule /[0-9][0-9]*\.[0-9]+([eE][0-9]+)?[fd]?/, Num::Float
        rule /0x[0-9a-f]+/, Num::Hex
        rule /[0-9]+L?/, Num::Integer
        rule /\n/, Text
      end

      state :class do
        rule /\s+/m, Text
        rule id, Name::Class, :pop!
      end
    end
  end
end