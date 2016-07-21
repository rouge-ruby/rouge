# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Turtle < RegexLexer
      title "Turtle/TriG"
      desc "Terse RDF Triple Language, TriG"
      tag 'turtle'
      filenames *%w(*.ttl *.trig)
      mimetypes *%w(
        text/turtle
        application/trig
      )

      def self.analyze_text(text)
        start = text[0..1000]
        return 0.9 if start =~ %r(@prefix\b)
        return 0.9 if start =~ %r(@base\b)
        return 0.6 if start =~ %r(PREFIX\b)i
        return 0.6 if start =~ %r(BASE\b)i
      end

      state :root do
        rule /@base /, Keyword::Declaration
        rule /@prefix /, Keyword::Declaration
        rule /true/, Keyword::Constant
        rule /false/, Keyword::Constant
        
        rule /""".*"""/m, Literal::String
        rule /"([^"\\]|\\.)*"/, Literal::String
        rule /'''.*'''/m, Literal::String
        rule /'([^'\\]|\\.)*'/, Literal::String
        
        rule /#.*$/, Comment::Single
        
        rule /@[^\s,.; ]+/, Name::Attribute
        
        rule /[+-]?[0-9]+\.[0-9]*E[+-]?[0-9]+/, Literal::Number::Float
        rule /[+-]?\.[0-9]+E[+-]?[0-9]+/, Literal::Number::Float
        rule /[+-]?[0-9]+E[+-]?[0-9]+/, Literal::Number::Float

        rule /[+-]?[0-9]*\.[0-9]+?/, Literal::Number::Float

        rule /[+-]?[0-9]+/, Literal::Number::Integer

        rule /\./, Punctuation
        rule /,/, Punctuation
        rule /;/, Punctuation
        rule /\(/, Punctuation
        rule /\)/, Punctuation
        rule /\{/, Punctuation
        rule /\}/, Punctuation
        rule /\[/, Punctuation
        rule /\]/, Punctuation
        rule /\^\^/, Punctuation
        
        rule /<[^>]*>/, Name::Label

        rule /base /i, Keyword::Declaration
        rule /prefix /i, Keyword::Declaration
        rule /GRAPH /, Keyword
        rule /a /, Keyword

        rule /\s/, Text::Whitespace

        rule /[^:;<>#@"\(\).\[\]\{\} ]+:/, Name::Namespace
        rule /[^:;<>#@"\(\).\[\]\{\} ]+/, Name
        
      end
    end
  end
end
