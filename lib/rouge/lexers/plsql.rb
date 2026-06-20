# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class PLSQL < RegexLexer
      title "PLSQL"
      desc "Procedural Language Structured Query Language for Oracle relational database"
      tag 'plsql'
      filenames '*.pls', '*.typ', '*.tps', '*.tpb', '*.pks', '*.pkb', '*.pkg', '*.trg'
      mimetypes 'text/x-plsql'

      lazy { require_relative 'plsql/keywords' }

      state :root do
        delimiter_map = { '{' => '}', '[' => ']', '(' => ')', '<' => '>' }
        # eat whitespace including newlines
        rule %r/\s+/m, Text

        # Comments
        rule %r/--.*/, Comment::Single
        rule %r(/\*), Comment::Multiline, :multiline_comments

        # literals
        # Q' operator quoted string literal
        rule %r/q'(.)/i do |m|
          close = Regexp.escape(delimiter_map[m[1]] || m[1])
          # the opening q'X
          token Operator
          push do
            rule %r/(?:#{close}[^']|[^#{close}]'|[^#{close}'])+/m, Str::Other
            rule %r/#{close}'/, Operator, :pop!
          end
        end
        rule %r/'/, Operator, :single_string
        # A double-quoted string refers to a database object in our default SQL
        rule %r/"/, Operator, :double_string
        # preprocessor directive treated as special comment
        rule %r/(\$(?:IF|THEN|ELSE|ELSIF|ERROR|END|(?:\$\$?[a-z]\w*)))(\s+)/im do
          groups Comment::Preproc, Text
        end

        # Numbers
        rule %r/[+-]?(?:(?:\.\d+(?:[eE][+-]?\d+)?)|\d+\.(?:\d+(?:[eE][+-]?\d+)?)?)[fFdD]?/, Num::Float
        rule %r/[+-]?\d+/, Num::Integer

        # Operators
        # Special semi-operator, but this seems an appropriate classification
        rule %r/%(?:TYPE|ROWTYPE|FOUND|ISOPEN|NOTFOUND|ROWCOUNT)\b/i, Name::Attribute
        # longer ones come first on purpose! It matters to regex engine
        rule %r/=>|\|\||\*\*|<<|>>|\.\.|<>|[:!~^<>]=|[-+%\/*=<>@&!^\[\]]/, Operator
        rule %r/(NOT|AND|OR|LIKE|BETWEEN|IN)(\s)/im do
          groups Operator::Word, Text
        end
        rule %r/(IS)(\s+)(?:(NOT)(\s+))?(NULL\b)/im do
          groups Operator::Word, Text, Operator::Word, Text, Operator::Word
        end

        # Punctuation
        # special case of dot followed by a name. notice the lookahead assertion
        rule %r/\.(?=\w)/ do
          token Punctuation
          push :dotnames
        end
        rule %r/[;:()\[\],.]/, Punctuation

        # Special processing for keywords with multiple contexts
        #
        # this madness is to keep the word "replace" from being treated as a builtin function in this context
        rule %r/(create)(\s+)(?:(or)(\s+)(replace)(\s+))?(package|function|procedure|type)(?:(\s+)(body))?(\s+)([a-z][\w$]*)/im do
          groups Keyword::Reserved, Text, Keyword::Reserved, Text, Keyword::Reserved, Text, Keyword::Reserved, Text, Keyword::Reserved, Text, Name
        end
        # similar for MERGE keywords
        rule %r/(when)(\s+)(?:(not)(\s+))?(matched)(\s+)(then)(\s+)(update|insert)\b(?:(\s+)(set)(\s+))?/im do
          groups Keyword::Reserved, Text, Keyword::Reserved, Text, Keyword::Reserved, Text, Keyword::Reserved, Text, Keyword::Reserved, Text, Keyword::Reserved, Text
        end

        #
        # General keyword classification with sepcial attention to names
        # in a chained "dot" notation.
        #
        keywords %r/[a-zA-Z][\w$]*/ do
          transform(&:upcase)
          rule KEYWORDS_TYPE, Keyword, :post_name
          rule KEYWORDS_FUNC, Name::Function, :post_name
          rule KEYWORDS_RESERVED, Keyword::Reserved, :post_name
          rule KEYWORDS, Keyword, :post_name
          default Name, :post_name
        end
      end

      state :post_name do
        rule %r/[.]/, Punctuation, :dotnames
        rule(//) { pop! }
      end

      state :multiline_comments do
        rule %r/([*][^\/]|[^*])+/m, Comment::Multiline
        rule %r([*]\/), Comment::Multiline, :pop!
      end

      state :single_string do
        rule %r/\\./, Str::Escape
        rule %r/''/, Str::Escape
        rule %r/'/, Operator, :pop!
        rule %r/[^\\']+/m, Str::Single
      end

      state :double_string do
        rule %r/\\./, Str::Escape
        rule %r/""/, Str::Escape
        rule %r/"/, Operator, :pop!
        rule %r/[^\\"]+/m, Name::Variable
      end

      state :dotnames do
        rule %r/".*?"/, Str::Symbol
        rule %r/[.]/, Punctuation

        # if we are followed by a dot and another name, we are an ordinary name
        rule %r/([a-zA-Z][\w\$]*)(\.(?=\w))/ do
          groups Name, Punctuation
        end
        # this rule WILL be true if something pushed into our state. That is our state contract
        keywords %r/[a-zA-Z][\w\$]*/ do
          transform(&:upcase)

          # The Function lookup allows collection methods like COUNT, FIRST, LAST, etc.. to be
          # classified correctly. Occasionally misidentifies ordinary names as builtin functions,
          # but seems to be as correct as we can get without becoming a full blown parser
          rule KEYWORDS_FUNC, Name::Function, :pop!
          default Name, :pop!
        end
      end
    end
  end
end
