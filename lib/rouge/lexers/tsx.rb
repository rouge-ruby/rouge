module Rouge
  module Lexers
    load_lexer 'typescript.rb'

    class TSX < Typescript
      desc 'tsx'
      tag 'tsx'
      aliases 'tsx', 'typescript-react'
      filenames '*.tsx'

      mimetypes 'text/x-tsx', 'application/x-tsx'

      id = Javascript.id_regex

      def start_embed!
        @embed ||= TSX.new(options)
        @embed.reset!
        @embed.push(:expr_start)
        push :tsx_embed_root
      end

      def tag_token(name)
        name[0] =~ /\p{Lower}/ ? Name::Tag : Name::Class
      end

      start { @html = HTML.new(options) }

      state :tsx_tags do
        rule /</, Punctuation, :tsx_element
      end

      state :tsx_internal do
        rule %r(</) do
          token Punctuation
          goto :tsx_end_tag
        end

        rule /{/ do
          token Str::Interpol
          start_embed!
        end

        rule /[^<>{]+/ do
          delegate @html
        end

        mixin :tsx_tags
      end

      prepend :expr_start do
        mixin :tsx_tags
      end

      state :tsx_tag do
        mixin :comments_and_whitespace
        rule /#{id}/ do |m|
          token tag_token(m[0])
        end

        rule /[.]/, Punctuation
      end

      state :tsx_end_tag do
        mixin :tsx_tag
        rule />/, Punctuation, :pop!
      end

      state :tsx_element do
        rule /#{id}=/, Name::Attribute, :tsx_attribute
        mixin :tsx_tag
        rule />/ do token Punctuation; goto :tsx_internal end
        rule %r(/>), Punctuation, :pop!
      end

      state :tsx_attribute do
        rule /"(\\[\\"]|[^"])*"/, Str::Double, :pop!
        rule /'(\\[\\']|[^'])*'/, Str::Single, :pop!
        rule /{/ do
          token Str::Interpol
          pop!
          start_embed!
        end
      end

      state :tsx_embed_root do
        rule /[.][.][.]/, Punctuation
        rule /}/, Str::Interpol, :pop!
        mixin :tsx_embed
      end

      state :tsx_embed do
        rule /{/ do delegate @embed; push :tsx_embed end
        rule /}/ do delegate @embed; pop! end
        rule /[^{}]+/ do
          delegate @embed
        end
      end
    end
  end
end

