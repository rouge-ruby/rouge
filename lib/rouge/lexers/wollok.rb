module Rouge
  module Lexers
    class Wollok < RegexLexer
      title 'Wollok'
      desc 'Wollok lang'
      tag 'wollok'
      filenames *%w(*.wlk *.wtest *.wpgm)

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

        rule /import/, Keyword::Reserved, :import

        rule /class|object|program/, Keyword::Declaration, :entity_naming

        rule /test/, Keyword::Declaration, :test_naming
      end

      state :import do
        mixin :whitespace
        rule /.+/, Text, :pop!
      end

      state :entity_naming do
        mixin :whitespace
        rule entityName, Keyword::Declaration
        rule /{/, Text, :entity_definition
      end

      state :entity_definition do
        mixin :whitespace
        rule
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
