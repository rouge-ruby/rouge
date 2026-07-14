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
        rule(/\s*\=begin pod/m, Keyword, :pod6)
        rule(/^#.*$/, Comment)
        rule(/[^=]*/m, Text)
      end

      state :pod6 do
        rule(/\=end pod/m, Keyword, :pop!)

        rule(/\=(?:NAME|AUTHOR|VERSION|TITLE|SUBTITLE)/, Keyword, :semantic)

        rule(/\=begin code/, Keyword, :block_code)
        rule(/\=begin input/, Keyword, :block_input)
        rule(/\=begin output/, Keyword, :block_output)
        rule(/\=begin/, Keyword, :block)

        rule(/\=head(\d+)\s+/, Keyword, :head)
        rule(/\=code/, Keyword, :code)
        rule(/\=item(\d+)\s+/, Keyword, :item)
        rule(/\=input/, Keyword, :input)
        rule(/\=output/, Keyword, :output)
        rule(/\=defn/, Keyword)

        rule(/^(?:\t|[ ]{4,})/, Other, :code)
        rule(/[^=]*/m, Text)
      end

      state :semantic do
        rule(/\n/, Name, :pop!)

        rule(/.*/, Name)
      end

      state :head do
        rule(/\n/, Text::Whitespace, :pop!)

        rule(/:\w+\</, Name::Attribute, :attribute)
        rule(/.*/, Generic::Heading)
      end

      state :code do
        rule(/\n/, Text::Whitespace, :pop!)

        rule(/.*/, Generic::Output)
      end

      state :item do
        rule(/\n/, Text::Whitespace, :pop!)

        rule(/[^\n]/, Generic)
      end

      state :input do
        rule(/\n/, Text::Whitespace, :pop!)

        rule(/.*/, Generic::Inserted)
      end

      state :output do
        rule(/\n/, Text::Whitespace, :pop!)

        rule(/.*/, Generic::Output)
      end

      state :code do
        rule(/[^\n]/m, Generic::Output, :pop!)
      end

      state :attribute do
        rule(/\>/, Name::Attribute, :pop!)

        rule(/[^>]*/, Name)
      end

      state :block do
        rule(/\=end/, Keyword, :pop!)

        # TODO: Check the name of the block, and make sure the =end matches
        # the same name

        rule(/:\w+\</, Name::Attribute, :attribute)
        rule(/.*/, Generic)
      end

      state :block_code do
        rule(/\=end code/, Keyword, :pop!)
        rule(/.*/, Generic::Output)
      end

      state :block_input do
        rule(/:\w+\</, Name::Attribute, :attribute)
        rule(/\=end input/, Keyword, :pop!)

        rule(/.*/, Generic::Inserted)
      end

      state :block_output do
        rule(/:\w+\</, Name::Attribute, :attribute)
        rule(/\=end output/, Keyword, :pop!)

        rule(/.*/, Generic::Output)
      end
    end
  end
end
