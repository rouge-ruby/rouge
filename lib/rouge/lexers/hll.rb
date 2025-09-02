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
                rule %r(//[^/]*?$), Comment::Single
                rule %r(/\*[^\*].*?\*/)m, Comment::Multiline
                rule %r(/\*\*.*?\*/)m, Comment::Doc
            end

            state :root do
                rule %r(\s+), Text::Whitespace
                mixin :comment
                rule %r(Namespaces: \w), Name::Namespace
                mixin :section
                rule %r([(){}\[\];:,|!^]+), Punctuation
                rule %r(:=), Punctuation
                rule %r(\d+), Num::Integer
                rule %r(\w+) do |m|
                    if self.class.keywords.include?(m[0])
                        token Keyword
                    else
                        token Name
                    end
                end
                rule %r([~&#+\-><*=]), Operator
            end

            state :section do
                rule %r((D|d)eclarations), Name::Builtin
                rule %r((D|d)efinitions), Name::Builtin
                rule %r((I|i)nputs), Name::Builtin
                rule %r((O|o)utputs), Name::Builtin
                rule %r((P|p)roof (O|o)bligations), Name::Builtin
                rule %r((C|c)onstants), Name::Builtin
                rule %r((C|c)onstraints), Name::Builtin
            end

            def self.keywords
                @keywords ||= Set.new %w(
                  if then else elif lambda false true int bool X I pre
                  ALL SOME SELECT SUM PROD sort)
            end
        end
    end
end
