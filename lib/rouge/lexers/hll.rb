# frozen_string_literal: true

module Rouge
    module Lexers
        class HLL < RegexLexer
            title 'HLL'
            desc 'High Level Language'
            tag 'hll'
            filenames '*.hll'
            mimetypes 'text/x-hll'

            state :comments do
                rule %r(///.*?$), Comment::Doc
                rule %r(//[^/]*?$), Comment::Single
                rule %r(/\*[^\*].*?\*/)m, Comment::Multiline
                rule %r(/\*\*.*?\*/)m, Comment::Doc
            end

            state :root do
                rule /\s+/, Text::Whitespace
                mixin :comments
                rule /Namespaces: \w/, Name::Namespace
                mixin :section
                rule /[(){}\[\];:,|!^]+/, Punctuation
                rule /:=/, Punctuation
                rule /\d+/, Num::Integer
                rule /\w+/ do |m|
                    if self.class.keywords.include?(m[0])
                        token Keyword
                    elsif
                        token Name
                    end
                end
                rule /[~&#+\-><*=]/, Operator
            end

            state :section do
                rule /(D|d)eclarations/, Name::Builtin
                rule /(D|d)efinitions/, Name::Builtin
                rule /(I|i)nputs/, Name::Builtin
                rule /(O|o)utputs/, Name::Builtin
                rule /(P|p)roof obligations/, Name::Builtin
                rule /(C|c)onstants/, Name::Builtin
                rule /(C|c)onstraints/, Name::Builtin
            end

            def self.keywords
                @keywords ||= Set.new %w(
                  if then else elif lambda false true int bool X I pre
                  ALL SOME SELECT SUM PROD sort)
            end
        end
    end
end
