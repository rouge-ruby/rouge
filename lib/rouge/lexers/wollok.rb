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

      keywords = %w(new super return if else)

      entity_name = /[a-zA-Z][a-zA-Z0-9]*/

      lambda_level = 0

      state :whitespace do
        rule /\s+/, Text::Whitespace
      end

      state :root do
        mixin :whitespace
        rule /import/, Keyword::Reserved, :import
        rule /class|object|program/, Keyword::Declaration, :entity_naming
        rule /test/, Keyword::Reserved, :test_naming
      end

      state :import do
        mixin :whitespace
        rule /.+$/, Text, :pop!
      end

      state :entity_naming do
        mixin :whitespace
        rule entity_name, Name::Class
        rule /inherits/, Keyword::Reserved
        rule /{/, Text, :entity_definition
        rule /}/, Text, :pop!
      end

      state :entity_definition do
        mixin :whitespace
        rule /var|const\b/, Keyword::Reserved, :variable_declaration
        rule /method|constructor|super/, Keyword::Reserved, :method_naming
        rule /}/ do
          token Text
          pop!(2)
        end
      end

      state :method_naming do
        mixin :whitespace
        rule entity_name, Text
        rule /\(/, Text, :parameters
      end

      state :parameters do
        mixin :whitespace
        rule /\(|\)/, Text
        rule entity_name, Keyword::Variable
        rule /,/, Punctuation
        rule /\=/ do
          token Text
          pop!(2)
        end
        rule /{/, Text, :definition
      end

      state :definition do
        mixin :whitespace
        rule /#{keywords.join('|')}/, Keyword::Reserved
        rule /self/, Name::Builtin::Pseudo
        rule entity_name, Keyword::Variable
        rule /\.#{entity_name}/, Other
        rule /[0-9]+\.{0,1}[0-9]*/, Literal::Number::Float
        rule /\*|\+|-|\/|<|>|=|\.|!/, Operator
        rule /\(|\)/, Text
        rule /{/ do
          token Text
          lambda_level += 1
        end
        rule /}/ do
          token Text
          if lambda_level.zero?
            pop!(3)
          else
            lambda_level -= 1
          end
        end
      end

      state :variable_declaration do
        rule /$/, Text, :pop!
        mixin :definition
      end

    end
  end
end