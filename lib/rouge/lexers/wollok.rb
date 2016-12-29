module Rouge
  module Lexers
    class Wollok < RegexLexer
      title 'Wollok'
      desc 'Wollok lang'
      tag 'wollok'
      filenames *%w(*.wlk *.wtest)

      def self.analyze_text(_text)
        0.3
      end

      keywords = %w(new super return inherits import constructor)

      entityName = /[a-zA-Z][a-zA-Z0-9]*/

      state :whitespace do
        rule /\s+/, Text::Whitespace
      end

      state :root do
        mixin :whitespace

        rule /self/, Name::Builtin::Pseudo

        rule /class|object|method|inherits/ do
          push :entity
          token Keyword::Declaration
        end

        rule /[a-zA-Z]+/ do |m|

          if keywords.include? m[0]
            token Keyword::Reserved
          else
            token Text
          end
        end

        rule /[\[\]{}(),=.*]/, Punctuation
        rule /<>+-*\//, Operator

      end

      state :entity do
        mixin :whitespace

        rule entityName do
          pop!
          token Name::Class
        end
      end

      state :object do
        mixin :whitespace

        rule entityName do
          pop!
          token Name
        end
      end
    end
  end
end
