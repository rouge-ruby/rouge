# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    module Ttcn3 < RegexLexer
      title "Ttcn3"
      desc "The Ttcn3 programming language (http://www.ttcn-3.org/). See ETSI ES 201 873-1"

      tag 'ttcn3'
      filenames '*.ttcn', '*.ttcn3'
      mimetypes 'text/x-ttcn3', 'text/x-ttcn'

      def self.keywords
        @keywords ||= super + Set.new(%w(
          module import group type port component signature external const template function altstep testcase var timer if else select case for while do label goto stop return break int2char int2unichar int2bit int2enum int2hex int2oct int2str int2float float2int char2int char2oct unichar2int unichar2oct bit2int bit2hex bit2oct bit2str hex2int hex2bit hex2oct hex2str oct2int oct2bit oct2hex oct2str oct2char oct2unichar str2int str2hex str2oct str2float enum2int any2unistr lengthof sizeof ispresent ischosen isvalue isbound istemplatekind regexp substr replace encvalue decvalue encvalue_unichar decvalue_unichar encvalue_o decvalue_o get_stringencoding remove_bom rnd hostid
        ))
      end

      def self.reserved
        @reserved ||= super + Set.new(%w(
          all apply assert at configuration conjunct const delta disjunct duration finished history implies inv mode notinv now omit onentry onexit par prev realtime seq setstate static stepsize stream timestamp until values wait
        ))
      end

      def self.types
        @types ||= super + Set.new(%w(
        anytype address boolean bitstring bytestring charstring component enumerated float integer hexstring octetstring port record set of union universal
      ))
      end

      id = /[a-zA-Z_][a-zA-Z0-9_]*/
      const_name = /[A-Z][A-Z0-9_]*\b/
      module_name = /[A-Z][a-zA-Z0-9]*\b/

      state :root do
        rule %r/[^\S\n]+/, Text
        rule %r(//.*?$), Comment::Single
        rule %r(/\*.*?\*/)m, Comment::Multiline
        # keywords: go before method names to avoid lexing "throw new XYZ"
        # as a method signature
        rule %r/(?:#{keywords.join('|')})\b/, Keyword

        rule %r(
          (\s*(?:[a-zA-Z_][a-zA-Z0-9_.\[\]<>]*\s+)+?) # return arguments
          ([a-zA-Z_][a-zA-Z0-9_]*)                  # method name
          (\s*)(\()                                 # signature start
        )mx do |m|
          # TODO: do this better, this shouldn't need a delegation
          delegate Ttcn3, m[1]
          token Name::Function, m[2]
          token Text, m[3]
          token Operator, m[4]
        end

        rule %r/@#{id}/, Name::Decorator
        rule %r/(?:#{declarations.join('|')})\b/, Keyword::Declaration
        rule %r/(?:#{types.join('|')})\b/, Keyword::Type
        rule %r/package\b/, Keyword::Namespace
        rule %r/(?:true|false|null)\b/, Keyword::Constant
        rule %r/(?:module|interface)\b/, Keyword::Declaration, :module
        rule %r/import\b/, Keyword::Namespace, :import
        rule %r/"(\\\\|\\"|[^"])*"/, Str
        rule %r/'(?:\\.|[^\\]|\\u[0-9a-f]{4})'/, Str::Char
        rule %r/(\.)(#{id})/ do
          groups Operator, Name::Attribute
        end

        rule %r/#{id}:/, Name::Label
        rule const_name, Name::Constant
        rule module_name, Name::Module
        rule %r/\$?#{id}/, Name
        rule %r/[~^*!%&\[\](){}<>\|+=:;,.\/?-]/, Operator

        digit = /[0-9]_+[0-9]|[0-9]/
        bin_digit = /[01]_+[01]|[01]/
        oct_digit = /[0-7]_+[0-7]|[0-7]/
        hex_digit = /[0-9a-f]_+[0-9a-f]|[0-9a-f]/i
        rule %r/#{digit}+\.#{digit}+([eE]#{digit}+)?[fd]?/, Num::Float
        rule %r/0b#{bin_digit}+/i, Num::Bin
        rule %r/0x#{hex_digit}+/i, Num::Hex
        rule %r/0#{oct_digit}+/, Num::Oct
        rule %r/#{digit}+L?/, Num::Integer
        rule %r/\n/, Text
      end

      state :module do
        rule %r/\s+/m, Text
        rule id, Name::Module, :pop!
      end

      state :import do
        rule %r/\s+/m, Text
        rule %r/[a-z0-9_.]+\*?/i, Name::Namespace, :pop!
      end
    end
  end
end
