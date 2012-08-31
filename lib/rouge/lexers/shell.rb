module Rouge
  module Lexers
    ShellLexer = RegexLexer.create do
      name 'shell'
      aliases 'bash', 'zsh', 'ksh', 'sh'

      # because ruby closures are weird
      root = nil

      KEYWORDS = %w(
        if fi else while do done for then return function case
        select continue until esac elif
      ).join('|')

      BUILTINS = %w(
        alias bg bind break builtin caller cd command compgen
        complete declare dirs disown echo enable eval exec exit
        export false fc fg getopts hash help history jobs kill let
        local logout popd printf pushd pwd read readonly set shift
        shopt source suspend test time times trap true type typeset
        ulimit umask unalias unset wait
      ).join('|')

      basic = lexer do

        rule /#.*\n/, 'Comment'

        rule /\b(#{KEYWORDS})\s*\b/, 'Keyword'

        rule /\b(#{BUILTINS})\s*\b(?!\.)/, 'Name.Builtin'

        rule /(\b\w+)(=)/ do |_, var, eq, &out|
          out.call 'Name.Variable', var
          out.call 'Operator', eq
        end

        rule /[\[\]{}()=]/, 'Operator'
        rule /&&|\|\|/, 'Operator'

        rule /<<</, 'Operator' # here-string
        rule /<<-?\s*(\'?)\\?(\w+)[\w\W]+?\2/, 'Literal.String'
      end

      data = lexer do
        # TODO: this should be its own sublexer so we can capture
        # interpolation and such
        rule /$?"(\\"|[^"])*"/, 'String.Double'

        # single quotes are much easier than double quotes - we can
        # literally just scan until the next single quote.
        # POSIX: Enclosing characters in single-quotes ( '' )
        # shall preserve the literal value of each character within the
        # single-quotes. A single-quote cannot occur within single-quotes.
        rule /$?'[^']*'/, 'String.Single'

        rule /;/, 'Text'
        rule /\s+/, 'Text'
        rule /[^=\s\[\]{}()$"\'`\\<]+/, 'Text'
        rule /\d+(?= |\Z)/, 'Number'
        rule /\$#?(\w+|.)/, 'Name.Variable'
        rule /</, 'Text'
      end

      curly = lexer do
        rule /}/, 'Keyword', :pop!
        rule /:-/, 'Keyword'
        rule /[a-zA-Z0-9_]+/, 'Name.Variable'
        rule /[^}:"'`$]+/, 'Punctuation'
        mixin root
      end

      paren = lexer do
        rule /\)/, 'Keyword', :pop!
        mixin root
      end

      math = lexer do
        rule /\)\)/, 'Keyword', :pop!
        rule %r([-+*/%^|&]|\*\*|\|\|), 'Operator'
        rule /\d+/, 'Number'
        mixin root
      end

      backticks = lexer do
        rule /`/, 'String.Backtick', :pop!
        mixin root
      end

      root = lexer do
        mixin basic
        rule /\$\(\(/, 'Keyword', math
        rule /\$\(/, 'Keyword', paren
        rule /\${#?/, 'Keyword', curly
        rule /`/, 'String.Backtick', backticks
        mixin data
      end

      mixin root
    end
  end
end
