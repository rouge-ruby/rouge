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
        @handlebars = Handlebars.new(parent: @html)
      end

      def start
        super
        @html.reset!
        @handlebars.reset!
      end

      def reset!
        super
        @html.reset!
        @handlebars.reset!
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

          rule %r/.+?(?=<\/template>)/m do
            delegate @handlebars
          end

          rule %r/.+/m do
            delegate @handlebars
          end
        end
      end
    end
  end
end
