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
        doc enum enumeration epilogue
        event exhibit feature flow
        for frame group
        import include individual
        interface item language library
        metadata model namespace
        objective package part
        perform port prologue
        rationale ref requirement
        return satisfy send
        state step struct
        subject succession transition
        usecase variant view
        viewpoint
      ).join('|')

      MODIFIERS = %w(
        abstract derived private protected
        public readonly
      ).join('|')

      RELATIONS = %w(
        bind bound connect
        from in inout out
        redefines subsets to
      ).join('|')

      TYPES = %w(
        Boolean Integer Real String
      ).join('|')

      state :root do
        rule %r/\s+/m, Text::Whitespace
        rule %r(//.*?$), Comment::Single
        rule %r(/\*.*?\*/)m, Comment::Multiline

        rule %r/"/, Str::Double, :string
        rule %r/'(?:\\'|[^'])*'/, Name::Label # quoted identifiers

        rule %r/\b(?:#{DECLARATIONS})\b/, Keyword::Declaration
        rule %r/\b(?:#{MODIFIERS})\b/, Keyword::Pseudo
        rule %r/\b(?:#{RELATIONS})\b/, Keyword
        rule %r/\b(?:#{TYPES})\b/, Keyword::Type

        rule %r/\b(?:true|false|null)\b/, Keyword::Constant

        # Numbers
        rule %r/(?:0|[1-9]\d*)\.\d+(?:[eE][+-]?\d+)?/, Num::Float
        rule %r/(?:0|[1-9]\d*)(?:[eE][+-]?\d+)?/, Num::Integer

        rule %r/[a-zA-Z_]\w*/, Name

        rule %r/[()\[\]{};:,.]/, Punctuation
        rule %r/::/, Punctuation
        rule %r/[-+\/*=<>!]+/, Operator
      end

      state :string do
        rule %r/[^\\"]+/, Str::Double
        rule %r/\\./, Str::Escape
        rule %r/"/, Str::Double, :pop!
      end
    end
  end
end
