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

      def self.detect?(text)
        return true if text.scan(%r/\b(?:package|part def|requirement|connection|doc|import)\b/).size > 2
        false
      end

      # SysML V2 Keywords
      DECLARATIONS = %w(
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
      ).join('|')

      MODIFIERS = %w(
        abstract derived private protected
        public readonly
      ).join('|')

      RELATIONS = %w(
        bind bound connect derive
        from in inout out
        redefines refine specializes subsets to trace
        validate verify
      ).join('|')

      CONTROL_FLOW = %w(
        if else then while loop do
      ).join('|')

      LOGICAL_OPERATORS = %w(
        and or not xor implies
      ).join('|')

      BUILTIN_PSEUDO = %w(
        this self super
      ).join('|')

      TYPES = %w(
        Anything Boolean Complex Integer Natural None Number Real String
      ).join('|')

      state :root do
        rule %r/\s+/m, Text::Whitespace
        rule %r(//.*?$), Comment::Single
        rule %r(/\*), Comment::Multiline, :comment

        rule %r/@[a-zA-Z_]\w*/, Name::Decorator

        rule %r/"/, Str::Double, :string
        rule %r/'(?:\\'|[^'])*'/, Name::Label # quoted identifiers

        rule %r/\b(?:#{DECLARATIONS})\b/, Keyword::Declaration
        rule %r/\b(?:#{MODIFIERS})\b/, Keyword::Pseudo
        rule %r/\b(?:#{RELATIONS}|#{CONTROL_FLOW})\b/, Keyword
        rule %r/\b(?:#{LOGICAL_OPERATORS})\b/, Operator::Word
        rule %r/\b(?:#{TYPES})\b/, Keyword::Type
        rule %r/\b(?:#{BUILTIN_PSEUDO})\b/, Name::Builtin::Pseudo

        rule %r/\b(?:true|false|null)\b/, Keyword::Constant

        # Numbers
        rule %r/(?:0|[1-9]\d*)\.\d+(?:[eE][+-]?\d+)?/, Num::Float
        rule %r/(?:0|[1-9]\d*)(?:[eE][+-]?\d+)?/, Num::Integer

        rule %r/[a-zA-Z_]\w*/, Name

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
