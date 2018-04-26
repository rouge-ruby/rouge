# -*- coding: utf-8 -*- #
#
# adapted from lustre.rf (adapted from ocaml.rb), hence some ocaml-ism migth remains
module Rouge
  module Lexers
    class Lutin < RegexLexer
      title "Lutin"
      desc 'The Lutin programming language (Verimag)'
      tag 'lutin'
      filenames '*.lut'
      mimetypes 'text/x-lutin'

      def self.keywords
        @keywords ||= Set.new %w(
          let in node extern system returns weak strong assert raise try catch
          trap do exist erun run type ref exception include false true 
        )
      end

      def self.word_operators
        @word_operators ||= Set.new %w(
           div and xor mod or not nor if then else pre) 
      end

      def self.primitives
        @primitives ||= Set.new %w(int real bool trace loop fby)
      end

      operator = %r([;,_!$%&*+./:<=>?@^|~#-]+)
      id = /[a-z_][\w']*/i

      state :root do
        rule /\s+/m, Text
        rule /false|true|[(][)]|\[\]/, Name::Builtin::Pseudo
        rule %r(\-\-.*?$), Comment::Single
        rule %r(/\*.*?\*/)m, Comment::Multiline
        rule %r(\(\*.*?\*\))m, Comment::Multiline
        rule id do |m|
          match = m[0]
          if self.class.keywords.include? match
            token Keyword
          elsif self.class.word_operators.include? match
            token Operator::Word
          elsif self.class.primitives.include? match
            token Keyword::Type
          else
            token Name
          end
        end

        rule /[(){}\[\];]+/, Punctuation
        rule operator, Operator

        rule /-?\d[\d_]*(.[\d_]*)?(e[+-]?\d[\d_]*)/i, Num::Float
        rule /0x\h[\h_]*/i, Num::Hex
        rule /0o[0-7][0-7_]*/i, Num::Oct
        rule /0b[01][01_]*/i, Num::Bin
        rule /\d[\d_]*/, Num::Integer

        rule /'(?:(\\[\\"'ntbr ])|(\\[0-9]{3})|(\\x\h{2}))'/, Str::Char
        rule /'[.]'/, Str::Char
        rule /'/, Keyword
        rule /"/, Str::Double, :string
        rule /[~?]#{id}/, Name::Variable
      end

      state :string do
        rule /[^\\"]+/, Str::Double
        mixin :escape_sequence
        rule /\\\n/, Str::Double
        rule /"/, Str::Double, :pop!
      end

      state :escape_sequence do
        rule /\\[\\"'ntbr]/, Str::Escape
        rule /\\\d{3}/, Str::Escape
        rule /\\x\h{2}/, Str::Escape
      end

      state :dotted do
        rule /\s+/m, Text
        rule /[.]/, Punctuation
        rule id, Name, :pop!
        rule /[({\[]/, Punctuation, :pop!
      end
    end
  end
end
