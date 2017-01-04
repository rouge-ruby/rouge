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
      variable_naming = /_?#{entity_name}/
      var_declaration = /var|const\b/

      lambda_level = 0
      entities = []

      state :whitespaces_and_comments do
        rule /\s+/m, Text::Whitespace
        rule /$+/m, Text::Whitespace
        rule %r(//.*$), Comment::Single
        rule %r(/\*(.|\s)*?\*/)m, Comment::Multiline
      end

      state :root do
        mixin :whitespaces_and_comments
        rule /import/, Keyword::Reserved, :import
        rule /class|object|mixin/, Keyword::Reserved, :entity_naming
        rule /test|program/, Keyword::Reserved, :chunk_naming
        rule /(package)(\s+)(#{entity_name})/ do
          groups Keyword::Reserved, Text::Whitespace, Name::Class
        end
        rule /{/, Text, :root
        rule /}/, Text, :pop!
      end

      state :import do
        mixin :whitespaces_and_comments
        rule /.+$/, Text, :pop!
      end

      state :chunk_naming do
        mixin :whitespaces_and_comments
        mixin :string
        rule /{/ do
          # I need three states in the stack in order
          # to achieve polymorphism between chunks and entities
          token Text
          push
          push :definition
        end
      end

      state :entity_naming do
        mixin :whitespaces_and_comments
        rule /inherits|mixed|with/, Keyword::Reserved
        rule entity_name do |m|
          token Name::Class
          entities << m[0]
        end
        rule /{/, Text, :entity_definition
        rule /}/, Text, :pop!
      end

      state :entity_definition do
        mixin :whitespaces_and_comments
        rule /override/, Keyword::Reserved
        rule /method|constructor|super/, Keyword::Reserved, :method_signature
        mixin :variable_declaration
        rule /}/ do
          token Text
          pop!(2)
        end
      end

      state :method_signature do
        mixin :whitespaces_and_comments
        rule entity_name, Text, :parameters
        rule /\(/, Text, :parameters
      end

      state :parameters do
        mixin :whitespaces_and_comments
        rule /\(|\)/, Text
        rule variable_naming, Keyword::Variable
        rule /,/, Punctuation
        rule /(\=)(\s*)(super)/ do
          groups Text, Text::Whitespace, Keyword::Reserved
        end
        rule /\=/, Text, :inline
        rule /{/, Text, :definition
      end

      state :definition do
        mixin :whitespaces_and_comments
        rule /#{keywords.join('|')}/, Keyword::Reserved
        mixin :variable_declaration
        mixin :literal
        rule /\*|\+\b|-\b|\/|<|>|\=\=|!|\+\+|--|%|and|or|not|\+=|-=/, Operator
        rule /\=/, Text
        rule /self/, Name::Builtin::Pseudo
        rule /,/, Punctuation
        rule /(\.)(#{entity_name})/ do
          groups Operator, Text
        end
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

      state :literal do
        mixin :whitespaces_and_comments
        rule /true|false/, Text
        rule variable_naming do |m|
          variable = m[0]
          if entities.include?(variable) || ('A'..'Z').include?(variable[0])
            token Name::Class
          else
            token Keyword::Variable
          end
        end
        rule /[0-9]+\.?[0-9]*/, Literal::Number
        mixin :string
        rule /\[|\#{/, Punctuation, :list
      end

      state :list do
        mixin :whitespaces_and_comments
        rule /,/, Punctuation
        rule /]|}/, Punctuation, :pop!
        mixin :literal
      end

      state :string do
        rule /"[^"]*"/m, Literal::String
      end

      state :variable_declaration do
        rule /(#{var_declaration})(\s+)(#{variable_naming})(\s+)(=)(\s+)/ do |m|
          groups Keyword::Reserved, Text::Whitespace,
                 Keyword::Variable, Text::Whitespace, Text, Text::Whitespace
        end
        rule /(#{var_declaration})(\s+)(#{variable_naming})/ do |m|
          groups Keyword::Reserved, Text::Whitespace, Keyword::Variable
        end
        mixin :literal
      end

      state :inline do
        rule /$/ do
          token Text
          pop!(3)
        end
        mixin :definition
      end
    end
  end
end