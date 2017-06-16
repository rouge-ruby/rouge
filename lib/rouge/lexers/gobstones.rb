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

      state :comments do
        def comment_between(start, finish)
          /#{start}.*?#{finish}/m
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
          groups Keyword::Reserved, Text::Whitespace, Keyword::Type
        end
        mixin :functions
        mixin :symbols
        rule /\d+/, Literal::Number
        rule /".+?"/, Literal::String
      end

      state :functions do
        rule /(procedure|function)(\s+)(\w+)/ do
          groups Keyword::Reserved, Text::Whitespace, Name::Function
        end

        rule /([a-zA-Z][a-zA-Z'_0-9]*)(\()/ do |m|
          groups Name::Function, Text
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
