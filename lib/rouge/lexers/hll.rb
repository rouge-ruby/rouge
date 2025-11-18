module Rouge
    module Lexers
        class HLL < RegexLexer
            title 'HLL'
            desc 'High Level Language'
            tag 'hll'
            filenames '*.hll'
            mimetypes 'text/x-hll'

            state :comment do
                rule %r(///.*?$), Comment::Doc
                rule %r(//[^/].*?$), Comment::Single
                rule %r(/\*[^\*].*?\*/)m, Comment::Multiline
                rule %r(/\*\*.*?\*/)m, Comment::Doc
            end

            state :root do
                rule %r(\s+), Text::Whitespace
                rule %r/\w::/, Name::Namespace
                rule %r/"[^"]*"/, Literal::String
                rule %r/'[^']*'/, Literal::String
                mixin :comment
                rule %r([(){}\[\];:,|!^]+), Punctuation
                rule %r(:=), Punctuation
                rule %r(\d+), Literal::Number
                rule %r(\w+) do |m|
                    if self.class.keywords.include?(m[0])
                        token Keyword
                    elsif self.class.type_keywords.include?(m[0])
                        token Keyword::Type
                    else
                        token Name
                    end
                end
                rule %r([~&#+\-><*=]), Operator
            end

            def self.type_keywords
                @type_keywords ||= Set.new %w(bool int)
            end
            # Keywords as indicated in
            # https://hal.science/hal-03356342v1/
            # but without types (which are in the type_keywords value)
            def self.keywords
                @keywords ||= Set.new %w(
                  ALL
                  bin2s
                  bin2u
                  Blocks
                  blocks
                  cast
                  CONJ
                  constants
                  Constants
                  constraints
                  Constraints
                  declarations
                  Declarations
                  definitions
                  Definitions
                  DISJ
                  elif
                  else
                  false
                  FALSE
                  False
                  I
                  if
                  inputs
                  Inputs
                  lambda
                  namespaces
                  Namespaces
                  obligations
                  Obligations
                  outputs
                  Outputs
                  population_count_eq
                  population_count_gt
                  population_count_lt
                  pre
                  PRE
                  PROD
                  proof
                  Proof
                  s2bin
                  SELECT
                  signed
                  SOME
                  sort
                  struct
                  SUM
                  then
                  true
                  True
                  TRUE
                  tuple
                  types
                  Types
                  u2bin
                  unsigned
                  with
                  X)
            end
        end
    end
end
