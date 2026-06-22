# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Puppet < RegexLexer
      title "Puppet"
      desc 'The Puppet configuration management language (puppetlabs.org)'
      tag 'puppet'
      aliases 'pp'
      filenames '*.pp'

      def self.detect?(text)
        return true if text.shebang? 'puppet-apply'
        return true if text.shebang? 'puppet'
      end

      KEYWORDS = Set.new %w(
        and case class default define else elsif if in import inherits
        node unless
      )

      CONSTANTS = Set.new %w(false true undef)

      METAPARAMETERS = Set.new %w(before require notify subscribe)

      id = /[a-z]\w*/
      cap_id = /[A-Z]\w*/
      qualname = /(::)?(#{id}::)*\w+/

      state :whitespace do
        rule %r/\s+/m, Text
        rule %r/#.*?\n/, Comment
      end

      state :root do
        mixin :whitespace

        rule %r/[$]#{qualname}/, Name::Variable
        keywords %r/(#{id})(?=\s*[=+]>)/m do
          rule METAPARAMETERS, Keyword::Pseudo
          default Name::Property
        end

        rule %r/(#{qualname})(?=\s*[(])/m, Name::Function
        rule cap_id, Name::Class

        rule %r/[+=|~-]>|<[|~-]/, Punctuation
        rule %r/[|:}();\[\]]/, Punctuation

        # HACK for case statements and selectors
        rule %r/{/, Punctuation, :regex_allowed
        rule %r/,/, Punctuation, :regex_allowed

        rule %r/(in|and|or)\b/, Operator::Word
        rule %r/[=!<>]=/, Operator
        rule %r/[=!]~/, Operator, :regex_allowed
        rule %r([.=<>!+*/-]), Operator

        rule %r/(class|include)(\s*)(#{qualname})/ do
          groups Keyword, Text, Name::Class
        end

        rule %r/node\b/, Keyword, :regex_allowed

        rule %r/'(\\[\\']|[^'])*'/m, Str::Single
        rule %r/"/, Str::Double, :dquotes

        rule %r/\d+([.]\d+)?(e[+-]\d+)?/, Num

        keywords qualname do
          rule KEYWORDS, Keyword
          rule CONSTANTS, Keyword::Constant
          default Name
        end
      end

      state :regex_allowed do
        mixin :whitespace
        rule %r(/), Str::Regex, :regex

        rule(//) { pop! }
      end

      state :regex do
        rule %r(/), Str::Regex, :pop!
        rule %r/\\./, Str::Escape
        rule %r/[(){}]/, Str::Interpol
        rule %r/\[/, Str::Interpol, :regex_class
        rule %r/./, Str::Regex
      end

      state :regex_class do
        rule %r/\]/, Str::Interpol, :pop!
        rule %r/(?<!\[)-(?=\])/, Str::Regex
        rule %r/-/, Str::Interpol
        rule %r/\\./, Str::Escape
        rule %r/[^\\\]-]+/, Str::Regex
      end

      state :dquotes do
        rule %r/"/, Str::Double, :pop!
        rule %r/[^$\\"]+/m, Str::Double
        rule %r/\\./m, Str::Escape
        rule %r/[$]#{qualname}/, Name::Variable
        rule %r/[$][{]#{qualname}[}]/, Name::Variable
      end
    end
  end
end
