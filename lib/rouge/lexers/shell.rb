module Rouge
  module Lexers
    ShellLexer = RegexLexer.new do
      lexer :basic do
        rule /
          \b(if|fi|else|while|do|done|for|then|return|function|case
            |select|continue|until|esac|elif
          )\s*\b
        /x, 'Keyword'

        rule /
          \b(alias|bg|bind|break|builtin|caller|cd|command|compgen
            |complete|declare|dirs|disown|echo|enable|eval|exec|exit
            |export|false|fc|fg|getopts|hash|help|history|jobs|kill|let
            |local|logout|popd|printf|pushd|pwd|read|readonly|set|shift
            |shopt|source|suspend|test|time|times|trap|true|type|typeset
            |ulimit|umask|unalias|unset|wait
          )\s*\b(?!\.)
        /x, 'Name.Builtin'

        rule /#.*\n/, 'Comment'

        rule /(\b\w+)(\s*)(=)/ do |_, var, ws, eq, &out|
          out.call 'Name.Variable', var
          out.call 'Text', ws
          out.call 'Operator', eq
        end

        rule /[\[\]{}()=]/, 'Operator'
        rule /&&|\|\|/, 'Operator'

        rule /<<</, 'Operator' # here-string
        rule /<<-?\s*(\'?)\\?(\w+)[\w\W]+?\2/, 'Literal.String'
      end

      lexer :data do
        rule /(?s)\$?"(\\\\|\\[0-7]+|\\.|[^"\\])*"/, 'String.Double'
        rule /(?s)\$?'(\\\\|\\[0-7]+|\\.|[^'\\])*'/, 'String.Single'
        rule /;/, 'Text'
        rule /\s+/, 'Text'
        rule /[^=\s\[\]{}()$"\'`\\<]+/, 'Text'
        rule /\d+(?= |\Z)/, 'Number'
        rule /\$#?(\w+|.)/, 'Name.Variable'
        rule /</, 'Text'
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
        rule /[-+*/%^|&]|\*\*|\|\|/, 'Operator'
        rule /\d+/, 'Number'
        mixin :root
      end

      lexer :root do
        mixin :basic
        rule /\$\(\(/, 'Keyword', :math
        rule /\$\(/, 'Keyword', :paren
        rule /\${#?/, 'Keyword', :curly
        rule /`/, 'String.Backtick', :backticks
        mixin :data
      end

      lexer :backticks do
        rule /`/, 'String.Backtick', :pop!
        mixin :root
      end

      mixin :root
    end
  end
end
