# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class SysML < RegexLexer
      title 'SysML'
      desc 'Systems Modeling Language v2 (SysML v2)'
      tag 'sysml'
      filenames '*.sysml', '*.kerml'
      mimetypes 'text/x-sysml', 'application/x-sysml'

      # SysML V2 Keywords
      def self.declarations
        @declarations ||= Set.new %w(
          action actor alias allocate analysis
          architecture as assert attribute
          binding calc case concern connection
          constraint decide def dependency
          doc entry enum enumeration epilogue
          event exhibit exit feature first
          flow for fork frame group
          import include individual
          interface item join language library
          merge message metadata model namespace
          objective occurrence package part
          perform portion port prologue
          rationale ref requirement
          return satisfy send snapshot
          state step struct
          subject succession timeslice transition
          usecase variant view
          viewpoint
        )
      end

      def self.modifiers
        @modifiers ||= Set.new %w(
          abstract derived private protected
          public readonly
        )
      end

      def self.relations
        @relations ||= Set.new %w(
          bind bound connect derive
          from in inout out
          redefines refine specializes subsets to trace
          validate verify
        )
      end

      def self.control_flow
        @control_flow ||= Set.new %w(
          if else then while loop do
        )
      end

      def self.logical_operators
        @logical_operators ||= Set.new %w(
          and or not xor implies
        )
      end

      def self.builtin_pseudo
        @builtin_pseudo ||= Set.new %w(
          this self super
        )
      end

      def self.types
        @types ||= Set.new %w(
          Anything Boolean Complex Integer Natural None Number Real String
        )
      end

      state :root do
        rule %r/\s+/m, Text::Whitespace
        rule %r(//.*?$), Comment::Single
        rule %r(/\*), Comment::Multiline, :comment

        rule %r/@[a-zA-Z_]\w*/, Name::Decorator

        rule %r/"/, Str::Double, :string
        rule %r/'(?:\\'|[^'])*'/, Name::Label # quoted identifiers

        rule %r/\b(?:true|false|null)\b/, Keyword::Constant

        rule %r/[a-zA-Z_]\w*/ do |m|
          name = m[0]

          if self.class.declarations.include?(name)
            token Keyword::Declaration
          elsif self.class.modifiers.include?(name)
            token Keyword::Pseudo
          elsif self.class.relations.include?(name) || self.class.control_flow.include?(name)
            token Keyword
          elsif self.class.logical_operators.include?(name)
            token Operator::Word
          elsif self.class.types.include?(name)
            token Keyword::Type
          elsif self.class.builtin_pseudo.include?(name)
            token Name::Builtin::Pseudo
          else
            token Name
          end
        end

        # Numbers
        rule %r/(?:0|[1-9]\d*)\.\d+(?:[eE][+-]?\d+)?/, Num::Float
        rule %r/(?:0|[1-9]\d*)(?:[eE][+-]?\d+)?/, Num::Integer

        rule %r/\.\./, Operator # Multiplicity bounds
        rule %r/[()\[\]{};:,.]/, Punctuation
        rule %r/::/, Punctuation
        rule %r/[-+\/*=<>!]+/, Operator
      end

      state :comment do
        rule %r([^/*]+), Comment::Multiline
        rule %r(/\*), Comment::Multiline, :push
        rule %r(\*/), Comment::Multiline, :pop!
        rule %r([/*]), Comment::Multiline
      end

      state :string do
        rule %r/[^\\"]+/, Str::Double
        rule %r/\\./, Str::Escape
        rule %r/"/, Str::Double, :pop!
      end
    end
  end
end
