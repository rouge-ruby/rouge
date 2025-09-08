# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    module GlimmerCommon
      def self.extended(base)
        base.prepend :root do
          rule %r/<template\b/ do
            token base::Name::Tag
            push :template_tag
          end
        end
      end

      def initialize(*)
        super
        @html = HTML.new(options)
      end

      def start
        super
        @html.reset!
      end

      def reset!
        super
        @html.reset!
      end

      def self.included(base)
        base.state :template_tag do
          rule %r/>/ do
            token base::Name::Tag
            pop!
            push :template_content
          end

          # Handle attributes on template tag
          rule %r/\s+/, base::Text
          rule %r/[a-zA-Z_][\w-]*/, base::Name::Attribute
          rule %r/=/, base::Operator
          rule %r/"[^"]*"/, base::Str::Double
          rule %r/'[^']*'/, base::Str::Single
        end

        base.state :template_content do
          rule %r/<\/template>/ do
            token base::Name::Tag
            pop!
          end

          # Handle Handlebars-style interpolation
          rule %r/{{/ do
            token base::Str::Interpol
            push :handlebars_expr
          end

          # Delegate HTML content to HTML lexer
          rule %r/[^{<]+/ do
            delegate @html
          end

          rule %r/[<{]/ do
            delegate @html
          end
        end

        base.state :handlebars_expr do
          rule %r/}}/ do
            token base::Str::Interpol
            pop!
          end

          # Handle nested braces
          rule %r/{/ do
            token base::Punctuation
            push
          end

          rule %r/}/ do
            token base::Punctuation
            pop!
          end

          # Handlebars content
          rule %r/[^{}]+/, base::Str::Interpol
        end
      end
    end
  end
end
