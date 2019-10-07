# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class TTCN3 < RegexLexer
      title "TTCN3"
      desc "The TTCN3 programming language (ttcn-3.org)"

      tag 'ttcn3'
      filenames '*.ttcn', '*.ttcn3'
      mimetypes 'text/x-ttcn3', 'text/x-ttcn'

      def self.keywords
        @keywords = %w(
          module import group type port component signature external
          execute const template function altstep testcase var timer if
          else select case for while do label goto start stop return
          break int2char int2unichar int2bit int2enum int2hex int2oct
          int2str int2float float2int char2int char2oct unichar2int
          unichar2oct bit2int bit2hex bit2oct bit2str hex2int hex2bit
          hex2oct hex2str oct2int oct2bit oct2hex oct2str oct2char
          oct2unichar str2int str2hex str2oct str2float enum2int
          any2unistr lengthof sizeof ispresent ischosen isvalue isbound
          istemplatekind regexp substr replace encvalue decvalue
          encvalue_unichar decvalue_unichar encvalue_o decvalue_o
          get_stringencoding remove_bom rnd hostid send receive
          setverdict
        )
      end

      def self.reserved
        @reserved = %w(
          all alt apply assert at configuration conjunct const control
          delta deterministic disjunct duration fail finished fuzzy
          history implies inconc inv lazy mod mode notinv now omit
          onentry onexit par pass prev realtime seq setstate static
          stepsize stream timestamp until values wait
        )
      end

      def self.types
        @types = %w(
          anytype address boolean bitstring bytestring charstring
          component enumerated float integer hexstring octetstring port
          record set of union universal
        )
      end

      # optional comment or whitespace
      ws = %r((?:\s|//.*?\n|/[*].*?[*]/)+)
      id = /[a-zA-Z_][a-zA-Z0-9_]*/
      const_name = /[A-Z][A-Z0-9_]*\b/
      module_name = /[A-Z][a-zA-Z0-9]*\b/

      state :root do
        rule %r/[^\S\n]+/, Text
        rule %r(//.*?$), Comment::Single
        rule %r(/\*.*?\*/)m, Comment::Multiline

        # keywords: go before method names to avoid lexing "throw new XYZ"
        # as a method signature
        rule %r{[~!@#\$%\^&\*\(\)\+`\-={}\[\]:;<>\?,\.\/\|\\]}, Punctuation
        rule %r(
          (\s*(?:[a-zA-Z_][a-zA-Z0-9_.\[\]<>]*\s+)+?) # return arguments
          ([a-zA-Z_][a-zA-Z0-9_]*)                  # method name
          (\s*)(\()                                 # signature start
        )mx do |m|
          # TODO: do this better, this shouldn't need a delegation
          delegate TTCN3, m[1]
          token Name::Function, m[2]
          token Text, m[3]
          token Operator, m[4]
        end

        rule %r/(?:true|false|null)\b/, Keyword::Constant
        rule %r/(module)\b/, Keyword::Declaration, :module
        rule %r/import\b/, Keyword::Namespace, :import
        rule const_name, Name::Constant
        rule module_name, Name::Label

        rule %r/(\.)(#{id})/ do
          groups Operator, Name::Attribute
        end
        rule %r/@#{id}/, Name::Decorator
        rule %r/#{id}:/, Name::Label
        rule %r/\$#{id}/, Name

        rule id do |m|
          if self.class.keywords.include? m[0]
            token Keyword
          elsif self.class.reserved.include? m[0]
            # Was not used in submitted version
          elsif self.class.types.include? m[0]
            token Keyword::Type
          else
            token Name
          end
        end

        rule %r/"(\\\\|\\"|[^"])*"/, Str
        rule %r/'(?:\\.|[^\\]|\\u[0-9a-f]{4})'/, Str::Char

        rule %r/[~^*!%&\[\](){}<>\|+=:;,.\/?-]/, Operator

        digit = /[0-9]_+[0-9]|[0-9]/
        bin_digit = /[01]_+[01]|[01]/
        oct_digit = /[0-7]_+[0-7]|[0-7]/
        hex_digit = /[0-9a-f]_+[0-9a-f]|[0-9a-f]/i
        rule %r/#{digit}+\.#{digit}+([eE]#{digit}+)?[fd]?/, Num::Float
        rule %r/'#{bin_digit}+'B/i, Num::Bin
        rule %r/'#{hex_digit}+'H/i, Num::Hex
        rule %r/'#{oct_digit}+'O/, Num::Oct
        rule %r/#{digit}+L?/, Num::Integer
        rule %r/\n/, Text
      end

      state :module do
        rule %r/\s+/m, Text
        rule id, Name::Class, :pop!
      end

      state :import do
        rule %r/\s+/m, Text
        rule %r/[a-z0-9_.]+\*?/i, Name::Namespace, :pop!
      end
    end
  end
end
