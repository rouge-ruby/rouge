# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Pod6 < RegexLexer
      title "Perl 6 Pod"
      desc "Perl 6 Plain' Ol Documentation (perl6.org)"

      tag 'perl6pod'
      aliases 'pod6'

      filenames '*.pod', '*.pod6'

      state :root do
         rule(/\=begin pod/m, Keyword, :pod6)
         rule(/^#.*$/, Comment)
      end

      state :pod6 do
         rule(/\=end pod/m, Keyword, :pop!)

         rule(/\=(?:NAME|AUTHOR|VERSION|TITLE|SUBTITLE)/, Keyword, :semantic)

         rule(/\=begin code/, Keyword, :block_code)
         rule(/\=begin input/, Keyword, :block_input)
         rule(/\=begin output/, Keyword, :block_output)
         rule(/\=begin/, Keyword, :block)

         rule(/\=head(\d+)\s+/, Keyword, :head)
         rule(/\=item(\d+)\s+/, Keyword, :item)
         rule(/\=input/, Keyword, :input)
         rule(/\=output/, Keyword, :output)
         rule(/\=defn/, Keyword)

         rule(/B\</, Punctuation::Indicator, :formatting_b)
         rule(/C\</, Punctuation::Indicator, :formatting_c)
         rule(/E\</, Punctuation::Indicator, :formatting_e)
         rule(/I\</, Punctuation::Indicator, :formatting_i)
         rule(/K\</, Punctuation::Indicator, :formatting_k)
         rule(/L\</, Punctuation::Indicator, :formatting_l)
         rule(/N\</, Punctuation::Indicator, :formatting_n)
         rule(/T\</, Punctuation::Indicator, :formatting_t)
         rule(/U\</, Punctuation::Indicator, :formatting_u)
         rule(/Z\</, Punctuation::Indicator, :formatting_z)

         rule(/^(?:\t|\s{4,})/, Other, :code)

         rule(/./, Text)
      end

      state :semantic do
         rule(/.+\n/, Name, :pop!)
      end

      state :head do
         rule(/\n/, Text::Whitespace, :pop!)

         rule(/:\w+\</, Name::Attribute, :attribute)

         rule(/./, Generic::Heading)
      end

      state :item do
         rule(/\n/, Text::Whitespace, :pop!)

         rule(/B\</, Punctuation::Indicator, :formatting_b)
         rule(/C\</, Punctuation::Indicator, :formatting_c)
         rule(/E\</, Punctuation::Indicator, :formatting_e)
         rule(/I\</, Punctuation::Indicator, :formatting_i)
         rule(/K\</, Punctuation::Indicator, :formatting_k)
         rule(/L\</, Punctuation::Indicator, :formatting_l)
         rule(/N\</, Punctuation::Indicator, :formatting_n)
         rule(/T\</, Punctuation::Indicator, :formatting_t)
         rule(/U\</, Punctuation::Indicator, :formatting_u)
         rule(/Z\</, Punctuation::Indicator, :formatting_z)

         rule(/./, Generic)
      end

      state :input do
         rule(/\n/, Text::Whitespace, :pop!)

         rule(/./, Generic::Inserted)
      end

      state :output do
         rule(/\n/, Text::Whitespace, :pop!)

         rule(/./, Generic::Output)
      end

      state :code do
         rule(/.*$/, Generic::Output, :pop!)
      end

      state :attribute do
         rule(/\>/, Name::Attribute, :pop!)

         rule(/./, Name)
      end

      state :block do
         # TODO: Check the name of the block, and make sure the =end matches
         # the same name

         rule(/:\w+\</, Name::Attribute, :attribute)
         rule(/\=end/, Keyword, :pop!)

         rule(/B\</, Punctuation::Indicator, :formatting_b)
         rule(/C\</, Punctuation::Indicator, :formatting_c)
         rule(/E\</, Punctuation::Indicator, :formatting_e)
         rule(/I\</, Punctuation::Indicator, :formatting_i)
         rule(/K\</, Punctuation::Indicator, :formatting_k)
         rule(/L\</, Punctuation::Indicator, :formatting_l)
         rule(/N\</, Punctuation::Indicator, :formatting_n)
         rule(/T\</, Punctuation::Indicator, :formatting_t)
         rule(/U\</, Punctuation::Indicator, :formatting_u)
         rule(/Z\</, Punctuation::Indicator, :formatting_z)

         rule(/./, Generic)
      end

      state :block_code do
         rule(/:\w+\</, Name::Attribute, :attribute)
         rule(/\=end code/, Keyword, :pop!)

         rule(/./, Generic::Output)
      end

      state :block_input do
         rule(/:\w+\</, Name::Attribute, :attribute)
         rule(/\=end input/, Keyword, :pop!)

         rule(/./, Generic::Inserted)
      end

      state :block_output do
         rule(/:\w+\</, Name::Attribute, :attribute)
         rule(/\=end output/, Keyword, :pop!)

         rule(/./, Generic::Output)
      end

      state :formatting_b do
         rule(/\>/, Punctuation::Indicator, :pop!)
         rule(/.*?(?=\>)/, Generic::Strong)
      end

      state :formatting_c do
         rule(/\>/, Punctuation::Indicator, :pop!)
         rule(/.*?(?=\>)/, Generic::Output)
      end

      state :formatting_e do
         rule(/\>/, Punctuation::Indicator, :pop!)
         rule(/.*?(?=\>)/, Literal::Number::Other)
      end

      state :formatting_i do
         rule(/\>/, Punctuation::Indicator, :pop!)
         rule(/.*?(?=\>)/, Generic::Emph)
      end

      state :formatting_k do
         rule(/\>/, Punctuation::Indicator, :pop!)
         rule(/.*?(?=\>)/, Generic::Inserted)
      end

      state :formatting_l do
         rule(/\>/, Punctuation::Indicator, :pop!)
         rule(/.*?(?=\>)/, Other)
      end

      state :formatting_n do
         rule(/\>/, Punctuation::Indicator, :pop!)
         rule(/.*?(?=\>)/, Comment::Special)
      end

      state :formatting_t do
         rule(/\>/, Punctuation::Indicator, :pop!)
         rule(/.*?(?=\>)/, Generic::Output)
      end

      state :formatting_u do
         rule(/\>/, Punctuation::Indicator, :pop!)
         rule(/.*?(?=\>)/, Generic)
      end

      state :formatting_z do
         rule(/\>/, Punctuation::Indicator, :pop!)
         rule(/.*?(?=\>)/, Comment)
      end
    end
  end
end
