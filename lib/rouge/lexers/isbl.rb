# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class ISBL < RegexLexer
      title "ISBL"
      desc "The ISBL programming language"
      tag 'isbl'
      filenames '*.isbl'

      def self.keywords
        @keywords = Set.new %w(
          and и else иначе endexcept endfinally endforeach конецвсе endif конецесли endwhile
          конецпока except exitfor finally foreach все if если in в not не or или try while пока
        )
      end

      state :whitespace do
        rule %r/\s+/m, Text
        rule %r(//.*?$), Comment::Single
        rule %r(/[*].*?[*]/)m, Comment::Multiline
      end

      state :dotted do
        mixin :whitespace
        rule %r/\p{Alnum}+/i do |m|
          token(in_state?(:type) ? Keyword::Type : Name)

          pop!
        end
      end

      state :type do
        mixin :whitespace
        rule %r/\p{Word}+/, Name, :pop!
        rule %r/[.]/, Punctuation, :dotted
        rule(//) { pop! }
      end

      state :root do
        mixin :whitespace
        rule %r/[:]/, Punctuation, :type
        rule %r/[.]/, Punctuation, :dotted
        rule %r/[\[\]();]/, Punctuation
        rule %r([&*+=<>/-]), Operator
        rule %r/[\p{Alpha}_!]\p{Word}*(?=[(])/i, Name::Function
        rule %r/[\p{Alpha}_!]\p{Word}*/i do |m|
          if self.class.keywords.include?(m[0].downcase)
            token Keyword
          else
            token Name::Variable
          end
        end
        rule %r/\b(\d+(\.\d+)?)\b/, Literal::Number
        rule %r(["].*?["])m, Literal::String::Double
        rule %r(['].*?['])m, Literal::String::Single
      end
    end
  end
end
