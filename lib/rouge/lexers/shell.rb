module Rouge
  module Lexers
    class ShellLexer < RegexLexer
      tag 'shell'
      aliases 'bash', 'zsh', 'ksh', 'sh'

      KEYWORDS = %w(
        if fi else while do done for then return function
        select continue until esac elif in
      ).join('|')

      BUILTINS = %w(
        alias bg bind break builtin caller cd command compgen
        complete declare dirs disown echo enable eval exec exit
        export false fc fg getopts hash help history jobs kill let
        local logout popd printf pushd pwd read readonly set shift
        shopt source suspend test time times trap true type typeset
        ulimit umask unalias unset wait
      ).join('|')

      lexer :basic do
        rule /#.*\n/, 'Comment'

        rule /\b(#{KEYWORDS})\s*\b/, 'Keyword'
        rule /\bcase\b/, 'Keyword', :case

        rule /\b(#{BUILTINS})\s*\b(?!\.)/, 'Name.Builtin'

        rule /(\b\w+)(=)/ do |_, var, eq, &out|
          out.call 'Name.Variable', var
          out.call 'Operator', eq
        end

        rule /[\[\]{}()=]/, 'Operator'
        rule /&&|\|\|/, 'Operator'
        # rule /\|\|/, 'Operator'

        rule /<<</, 'Operator' # here-string
        rule /<<-?\s*(\'?)\\?(\w+)[\w\W]+?\2/, 'Literal.String'
      end

      lexer :double_quotes do
        rule /"/, 'Literal.String.Double', :pop!
        rule /\\./, 'Literal.String.Escape'
        mixin :interp
        rule /[^"`\\$]+/, 'Literal.String.Double'
      end

      lexer :data do
        # TODO: this should be its own sublexer so we can capture
        # interpolation and such
        rule /$?"/, 'Literal.String.Double', :double_quotes

        # single quotes are much easier than double quotes - we can
        # literally just scan until the next single quote.
        # POSIX: Enclosing characters in single-quotes ( '' )
        # shall preserve the literal value of each character within the
        # single-quotes. A single-quote cannot occur within single-quotes.
        rule /$?'[^']*'/, 'Literal.String.Single'

        rule /;/, 'Text'
        rule /\s+/, 'Text'
        rule /[^=\s\[\]{}()$"\'`\\<]+/, 'Text'
        rule /\d+(?= |\Z)/, 'Number'
        rule /</, 'Text'
        mixin :interp
      end

      lexer :curly do
        rule /}/, 'Keyword', :pop!
        rule /:-/, 'Keyword'
        rule /[a-zA-Z0-9_]+/, 'Name.Variable'
        rule /[^}:"'`$]+/, 'Punctuation'
        mixin :root
      end

      lexer :paren do
        rule /\)/, 'Keyword', :pop!
        mixin :root
      end

      lexer :math do
        rule /\)\)/, 'Keyword', :pop!
        rule %r([-+*/%^|&]|\*\*|\|\|), 'Operator'
        rule /\d+/, 'Number'
        mixin :root
      end

      lexer :case do
        lexer :stanza do
          rule /;;/, 'Punctuation', :pop!
          mixin :root
        end

        rule /\besac\b/, 'Keyword', :pop!
        rule /\)/, 'Punctuation', :stanza
        mixin :data
      end

      lexer :backticks do
        rule /`/, 'Literal.String.Backtick', :pop!
        mixin :root
      end

      lexer :interp do
        rule /\$\(\(/, 'Keyword', :math
        rule /\$\(/, 'Keyword', :paren
        rule /\${#?/, 'Keyword', :curly
        rule /`/, 'Literal.String.Backtick', :backticks
        rule /\$#?(\w+|.)/, 'Name.Variable'
      end

      lexer :root do
        mixin :basic
        mixin :data
      end

      mixin :root
    end
  end
end
