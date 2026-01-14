# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Dylan < RegexLexer
      title 'Dylan'
      desc 'Dylan Language'
      tag 'dylan'
      filenames '*.dylan'
      # Definitions from the Dylan Reference Manual
      core_word=%w(define end handler let local macro otherwise)
      begin_word=%w(begin block case for if method)
      function_word=[]
      define_body_word=%w(class library method module)
      define_list_word=%w(constant variable domain)
      reserved_word=core_word+begin_word+function_word+define_body_word+define_list_word
      punctuation=%w'( ) , . ; [ ] { } :: - = == => #( #[ ## ? ?? ?= ... '
      hash_word=%w(#t #f #next #rest #key #all-keys #include)
      graphic_character=%w(! & * < > | ^ $ % @ _)
      special_character=%w(- + ~ ? / =)
      binary_operator=%w(+ - * / ^ = == ~= ~== < <= > >= & | :=)
      unary_operator=%w(- ~)
      binary_integer=%r(#b[01]+)
      octal_integer=%r(#o[0-7]+)
      decimal_integer=%r([+-]?[0-9]+)
      hex_integer=%r(#x[0-9a-f]+)i
      ratio=%r([+-]?[0-9]+/[0-9]+)
      floating_point=%r([+-]?([0-9]*\.[0-9]+(E[+-]?[0-9]+)?|[0-9]+\.[0-9]*(E[+-]?[0-9]+)?|[0-9]+E[+-]?[0-9]+))i
      word_character=/[a-z0-9#{Regexp.escape((graphic_character+special_character).join(''))}]/i
      initial_word_character=/[\\a-z0-9#{Regexp.escape(graphic_character.join(''))}]/i
      word=%r(#{initial_word_character}#{word_character}*)i
      punc = Regexp.new(punctuation.map {|s| Regexp.escape(s)}.join("|"))
      oper = Regexp.new((binary_operator+unary_operator).map {|s| Regexp.escape(s)}.join("|"))
      # Words in < > brackets are class names but only by convention
      def angle?(matched)
        /^<.+>$/ =~ matched[0]
      end
      state :root do
        # Comments
        rule %r(//.*?$), Comment::Single
        rule %r(/\*.*?\*/)m, Comment::Multiline
        # Keywords
        rule %r/(#{reserved_word.join('|')})\b/, Keyword
        rule %r/(#{hash_word.join('|')})\b/, Keyword::Constant
        # Numbers
        rule ratio, Literal::Number::Other
        rule floating_point, Literal::Number::Float
        rule binary_integer, Literal::Number::Bin
        rule octal_integer, Literal::Number::Oct
        rule decimal_integer, Literal::Number::Integer
        rule hex_integer, Literal::Number::Hex
        # Names
        rule  %r/[-\w\d\.]+:/, Name::Tag
        rule word do |w|
          token angle?(w) ? Name::Class : Name
        end
        # Operators and punctuation
        rule punc, Operator
        rule oper, Operator
        rule %r/:/, Operator # For 'constrained names'
        # Strings, characters and whitespace
        rule %r/"(\\\\|\\"|[^"])*"/, Str
        rule %r/'([^\\']|(\\[\\'abefnrt0])|(\\[0-9a-f]+))'/, Str::Char
        rule %r/\s+/, Text::Whitespace
      end
    end
  end
end
