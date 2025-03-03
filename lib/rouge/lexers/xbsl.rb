# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class XBsl < RegexLexer
      title "XBSL"
      desc "The 1C:Enterprise Element programming language"
      tag 'xbsl'
      filenames '*.xbsl'

      KEYWORDS = /(?<=[^\wа-яё]|^)(?:
                      вконце      | finally   | возврат       | return
                    | выбор       | case      | выбросить     | throw
                    | для         | for       | если          | if
                    | знч         | val       | и             | and
                    | из          | in        | или           | or
                    | импорт      | import    | иначе         | else
                    | исключение  | exception | исп           | use
                    | как         | as        | когда         | when
                    | конст       | const     | конструктор   | constructor
                    | метод       | method    | не            | not
                    | неизвестно  | unknown   | новый         | new
                    | обз         | req       | область       | scope
                    | пер         | var       | перечисление  | enum
                    | по          | to        | поймать       | catch
                    | пока        | while     | попытка       | try
                    | прервать    | break     | продолжить    | continue
                    | статический | static    | структура     | structure
                    | умолчание   | default   | это           | is
                    | этот        | this
                    )(?=[^\wа-яё]|$)/ix

      state :root do
        # date        
        rule %r/(Дата|Date|Время|Time|ДатаВремя|DateTime|ЧасовойПояс)(\{)(.*)(\})/ do |m|
          token Name::Class, m[1]
          token Punctuation, m[2]
          token Literal::Date, m[3]
          token Punctuation, m[4]
        end

        # binary
        rule %r/(Байты|Bytes|Ууид|Uuid)(\{)(.*)(\})/ do |m|
          token Name::Class, m[1]
          token Punctuation, m[2]
          token Literal::Number::Bin, m[3]
          token Punctuation, m[4]
        end

        # string
        rule %r/\"/, Literal::String, :stringinter

        # number
        rule %r/\b(-*\d+[\.]?\d*)\b/, Literal::Number
        rule %r/\b(-*0x[0-9a-f]+)\b/, Literal::Number
        rule %r/\b(-*0b[01]+)\b/, Literal::Number

        # new
        rule %r/(новый|new)(\s+)([\wа-яё\.]+)/i do |m|
          token Keyword::Declaration, m[1]
          token Text, m[2]
          token Name::Class, m[3]
        end

        # type, recurs
        rule %r/([\<:])/, Punctuation, :typestate
        rule %r/\b(as|как)\b/, Keyword, :typestate

        # method
        rule %r/(метод|method)(\s+)([\wа-яё]+)/i do |m|
          token Keyword, m[1]
          token Text, m[2]
          token Name::Function, m[3]
        end

        # class
        rule %r/^(\s*(?:структура|structure)\s+)([\wа-яё]+)/i do |m|
          token Keyword, m[1]
          token Name::Entity, m[2]
        end

        # import
        rule %r/(импорт|import)(\s+[\wа-яё\.]+)/i do |m|
          token Keyword::Namespace, m[1]
          token Name::Namespace, m[2]
        end

        # scope
        rule %r/\b(область|scope)\b/, Comment::Preproc
          
        # exception
        rule %r/(попытка|поймать|исключение|try|catch|exception|вконце|finally)\s/, Name::Exception

        # const
        rule %r/(const|конст)(\s+[\wа-яё]+)/i do |m|
          token Keyword::Constant, m[1]
          token Name::Constant, m[2]
        end

        # comment
        rule %r(//.*$), Comment::Single
        rule %r(\/\*[.\s\n\w\W]*?\*\/), Comment::Multiline

        # query
        rule %r/(Запрос|Query)(\s*)(\{)/ do |m|
          token Keyword::Type, m[1]
          token Literal::String::Other, m[2]
          token Literal::String::Delimiter, m[3]
          push :queryinter
        end

        rule %r/\b(знч|val)(\s+[\wа-яё]+)/ do |m|
          token Keyword::Constant, m[1]
          token Name::Variable, m[2]
        end

        rule %r/\b(пер|var|исп|use)(\s+[\wа-яё]+)/ do |m|
          token Keyword::Variable, m[1]
          token Name::Variable, m[2]
        end

        rule %r/\n/, Text
        rule %r/[^\S\n]+/, Text
        
        rule %r/[\[\]:(),;{}\|]/, Punctuation
        rule %r/[-+\/*%=<>.?&!]/, Operator
        rule KEYWORDS, Keyword
        rule %r/[\wа-яё]+/i, Name::Variable
        rule %r/@[\wа-яё]+/i, Name::Tag
        
      end

      state :typestate do
        rule %r/=/, Operator, :pop!
        rule %r/\s*[0-9.xb]+/, Literal::Number, :pop!

        rule %r/([\wа-яё \t|\?\.]+)/i, Name::Class

        rule %r/\</, Punctuation, :typestate
        rule %r/[\>,\)\(\n]/, Punctuation, :pop!
        :pop!
      end

      state :stringinter do
        rule %r/[%\$]*"/, Literal::String, :pop!
        rule %r/(\\.)/, Literal::String::Symbol

        rule %r/([^\$%"\\]+)/, Literal::String
        rule %r/([%\$](?>[^a-zа-яё_\{"]))/i, Literal::String

        rule %r/(\\.)/, Literal::String::Symbol
        rule %r/([%\$](?:[\wа-яё]+|\{[^\}]+\}))/i, Literal::String::Interpol
      end

      state :queryinter do
        rule %r/[%\$]*\}/, Literal::String::Delimiter, :pop!
        rule %r/(\\.)/, Literal::String::Symbol

        rule %r/([^\$%\{\\]+)/, Generic::Emph
        rule %r/([%\$](?>[^a-zа-яё_\{"]))/i, Generic::Emph

        rule %r/(\\.)/, Literal::String::Symbol
        rule %r/([%\$](?:[\wа-яё]+|\{[^\}]+\}))/i, Literal::String::Interpol        
      end
    end
  end
end
