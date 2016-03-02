module Rouge
    module Lexers
        class BIML < RegexLexer
            title "BIML"
            desc "BIML, Business Intelligence Markup Language"
            tag 'biml'
            filenames '*.biml'
            
            def self.analyze_text(text)
                return 1 if text =~ /<\s*Biml\b/
            end
            
            # TODO: check if we can inherit partsome parts of the xml lexer?
            state :root do
                rule /[^<&]+/, Text
                rule /&\S*?;/, Name::Entity
                rule /<!\[CDATA\[.*?\]\]\>/, Comment::Preproc
                rule /<!--/, Comment, :comment
                rule /<\?.*?\?>/, Comment::Preproc
                rule /<![^>]*>/, Comment::Preproc

                rule %r(<#@\s*)m, Name::Tag, :directive_tag
                
                rule %r(<#=\s*)m, Name::Tag, :directive_as_csharp
                
                # directive tags
                rule %r(<#\s*)m, Name::Tag, :directive_as_csharp

                # open tags
                rule %r(<\s*[\w:.-]+)m, Name::Tag, :tag

                # self-closing tags
                rule %r(<\s*/\s*[\w:.-]+\s*>)m, Name::Tag
            end

            state :comment do
                rule /[^-]+/m, Comment
                rule /-->/, Comment, :pop!
                rule /-/, Comment
            end

            state :tag do
                rule /\s+/m, Text
                rule /[\w.:-]+\s*=/m, Name::Attribute, :attr
                rule %r(/?\s*>), Name::Tag, :pop!
            end

            state :attr do
                rule /\s+/m, Text
                rule /".*?"|'.*?'|[^\s>]+/, Str, :pop!
            end
            
            state :directive_as_csharp do
                rule /\s*#>\s*/m, Name::Tag, :pop! 
                rule %r(.*?(?=\s*#>\s*))m do
                    delegate CSharp
                end
            end
            
            state :directive_tag do
                rule /\s+/m, Text
                rule /[\w.:-]+\s*=/m, Name::Attribute, :attr
                rule /[\w]+\s*/m, Name::Attribute
                rule %r(/?\s*#>), Name::Tag, :pop!
            end
        end
    end
end