# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    module TypescriptCommon
      def keywords
        @keywords ||= super + Set.new(%w(
          is namespace static private protected public
          implements readonly
        ))
      end

      def declarations
        @declarations ||= super + Set.new(%w(
          type abstract
        ))
      end

      def reserved
        @reserved ||= super + Set.new(%w(
          string any void number namespace module
          declare default interface keyof
        ))
      end

      def builtins
        @builtins ||= super + %w(
          Pick Partial Readonly Record
        )
      end
    end
  end
end
