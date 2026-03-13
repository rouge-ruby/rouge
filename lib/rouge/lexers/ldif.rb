# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class LDIF < RegexLexer
      title "LDIF"
      desc 'LDAP Data Interchange Format'
      tag 'ldif'

      filenames '*.ldif', '*.LDIF'
      mimetypes 'text/ldif'

      attribute = /[^:\s]+/

      state :basic do
        rule %r/[;#].*?\n/, Comment
        rule %r/\s+/, Text
      end

      state :root do
        mixin :basic

        rule %r/(dn: )/ do
          groups Keyword, Text
          push :dn
        end

        rule %r/(-)/, Operator

        rule %r/(#{attribute})(:)/ do
          groups Name::Property, Text
          push :value
        end
      end

      state :dn do
        rule %r/\n(?! )/, Text, :pop!
        mixin :basic
        rule %r/'.*?'/, Name::Tag
        rule %r/[^\\\n]+/, Name::Tag
      end

      state :value do
        rule %r/\n(?! )/, Text, :pop!
        mixin :basic
        rule %r/'.*?'/, Str
        rule %r/[^\\\n]+/, Str
      end
    end
  end
end
