# -*- coding: utf-8 -*- #
# frozen_string_literal: true

require_relative 'jinja'

module Rouge
  module Lexers
    class Twig < Jinja
      title "Twig"
      desc "Twig template engine (twig.sensiolabs.org)"

      tag "twig"

      filenames '*.twig'

      mimetypes 'application/x-twig', 'text/html+twig'

      def self.keywords
        @keywords ||= Set.new %w(
          as do extends flush from import include use else starts
          ends with without autoescape endautoescape block
          endblock embed endembed filter endfilter for endfor
          if endif macro endmacro sandbox endsandbox set endset
          spaceless endspaceless
        )
      end

      def self.tests
        @tests ||= Set.new %w(
          constant defined divisibleby empty even iterable null odd sameas
        )
      end

      def self.pseudo_keywords
        @pseudo_keywords ||= Set.new %w(true false none)
      end

      def self.word_operators
        @word_operators ||= Set.new %w(b-and b-or b-xor is in and or not)
      end
    end
  end
end
