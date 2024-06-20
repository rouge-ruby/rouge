# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Gobstones < RegexLexer
      title 'Gobstones'
      desc 'Gobstones language'
      tag 'gobstones'
      filenames '*.gbs'

      def self.analyze_text(_text)
        0.3
      end

      reserved = %w(program interactive is return record
                    field variant case if then else switch to repeat while foreach
                    in match)

      atoms = %w(False True Verde Rojo Azul Negro Norte Sur Este Oeste)

      types = Set.new

      state :comments do
        def comment_between(start, finish)
          /#{start}(.|\s)*?#{finish}/m
        end

        rule comment_between('{-', '-}'), Comment::Multiline
        rule comment_between('\/\*', '\*\/'), Comment::Multiline
        rule comment_between('"""', '"""'), Comment::Multiline
        rule /((?<!<)-(?!>)|#|\/).*$/, Comment::Single
      end

      state :root do
        def any(words)
          /#{words.map { |word| word.concat('\\b') }.join('|')}/
        end

        mixin :comments
        rule /\s+/, Text::Whitespace
        rule any(reserved), Keyword::Reserved
        rule any(atoms), Literal
        rule /(type)(\s+)(\w+)/ do |m|
          types.add(m[3])
          groups Keyword::Reserved, Text::Whitespace, Keyword::Type
        end
        mixin :functions
        mixin :symbols
        rule /\d+/, Literal::Number
        rule /"(.|\s)+?"/, Literal::String
      end

      state :functions do
        rule /(procedure|function)(\s+)(\w+)/ do
          groups Keyword::Reserved, Text::Whitespace, Name::Function
        end

        rule /([a-zA-Z][a-zA-Z'_0-9]*)(\()/ do |m|
          if types.include?(m[1])
            groups Keyword::Type, Text
          else
            groups Name::Function, Text
          end
        end
        rule /([a-z][a-zA-Z'_0-9]*)/, Name::Variable
      end

      state :symbols do
        rule /:=|\.\.|\+\+|\.|_|->|<-/, Operator
        rule /<=|<|>=|>|==|=/, Operator
        rule /\|\||&&|\+|\*|-|\^/, Operator
        rule /\(|\)|\{|\}/, Text
        rule /,|;|:|\||\[|\]/, Text
      end
    end
  end
end
