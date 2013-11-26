module Rouge
  module Lexers
    class Matlab < RegexLexer
      desc "Matlab"
      tag 'matlab'
      aliases 'm'
      filenames '*.m'
      mimetypes 'text/x-matlab', 'application/x-matlab'

      def self.analyze_text(text)
        return 0.51 if text.match(/^\s*% /) # % comments are a dead giveaway
      end

      def self.keywords
        @keywords = Set.new %w(
          break case catch classdef continue else elseif end for function
          global if otherwise parfor persistent return spmd switch try while
        )
      end

      def self.builtins
        load Pathname.new(__FILE__).dirname.join('matlab/builtins.rb')
        self.builtins
      end

      state :root do
        rule /\s+/m, Text # Whitespace
        rule /[a-zA-Z][_a-zA-Z0-9]*/m do |m|
          match = m[0]
          if self.class.keywords.include? match
            token Keyword
          elsif self.class.builtins.include? match
            token Name::Builtin
          else
            token Name
          end
        end
        rule %r{[(){};:,\/\\\]\[]}, Punctuation

        rule %r(%\{.*?%\})m, Comment::Multiline
        rule /%.*$/, Comment::Single

        rule /~=|==|<<|>>|[-~+\/*%=<>&^|.]/, Operator


        rule /(\d+\.\d*|\d*\.\d+)(e[+-]?[0-9]+)?/i, Num::Float
        rule /\d+e[+-]?[0-9]+/i, Num::Float
        rule /\d+L/, Num::Integer::Long
        rule /\d+/, Num::Integer

        mixin :strings
      end

      state :strings do
        rule /'.*?'/, Str::Single
      end
    end
  end
end
