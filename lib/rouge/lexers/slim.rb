module Rouge
  module Lexers
    class Slim < RegexLexer
      include Indentation
      desc 'Thhe Slim templating system for Ruby (slim-lang.com)'

      tag 'slim'
      filenames '*.slim'

      def self.analyze_text(text)
        return 1 if text =~ /^doctype/
      end

      def ruby
        @ruby ||= Ruby.new(options)
      end

      def javascript
        @javascript ||= Javascript.new(options)
      end

      state :root do
        rule /\s*\n/, Text
        rule(/\s*/) { |m| token Text; indentation(m[0]) }
      end

      state :content do
        mixin :css

        rule /(doctype)( )(.*?)$/i do
          groups Name::Namespace, Punctuation, Text
          pop!
        end

        rule /javascript:/ do
          token Name::Decorator
          pop!
          starts_block :javascript
          javascript.reset!
        end

        rule /(\|)(.*)/ do |m|
          groups Punctuation, Text
          pop!
          starts_block :text_block
        end

        rule /(title|p|h[1-9])(.*)/ do
          groups Name::Tag, Text
          goto :tag
        end

         rule /-|=/ do
           token Punctuation
           reset_stack
           push :ruby_line
         end

        rule(/\w+/) { token Name::Tag; goto :tag }
      end

      state :tag do
        mixin :css
        rule /\s*\n/, Text, :pop!
        rule /(\s?)([^\"]\w+)(\s?=\s?\"?)([^\"\n]+)(\"?)/ do
          groups Punctuation, Name::Attribute, Punctuation, Str, Punctuation
          goto :tag
        end

        rule(/\s?=\s?.+/) { delegate ruby }
      end

      state :ruby_line do
        mixin :indented_block

        rule(/,[ \t]*\n/) { delegate ruby }
        rule /[ ]\|[ \t]*\n/, Str::Escape
        rule(/.*?(?=(,$| \|)?[ \t]*$)/) { delegate ruby }
      end

      state :text_block do
        rule /.*?\n/, Text, :pop!
      end

      state :javascript do
        rule /([^#\n]|#[^{\n]|(\\\\)*\\#\{)+/ do
          delegate javascript
        end
        mixin :indented_block
      end

      state :indented_block do
        rule(/\n/) { token Text; reset_stack }
      end

      state :css do
        rule(/\.\w+/) { token Name::Class; goto :tag }
        rule(/#\w+/) { token Name::Function; goto :tag }
      end

      state :interpolation do
        rule /(\\#\{)(.*?)(\})/ do |m|
          token Str::Interpol, m[1]
          delegate ruby, m[2]
          token Str::Interpol, m[3]
        end
      end
    end
  end
end
