# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class OCaml < RegexLexer
      title "OCaml"
      desc 'Objective CAML (ocaml.org)'
      tag 'ocaml'
      filenames '*.ml', '*.mli', '*.mll', '*.mly'
      mimetypes 'text/x-ocaml'

      def self.keywords
        @keywords ||= Set.new %w(
          as assert begin class constraint do done downto else end
          exception external false for fun function functor if in include
          inherit initializer lazy let match method module mutable new
          object of open private raise rec sig struct then to true try
          type value val virtual when while with
        )
      end

      def self.keyopts
        @keyopts ||= Set.new %w(
          != # & && ( ) * \+ , - -. -> . .. : :: := :> ; ;; < <- =
          > >] >} ? ?? [ [< [> [| ] _ ` { {< | |] } ~
        )
      end

      def self.word_operators
        @word_operators ||= Set.new %w(and asr land lor lsl lxor mod or)
      end

      def self.primitives
        @primitives ||= Set.new %w(unit int float bool string char list array)
      end

      def self.gen_operator(a)
        res = []
        while not a.nil?

          elem = :null
          idx = a.length
          for x in self.keyopts
            i = a.index(x)
            if not i.nil?
              if i < idx || (i == idx and (x.length > elem.length))
                elem = x
                idx = i
              end
            end
          end

          if not elem.nil?
            if idx > 0
              res = res + [a[0..idx-1]]
            end
            res = res + [a[idx..idx+elem.length-1]]
            a = a[idx + elem.length..a.length]
          else
            res = res + [a]
            break
          end
        end

        return res
      end

      operator = %r([\[\];,{}_()!$%&*+./:<=>?@^|~#-]+)
      id = /[a-z][\w']*/i
      upper_id = /[A-Z][\w']*/

      state :root do
        rule /\s+/m, Text
        rule /false|true|[(][)]|\[\]/, Name::Builtin::Pseudo
        rule /#{upper_id}(?=\s*[.])/, Name::Namespace, :dotted
        rule /`#{upper_id}/, Name::Tag
        rule upper_id, Name::Class
        rule /[(][*](?![)])/, Comment, :comment
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

        rule operator do |m|
          for x in self.class.gen_operator(m[0])
            if self.class.keyopts.include? x
               token Punctuation , x
            else
               token Operator , x
            end
          end
        end

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

      state :comment do
        rule /[^(*)]+/, Comment
        rule(/[(][*]/) { token Comment; push }
        rule /[*][)]/, Comment, :pop!
        rule /[(*)]/, Comment
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
        rule /#{upper_id}(?=\s*[.])/, Name::Namespace
        rule upper_id, Name::Class, :pop!
        rule id, Name, :pop!
      end
    end
  end
end
