# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class XBsl < RegexLexer
      title "XBSL"
      desc "The 1C:Enterprise Element programming language"
      tag 'xbsl'
      filenames '*.xbsl', '*.sbsl'

      KEYWORDS = /\b(?:
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
                    )\b/ix

      QUERY_KEYWORDS = /\b(?:
                      ВЫБРАТЬ     | SELECT    | ВСТАВИТЬ    | INSERT    | ИЗМЕНИТЬ      | UPDATE    | РАЗРЕШЕННЫЕ | ALLOWED 
                    | ПЕРВЫЕ      | TOP       | РАЗЛИЧНЫЕ   | DISTINCT  | ОБРЕЗАТЬ      | TRUNCATE  | УДАЛИТЬ     | DELETE  
                    | УНИЧТОЖИТЬ  | DROP      | ПОМЕСТИТЬ   | INTO      | ИНДЕКСИРОВАТЬ | INDEX     | УСТАНОВИТЬ  | SET
                    | СОЗДАТЬ\\s+ВРЕМЕННУЮ\\s+ТАБЛИЦУ       | CREATE\\s+TEMPORARY\\s+TABLE
                    | СОЗДАТЬ\\s+ИНДЕКС                     | CREATE\\s+INDEX
                    | ИЗ          | FROM      | ГДЕ         | WHERE     | СОЕДИНЕНИЕ    | JOIN      | ЛЕВОЕ       | LEFT
                    | ПРАВОЕ      | RIGHT     | ПОЛНОЕ      | FULL      | ВНУТРЕННЕЕ    | INNER     | ОБЪЕДИНИТЬ  | UNION
                    | ВСЕ         | ALL       | УПОРЯДОЧИТЬ | ORDER     | СГРУППИРОВАТЬ | GROUP     | ИМЕЮЩИЕ     | HAVING
                    | ИЕРАРХИИ    | HIERARCHY | ПО          | ON  | BY  | ВОЗР          | ASC       | УБЫВ        | DESC
                    | ДЛЯ         | FOR       | КАК         | AS        | ЕСТЬ          | IS        | В           | IN
                    | ВЫРАЗИТЬ    | CAST      | ВЫБОР       | CASE      | КОГДА         | WHEN      | ТОГДА       | THEN
                    | ИНАЧЕ       | ELSE      | КОНЕЦ       | END       | НЕ            | NOT       | ИЛИ         | OR
                    | И           | AND       | ССЫЛКА      | REFS      | СПЕЦСИМВОЛ    | ESCAPE                  |NULL
                    | ПОДОБНО     | LIKE      | МЕЖДУ       | BETWEEN
                    )\b/ix

      state :root do
        rule /(импорт|import)(\s+[\wа-яё\.]+)/i do |m|
          token Keyword::Namespace, m[1]
          token Name::Namespace, m[2]
        end

        mixin :query

        mixin :statements

        mixin :value_types
    
        mixin :comments

        rule /@[\wа-яё]+\b/i, Name::Tag
        rule KEYWORDS, Keyword
        mixin :literals
        rule %r/(\")/, Punctuation, :string_end
        mixin :other_text        
        rule /[\(\)\[\]]/, Punctuation
      end

      state :literals do
        rule %r/(?<=[^\wа-яё\.]|^)((\d+\.?\d*)|(0x[0-9a-f]+)|(0b[0-1]+))(?=[^\wа-яё\.]|$)/, Literal::Number
        rule %r/(Истина|True|Ложь|False|Неопределено|Undefined)/, Keyword::Constant
        rule %r/(\b[\wа-яё]+\b)(\s*\{)(.*?)(\})/i do |m|
          token Name::Class, m[1]
          token Punctuation, m[2]
          token Keyword::Constant, m[3]
          token Punctuation, m[4]
        end    
      end

      state :string_end do        
        rule %r/(\\.)/, Literal::String::Symbol
        rule %r/([%\$])(?=\")/, Literal::String
        rule %r/([^\"%\$]+?)/i, Literal::String
        rule %r/([%\$][0-9\s])/, Literal::String
        rule %r/([%\$](?:[\wа-яё]+|\{[^\}]+\}))/i, Generic::Inserted
        rule %r/(\")/, Punctuation, :pop!
      end

      state :other_text do
        rule /\s+/, Text::Whitespace
        rule /[\wа-яё]+/i, Name::Variable
        rule %r/(->)/, Name::Function::Magic
        rule %r/[:,;\|]/, Punctuation
        rule %r/[-+\/*%=<>.?&!]/, Operator
        rule %r/(?<=[^\wа-яё\.]|^)(не|not|и|and|или|or)(?=[^\wа-яё\.]|$)/, Operator
      end

      state :comments do
        rule %r(//.*$), Comment::Single
        rule %r(\/\*[.\s\n\w\W]*?\*\/), Comment::Multiline
      end

      state :query do
        rule %r/\b(Запрос|Query)(\s*\{)/i do |m|
          token Name::Class, m[1]
          token Punctuation, m[2]
          push :query_end
        end

        rule %r/\b(новый|new)(\s*)\b(Запрос|Query)(\s*\(\s*\")/i do |m|
          token Keyword, m[1]
          token Text::Whitespace, m[2]
          token Name::Class, m[3]
          token Punctuation, m[4]
          push :query_end_bracket
        end
      end

      state :query_end do
        mixin :query_body
        rule %r/(\s*\})/, Punctuation, :pop!
      end

      state :query_end_bracket do
        mixin :query_body
        rule %r/(\s*\"\s*\))/, Punctuation, :pop!
      end

      state :query_body do
        mixin :comments
        mixin :literals
        rule %r/[%\$][\wа-яё]+\b/i, Generic::Inserted
        rule %r/([%\$](?:[\wа-яё]+|\{[^\}]+\}))/i, Generic::Inserted
        mixin :query_func
        rule QUERY_KEYWORDS, Keyword
        mixin :other_text
      end

      state :query_func do
        rule %r/\b([\wа-я]+\s*)(\()/i do |m|
          token Name::Function, m[1]
          token Punctuation, m[2]
          push :query_func_end
        end
      end

      state :query_func_end do
        mixin :query_body
        rule %r/(\))/, Punctuation, :pop!
      end

      state :statements do
        rule %r/^(\s*(?:структура|structure|перечисление|enum)\s+)([\wа-яё]+)/i do |m|
          token Keyword, m[1]
          token Name::Entity, m[2]
        end
    
        rule %r/\b(область|scope)\b/, Comment::Preproc
          
        rule %r/(попытка|поймать|исключение|try|catch|exception|вконце|finally)\s/, Name::Exception

        rule %r/(новый|new)(\s+[\wа-яё\.]+)/i do |m|
          token Keyword::Declaration, m[1]
          token Name::Class, m[2]
        end

        rule %r/(const|конст)(\s+[\wа-яё]+)/i do |m|
          token Keyword::Constant, m[1]
          token Name::Constant, m[2]
        end

        rule %r/\b(знч|val)(\s+[\wа-яё]+)/ do |m|
          token Keyword::Constant, m[1]
          token Name::Variable, m[2]
        end

        rule %r/\b(пер|var|исп|use)(\s+[\wа-яё]+)/ do |m|
          token Keyword::Variable, m[1]
          token Name::Variable, m[2]
        end
      end

      state :value_types do
        rule %r/(:\s*)([\wа-яё\?\.\ \t|<>]+)([,\)=]|$)/i do |m|
          token Punctuation, m[1]
          token Keyword::Type, m[2]
          token Punctuation, m[3]
        end
      end
    end
  end
end
