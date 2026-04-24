# -*- coding: utf-8 -*- #

require_relative 'sql'

module Rouge
  module Lexers
    class HQL < SQL
      title "HQL"
      desc "Hive Query Language SQL dialect"
      tag 'hql'
      filenames '*.hql'

      lazy { require_relative 'hql/keywords' }

      prepend :root do
        # a double-quoted string is a string literal in Hive QL.
        rule %r/"/, Str::Double, :double_string

        # interpolation of variables through ${...}
        rule %r/\$\{/, Name::Variable, :hive_variable
      end

      prepend :single_string do
        rule %r/\$\{/, Name::Variable, :hive_variable
        rule %r/[^\\'\$]+/, Str::Single
      end

      prepend :double_string do
        rule %r/\$\{/, Name::Variable, :hive_variable
        # double-quoted strings are string literals so need to change token
        rule %r/"/, Str::Double, :pop!
        rule %r/[^\\"\$]+/, Str::Double
      end

      state :hive_variable do
        rule %r/\}/, Name::Variable, :pop!
        rule %r/[^\}]+/, Name::Variable
      end

    end
  end
end
