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
            def self.keywords
                @keywords ||= Set.new %w(
                  if then else elif lambda
                  false true True TRUE False FALSE
                  enum tuple struct signed unsigned
                  X I pre PRE
                  cast
                  bin2s
                  bin2u
                  blocks
                  Blocks
                  ALL SOME SELECT SUM PROD CONJ DISJ sort
                  Namespaces namespaces
                  declarations Declarations definitions Definitions
                  inputs Inputs proof Proof obligations Obligations
                  Constants constants Constraints constraints
                  Outputs outputs
                  type Types u2bin with)
            end
        end
    end
end
