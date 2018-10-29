# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Ada < RegexLexer
      tag 'ada'
      filenames '*.adb', '*.ads', '*.gpr'
      mimetypes 'text/x-adasrc'
  
      title "Ada"
      desc "The Ada programming language"

      def self.keywords
        @keywords ||= Set.new %w(
          abort abs abstract accept access aliased all and array at begin
          body case constant declare delay delta digits do else elsif end
          entry exception exit for function generic goto if in interface
          is limited loop mod new not null of or others out overriding
          package pragma private procedure protected raise range record
          rem renames requeue return reverse select separate some subtype
          synchronized tagged task terminate then type until use when
          while with xor
        )
      end

      def self.keywords_type
        @keywords_type ||= Set.new %w(
          Boolean Character Float Integer Natural Positive String
          Wide_Character Wide_Wide_Character
        )
      end

      id = /[a-zA-Z_][a-zA-Z_0-9]*/

      state :root do
        rule /[\s\n]+/, Text::Whitespace
        rule /--.*?$/, Comment::Single
        rule /[~^*!%&\[\](){}<>\|+=:;',.\/?-]/, Operator
        rule /"(\\\\|\\"|[^"])*"/, Str
        rule /\d+[lu]*/i, Num::Integer

        rule id do |m|
          name = m[0]

          if self.class.keywords.include? name
            token Keyword
          elsif self.class.keywords_type.include? name
            token Keyword::Type
          else
            token Name
          end
        end
      end
    end
  end
end