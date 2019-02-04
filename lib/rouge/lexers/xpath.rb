module Rouge
  module Lexers
    class XPath < RegexLexer
      title 'XPath'
      desc 'XPath 2.0'
      tag 'xpath'

      def self.regexify(list)
        Regexp.new(list.map {
            |x| Regexp.escape(x)
        }.join('|'))
      end

      # Terminal literals:
      # https://www.w3.org/TR/xpath-30/#terminal-symbols
      ncName = /[a-z_][a-z_\-.0-9]*/i
      qName = /(?:#{ncName})(?::#{ncName})?/
      digits = /[0-9]+/
      decimalLiteral = /\.#{digits}|#{digits}\.[0-9]*/
      doubleLiteral = /(\.#{digits})|#{digits}(\.[0-9]*)?[eE][+-]?#{digits}/
      stringLiteral = /("(("")|[^"])*")|('(('')|[^'])*')/
      commentStart = /\(:/

      # Terminal symbols:
      # https://www.w3.org/TR/xpath-30/#id-terminal-delimitation
      kindTest = self.regexify(%w(
        element attribute schema-element schema-attribute
        comment text node document-node
      ))
      kindTestForPi = self.regexify(%w(processing-instruction))
      axes = self.regexify(%w(
        child descendant attribute self descendant-or-self
        following-sibling following namespace
        parent ancestor preceding-sibling preceding ancestor-or-self
      ))
      operators = self.regexify(%w(, = := >= >> > <= << < - * != + // / |))
      keyword_operators = self.regexify(%w(then else return in satisfies))
      word_operators = self.regexify(%w(
        and or eq ge gt le lt ne is
        div mod idiv
        intersect except union
        to
      ))

      # Lexical states:
      # https://www.w3.org/TR/xquery-xpath-parsing/#XPath-lexical-states
      # https://lists.w3.org/Archives/Public/public-qt-comments/2004Aug/0127.html
      state :root do
        rule /\s+/m, Text

        rule doubleLiteral, Num::Float, :operator
        rule decimalLiteral, Num::Float, :operator
        rule digits, Num, :operator
        rule stringLiteral, Literal::String, :operator
        rule /\.\.|\.|\*/, Operator, :operator
        rule /(#{ncName})(\s*)(:)(\s*)(\*)/ do
          groups Name::Tag, Text, Punctuation, Text, Keyword::Reserved, :operator
        end
        rule /\)/, Punctuation, :operator
        rule /(\*)(\s*)(:)(\s*)(#{ncName})/ do
          groups Keyword::Reserved, Text, Punctuation, Text, Name::Tag, :operator
        end

        rule /\$/, Name::Variable, :varname
        rule /(for|some|every)(\s*)(\$)/ do
          groups Keyword, Text, Name::Variable
          push :varname
        end

        rule /(#{kindTest})(\s*)(\()/ do
          push :operator
          groups Keyword, Text, Punctuation, :kindtest
        end

        rule /(#{kindTestForPi})(\s*)(\()/ do
          push :operator
          groups Keyword, Text, Punctuation, :kindtestforpi
        end

        rule commentStart, Comment, :comment

        rule /[,({}]/, Punctuation
        rule /(if)(\s*)(\()/ do
          groups Keyword, Text, Punctuation
        end
        rule /(#{qName})(\s*)(\()/ do
          groups Name::Function, Text, Punctuation
        end
        rule /@/, Name::Attribute, :attrname
        rule %r((-|\+|/|//)), Operator
        rule /(#{axes})(\s*)(::)/ do
          groups Keyword, Text, Operator
        end

        rule qName, Name::Tag, :operator
      end

      state :operator do
        rule operators, Operator, :root
        rule /\s+#{word_operators}(\s+|$)/, Operator::Word, :root
        rule keyword_operators, Keyword, :root
        rule /\[/, Punctuation, :root

        rule /(cast(able)?)(\s+)(as)/ do
          groups Keyword, Text, Keyword, :singletype
        end

        rule /(instance)(\s+)(of)|(treat)(\s+)(as)/ do
          groups Keyword, Text, Keyword, :itemtype
        end

        rule /\$/, Name::Variable, :varname
        rule /(for)(\s*)(\$)/ do
          groups Keyword, Text, Name::Variable, :varname
        end

        rule commentStart, Comment, :comment

        rule /[)?\]]/, Punctuation

        rule stringLiteral, Literal::String
        rule /(\s+)/m, Text
      end

      state :singletype do
        rule qName, Keyword::Type, :operator
        rule commentStart, Comment, :comment
      end

      state :itemtype do
        rule /\s+/m, Text

        rule /(void)(\s*)(\()(\s*)(\))/ do
          groups Keyword::Type, Text, Punctuation, Text, Punctuation, :operator
        end

        rule commentStart, Comment, :comment

        rule /(#{kindTest})(\s*)(\()/ do
          push :occurrenceindicator
          groups Keyword, Text, Punctuation, :kindtest
        end

        rule /(#{kindTestForPi})(\s*)(\()/ do
          push :occurrenceindicator
          groups Keyword, Text, Punctuation, :kindtestforpi
        end

        rule /(item)(\s*)(\()(\s*)(\))/ do
          groups Keyword, Text, Punctuation, Text, Punctuation, :occurrenceindicator
        end

        rule operators, Operator, :root
        rule word_operators, Operator::Word, :root
        rule keyword_operators, Keyword, :root
        rule /[\[)]/, Punctuation, :root
        # todo: we still lex *, +, / and //, even though they are illegal here
        # todo: this is because they are part of operators

        rule /(cast(able)?)(\s+)(as)/ do
          groups Keyword, Text, Keyword, :singletype
        end

        rule /(instance)(\s+)(of)|(treat)(\s+)(as)/ do
          groups Keyword, Text, Keyword, :itemtype
        end

        rule qName, Keyword::Type, :occurrenceindicator
      end

      state :kindtest do
        rule /\)/, Punctuation, :pop!

        rule /\*/, Keyword, :closekindtest
        rule qName, Name, :closekindtest

        rule /(element|schema-element)(\s*)(\()/ do
          group Keyword, Text, Punctuation, :kindtest
        end

        rule commentStart, Comment, :comment
      end

      state :kindtestforpi do
        rule /\)/, Punctuation, :pop!
        rule commentStart, Comment, :comment
        rule ncName, Name
        rule stringLiteral, Literal::String
      end

      state :closekindtest do
        rule /\)/, Punctuation, :pop!
        rule /,/, Punctuation, :kindtest
        rule /\?/, Punctuation
        rule commentStart, Comment, :comment
      end

      state :occurrenceindicator do
        rule commentStart, Comment, :comment
        rule /(?![?*+])/, :operator
        rule /[?*+]/, Operator, :operator
      end

      state :varname do
        rule /\s+/m, Text
        rule qName, Name::Variable, :operator
        rule commentStart, Comment, :comment
      end

      state :attrname do
        rule /\s+/m, Text
        rule qName, Name::Attribute, :operator
        rule commentStart, Comment, :comment
      end

      state :comment do
        rule /:\)/, Comment, :pop!
        rule /[^:(]+/m, Comment
        rule commentStart, Comment, :comment
        rule /:/, Comment
      end
    end
  end
end
