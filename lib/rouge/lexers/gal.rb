# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class GAL < C
      tag 'gal'
      filenames '*.gal'

      title "GAL"
      desc "The Guarded Action Language"

      # optional comment or whitespace
      ws = %r((?:\s|//.*?\n|/[*].*?[*]/)+)
      id = /[a-zA-Z_][a-zA-Z0-9_\.]*/
      pid = /\$[a-zA-Z_][a-zA-Z0-9_]*/
      
      def self.keywords
        @keywords ||= Set.new %w(
          gal composite import interface extends 
	  TRANSIENT typedef hotbit
	  transition synchronization label predicate
	  for if else abort fixpoint
	  self main
	  property bounds reachable invariant never ctl ltl
	  AG AF AX EG EF EX A E U W M R X
	  true false
        )
      end

      def self.keywords_type
        @keywords_type ||= Set.new %w(
          int array
        )
      end

      def self.reserved
        @reserved ||= Set.new %w(
	  AG AF AX EG EF EX A E U W M R X
        )
      end
      
      append :statements do 
	rule pid do |m|
	  name = m[0]
	  token Name::Builtin
	end
      end
    end
  end
end
