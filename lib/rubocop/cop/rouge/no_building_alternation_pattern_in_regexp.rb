# frozen_string_literal: true

module RuboCop
  module Cop
    module Rouge
      # Checks for the use of `.join('|')` or `Regexp.union` inside
      # interpolated regular expressions.
      #
      # Building alternation patterns by joining arrays or using
      # `Regexp.union` inside a regexp harms performance — the regex
      # engine must backtrack through every alternative on each match
      # attempt. It also risks quoting bugs when values contain regex
      # metacharacters.
      #
      # Prefer a `Set` lookup with a simple regex pattern instead.
      #
      # @example
      #   # bad — joins an array into a huge alternation regex
      #   KEYWORDS = %w[if else while ...]
      #   rule %r/\b(#{KEYWORDS.join('|')})\b/, Keyword
      #
      #   # bad — Regexp.union inside a regex has the same problem
      #   rule %r/#{Regexp.union(keywords)}/
      #
      #   # good — simple regex + Set lookup
      #   KEYWORDS = Set.new(%w[if else while ...])
      #   rule %r/\w+/ do |m|
      #     if KEYWORDS.include?(m[0])
      #       token Keyword
      #     else
      #       token Name
      #     end
      #   end
      #
      class NoBuildingAlternationPatternInRegexp < RuboCop::Cop::Base
        MSG = 'Avoid building alternation patterns inside a regexp. ' \
              'Use a Set lookup with a simple regex pattern for performance.'

        # @!method join_pipe_call?(node)
        #   Checks if a node is a `.join('|')` or `.join("|")` call.
        def_node_matcher :join_pipe_call?, <<~PATTERN
          (send _ :join (str "|"))
        PATTERN

        # @!method regexp_union_call?(node)
        #   Checks if a node is a `Regexp.union(...)` call.
        def_node_matcher :regexp_union_call?, <<~PATTERN
          (send (const nil? :Regexp) :union ...)
        PATTERN

        def on_regexp(node)
          node.children.each do |child|
            next unless child.begin_type?

            find_offending_calls(child)
          end
        end

        private

        def find_offending_calls(begin_node)
          begin_node.each_descendant(:send) do |send_node|
            next unless join_pipe_call?(send_node) || regexp_union_call?(send_node)

            add_offense(send_node)
          end
        end
      end
    end
  end
end
