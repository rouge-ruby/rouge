# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Dafny < RegexLexer
      title "Dafny"
      desc "The Dafny programming language (github.com/dafny-lang/dafny)"
      tag "dafny"
      filenames "*.dfy"
      mimetypes "text/x-dafny"

      keywords = %w(
        abstract assert assume
        break calc case class codatatype const
        constructor datatype decreases default else ensures exists
        extends false forall fresh function
        ghost greatest if import in include
        inductive invariant
        iterator label least lemma match method
        modifies modify module multisets 
        new newtype null old opened
        predicate print provides reads
        refines requires return returns reveals
        static 
        then this trait true twostate type
        unchanged var where while yield yields
      )

      types = %w(bool char int real string object 
                 seq set iset map imap nat )
      arrayType = /array(?:1[0-9]+|[2-9][0-9]*)\??/
      bvType = /bv(?:0|[1-9][0-9]*)/

      id = /[a-zA-Z?][a-zA-Z0-9_?']*/

      digit = /[0-9]/
      digits = /#{digit}+(?:_#{digit}+)*/
      bin_digits = /[01]+(?:_[01]+)*/
      hex_digit = /(?:[0-9]|[a-f]|[A-F])/
      hex_digits = /#{hex_digit}+(?:_#{hex_digit}+)*/

      cchar = /(?:[^\\'\n\r]|\\["'ntr\\0])/
      schar = /(?:[^\\"\n\r]|\\["'ntr\\0])/
      uchar = /(?:\\u#{hex_digit}{4})/

      ## IMPORTANT: Rules are ordered, which allows later rules to be 
      ## simpler than they would otherwise be
      state :root do
        rule %r(/\*), Comment::Multiline, :comment
        rule %r(//.*?$), Comment::Single
        rule %r(\*/), Error          # should not have closing comment in :root
                                     # is an improperly nested comment

        rule %r/'#{cchar}'/, Str::Char           # standard or escape char
        rule %r/'#{uchar}'/, Str::Char           # unicode char
        rule %r/'[^'\n]*'/, Error                # bad any other enclosed char
        rule %r/'[^'\n]*$/, Error                # bad unclosed char

        rule %r/"(?:#{schar}|#{uchar})*"/, Str::Double        # valid string
        rule %r/".*"/, Error                     # anything else that is closed
        rule %r/".*$/, Error                     # bad unclosed string

        rule %r/@"([^"]|"")*"/, Str::Double     # valid verbatim string
        rule %r/@"([^"]|")*/, Error             # anything else unclosed

        rule %r/(?:true|false|null)\b/, Keyword::Constant


        rule %r/#{digits}\.#{digits}\b/, Num::Float
        rule %r/0b#{bin_digits}\b/, Num::Bin
        rule %r/0b[_0-9a-zA-Z'\?]*/, Error
        rule %r/0x#{hex_digits}\b/, Num::Hex
        rule %r/0x[_0-9a-zA-Z'\?]*/, Error
        rule %r/0x$/, Error
        rule %r/#{digits}\b/, Num::Integer
        rule %r/[_#{digit}]+\b/, Error

        rule %r/(?:object\?|#{arrayType}|#{bvType})/, Keyword::Type
        rule %r/array1\??/, Name
        rule %r/array\??/, Keyword::Type

        rule /[a-zA-Z0-9][a-zA-Z0-9_?']*/ do |m|
          if types.include?(m[0])
            token Keyword::Type
          elsif keywords.include?(m[0])
            token Keyword
          elsif
            token Name
          end
       end

        rule %r/#{id}/, Name
        rule %r/\.\./, Operator
        rule %r/as|is/, Operator
        rule %r/[*!%&\[\](){}<>\|^+=:;,.\/-]/, Operator

        rule %r/[^\S\n]+/, Text
        rule %r/\n/, Text
        rule %r/./, Error # Catchall
      end

      state :comment do
        rule %r(\*/), Comment::Multiline, :pop!
        rule %r(/\*), Comment::Multiline, :comment
        rule %r([^*/]+), Comment::Multiline
        rule %r(.), Comment::Multiline
      end

    end
  end
end
