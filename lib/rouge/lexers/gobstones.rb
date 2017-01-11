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

      reserved = %w(program interactive procedure function type is return record
                    field variant case if then else switch to repeat while foreach
                    in match)

      atoms = %w(False True Verde Rojo Azul Negro Norte Sur Este Oeste)

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
        rule any(atoms), Name::Builtin::Pseudo
        mixin :functions
        mixin :symbols
        rule /\d+/, Literal::Number
        rule /"(.|\s)+?"/, Literal::String
      end

      state :functions do
        rule /([a-zA-Z][a-zA-Z'_0-9]*)(\()/ do
          groups Name::Function, Text
        end
        rule /([a-z][a-zA-Z'_0-9]*)/, Text
        rule /([A-Z][a-zA-Z'_0-9]*)/, Keyword::Type
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
