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
        #TODO is it ''' or """?
        rule %r{(-|#|//).*$}, Comment::Single
      end

      state :root do
        mixin :comments
        rule /\s|\S/, Text
      end
    end
  end
end
