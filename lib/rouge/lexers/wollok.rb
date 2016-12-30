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

      keywords = %w(new super return)

      entityName = /[a-zA-Z][a-zA-Z0-9]*/

      state :whitespace do
        rule /\s+/, Text::Whitespace
      end

      state :root do
        mixin :whitespace
        rule /import/, Keyword::Reserved, :import
        rule /class|object|program/, Keyword::Reserved, :entity_naming
        rule /test/, Keyword::Reserved, :test_naming
      end

      state :import do
        mixin :whitespace
        rule /.+/, Text, :pop!
      end

      state :entity_naming do
        mixin :whitespace
        rule entityName, Name::Class
        rule /inherits/, Keyword::Reserved
        rule /{/, Text, :entity_definition
        rule /}/, Text, :pop!
      end

      state :entity_definition do
        mixin :whitespace
        rule /var|const\b/, Keyword::Reserved
        rule /method|constructor/, Keyword::Reserved, :method_naming
        rule /}/, Text, :pop!
        mixin :definition
      end

      state :method_naming do
        mixin :whitespace
        rule entityName, Text, :parameters
        rule /\(/, Text, :parameters
      end

      state :parameters do
        mixin :whitespace
        rule /\(|\)/, Text
        rule entityName, Keyword::Variable
        rule /,/, Punctuation

        rule /{/ do
          token Text
          pop!(2)
        end
      end

      state :definition do
        mixin :whitespace
        rule /#{keywords.join('|')}/, Keyword::Reserved
        rule entityName, Keyword::Variable
        rule /[0-9]+\.{0,1}[0-9]*/, Literal::Number::Float
        rule /self/, Name::Builtin::Pseudo
        #rule /./, Punctuation, :message
        rule /\*|\+|-|\/|<|>|=|./, Operator
        rule /(|)/, Text
      end

      state :message do
        rule entityName, Text
      end

      state :lambda do

      end

    end
  end
end
