# -*- coding: utf-8 -*- #

# TODO: {% assign %}
# TODO: {% include %}
# TODO: {% if %} (L114, 118)
# TODO: {% cycle %} (L71)

module Rouge
  module Lexers
    class Liquid < RegexLexer
      title "Liquid"
      desc 'Liquid is a templating engine for Ruby (liquidmarkup.org)'
      tag 'liquid'
      filenames '*.liquid'

      state :root do
        rule /[^\{]+/, Text
        rule /(\{%)(\s*)/ do
          groups Punctuation, Text::Whitespace
          push :tagBlock
        end
        rule /(\{\{)(\s*)/ do |m|
          groups Punctuation, Text::Whitespace # TODO: => :generic
          push :output
        end
        rule /\{/, Text
      end

      state :tagBlock do
        # builtin logic blocks
        rule /(if|unless|elsif|case)(?=\s+)/, Keyword::Reserved, :condition
        rule /(when)(\s+)/ do
          groups Keyword::Reserved, Text::Whitespace
          push :when
        end
        rule (/(else)(\s*)(%\})/) do
          groups Keyword::Reserved, Text::Whitespace, Punctuation
          pop!
        end

        # other builtin blocks
        rule (/(capture)(\s+)([^\s%]+)(\s*)(%\})/) do
          groups Name::Tag, Text::Whitespace, Name::Variable, Text::Whitespace, Punctuation
          pop!
        end
        rule (/(comment)(\s*)(%\})/) do
          groups Name::Tag, Text::Whitespace, Punctuation
          push :comment
        end
        rule (/(raw)(\s*)(%\})/) do
          groups Name::Tag, Text::Whitespace, Punctuation
          push :raw
        end

        # end of block
        rule (/(end(case|unless|if))(\s*)(%\})/) do
          groups Keyword::Reserved, nil, Text::Whitespace, Punctuation
          pop!
        end
        rule (/(end([^\s%]+))(\s*)(%\})/) do
          groups Name::Tag, nil, Text::Whitespace, Punctuation
          pop!
        end

        # builtin tags (assign and include are handled together with usual tags)
        rule /(cycle)(\s+)(([^\s:]*)(:))?(\s*)/ do |m|
          token Name::Tag, m[1]
          token Text::Whitespace, m[2]
          token Text, m[4] # TODO: => :generic
          token Punctuation, m[5]
          token Text::Whitespace, m[6]
          push :variableTagMarkup
        end

        # other tags or blocks
        rule (/([^\s%]+)(\s*)/) do
          groups Name::Tag, Text::Whitespace
          push :tagMarkup
        end
      end

      state :output do
        mixin :whitespace
        mixin :generic
        rule /\./, Punctuation
        rule /\}\}/, Punctuation, :pop!
        rule (/\|/), Punctuation, :filters
      end

      state :filters do
        mixin :whitespace
        rule (/\}\}/) { token Punctuation; reset_stack }
        rule /([^\s\|:]+)(:?)(\s*)/ do
          groups Name::Function, Punctuation, Text::Whitespace
          push :filterMarkup
        end
      end

      state :filterMarkup do
        rule (/\|/), Punctuation, :pop!
        mixin :endOfTag
        mixin :defaultParamMarkup
      end

      state :condition do
        mixin :endOfBlock
        mixin :whitespace

        rule /([^\s=!><]+)(\s*)([=!><]=?)(\s*)([^\s]+)(\s*)/ do |m|
          token Name::Variable, m[1] # TODO: => :generic
          token Text::Whitespace, m[2]
          token Operator, m[3]
          token Text::Whitespace, m[4]
          token Str, m[5] # TODO: => :generic
          token Text::Whitespace, m[6]
        end
        rule (/\b((!)|(not\b))/) { groups nil, Operator, Operator::Word }
        rule (/([\w\.\'"]+)(\s+)(contains)(\s+)([\w\.\'"]+)/) do
          groups nil, Text::Whitespace, Operator::Word, Text::Whitespace
        end

        mixin :generic
        mixin :whitespace
      end

      state :when do
        mixin :endOfBlock
        mixin :whitespace
        mixin :generic
      end

      state :genericValue do
        mixin :generic
        mixin :endAtWhitespace
      end

      state :operator do
        rule /(\s*)((=|!|>|<)=?)(\s*)/ do
          groups Text::Whitespace, Operator, nil, Text::Whitespace
          pop!
        end
        rule /(\s*)(\bcontains\b)(\s*)/ do
          groups Text::Whitespace, Operator::Word, Text::Whitespace
          pop!
        end
      end

      state :endOfTag do
        rule (/\}\}/) { token Punctuation; reset_stack }
      end

      state :endOfBlock do
        rule (/%\}/) { token Punctuation; reset_stack }
      end

      state :endAtWhitespace do
        rule /\s+/, Text::Whitespace, :pop!
      end

      # states for unknown markup
      state :paramMarkup do
        mixin :whitespace
        rule /([^\s=:]+)(\s*)(=|:)/ do
          groups Name::Attribute, Text::Whitespace, Operator
        end
        rule /(\{\{)(\s*)([^\s\}])(\s*)(\}\})/ do
          groups Punctuation, Text::Whitespace, nil, Text::Whitespace, Punctuation
        end
        mixin :string
        mixin :number
        mixin :keyword
        rule (/,/), Punctuation
      end

      state :defaultParamMarkup do
        mixin :paramMarkup
        rule /./, Text
      end

      state :variableParamMarkup do
        mixin :paramMarkup
        mixin :variable
        rule /./, Text
      end

      state :tagMarkup do
        rule (/%\}/) { token Punctuation; reset_stack }
        mixin :defaultParamMarkup
      end

      state :variableTagMarkup do
        rule (/%\}/) { token Punctuation; reset_stack }
        mixin :variableParamMarkup
      end

      # states for different values types
      state :keyword do
        rule /\b(false|true)\b/, Keyword::Constant
      end

      state :variable do
        rule /[a-zA-Z_]\w*/, Name::Variable
        rule /(?<=\w)\.(?=\w)/, Punctuation
      end

      state :string do
        rule (/'[^']*'/), Str::Single
        rule (/"[^"]*"/), Str::Double
      end

      state :number do
        rule /\d+\.\d+/, Num::Float
        rule /\d+/, Num::Integer
      end

      state :generic do
        mixin :keyword
        mixin :string
        mixin :number
        mixin :variable
      end

      state :whitespace do
        rule /[ \t]+/, Text::Whitespace
      end

      state :comment do
        rule (/(\{%)(\s*)(endcomment)(\s*)(%\})/) do
          groups Punctuation, Text::Whitespace, Name::Tag, Text::Whitespace, Punctuation
          reset_stack
        end
        rule /./, Comment
      end

      state :raw do
        rule /[^\{]+/, Text
        rule (/(\{%)(\s*)(endraw)(\s*)(%\})/) do
          groups Punctuation, Text::Whitespace, Name::Tag, Text::Whitespace, Punctuation
          reset_stack
        end
        rule /\{/, Text
      end
    end
  end
end
