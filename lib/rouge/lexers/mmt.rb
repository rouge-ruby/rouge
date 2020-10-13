# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class MMT < RegexLexer
      title 'mmt'
      desc 'MMT Surface Syntax (uniformal.github.io)'
      tag 'mmt'
      aliases 'mmtx'
      mimetypes 'application/x-mmt'
      filenames '*.mmt','*.mmtx'
      state :root do
        rule %r/\s+/im, Text::Whitespace
        rule %r/\/T .*?❚/im, Comment::Multiline
        rule %r/\/\/.*?❚/im, Comment::Multiline

        rule %r/(document)((?: |\t)+)(\S+?)(?=\s+)/im do
          groups Keyword::Declaration,Text::Whitespace,Name::Namespace
        end

        rule %r/(meta)(\s+)(\S+)(\s+)([^❚]+)(\s*)(❚)/im do
          groups Keyword::Declaration,Text::Whitespace,Text,Text::Whitespace,Text,Text::Whitespace,Text
        end

        rule %r/(namespace)(\s+)(\S+?)(\s*)(❚)/im do
          groups Keyword::Namespace,Text::Whitespace,Text,Text::Whitespace,Text
        end

        rule %r/(import)(\s+)(\S+)(\s+)(\S+?)(\s*)(❚)/im do
          groups Keyword::Namespace,Text::Whitespace,Name::Namespace,Text::Whitespace,Text,Text::Whitespace,Text
        end

        rule %r/(fixmeta|ref|rule)(\s+)(\S+?)(\s*)(❚)/im do
          groups Comment::Preproc,Text::Whitespace,Text,Text::Whitespace,Text
        end

        rule %r/(diagram)\b/im, Keyword::Declaration, :diagramHeader
        rule %r/(theory)\b/im, Keyword::Declaration, :theoryHeader

        rule %r/(?:(total|implicit)(\s+))?(?:(total|implicit)(\s+))?(view)\b/im do
          groups Keyword,Text::Whitespace,Keyword,Text::Whitespace,Keyword::Declaration
          push :viewHeader
        end

        rule %r/[^❚]*?❚/im, Generic::Error
      end

      state :expectMD do
        rule %r/(\s*)(❚)/im do
          groups Text::Whitespace,Text
          pop!
        end
      end

      state :expectDD do
        rule %r/(\s*)(❙)/im do
          groups Text::Whitespace,Text
          pop!
        end
      end

      state :expectOD do
        rule %r/(\s*)(❘)/im do
          groups Text::Whitespace,Text
          pop!
        end
      end

      state :structuralFeatureHeader do
        rule %r/\s+/im, Text::Whitespace

        rule %r/([^\s(❙❚:=]+)(\s*)(?:(\()([^)]*)(\)))?(\s*)(?:(:)(\s*)([^❘❙❚=]+))?(\s*)(?:(=)(\s*)([^\s:❙❚]+))?(\s*)(❙)/im do
          groups Name::Class,Text::Whitespace,Punctuation,Name::Variable,Punctuation,Text::Whitespace,Punctuation,Text::Whitespace,Name::Variable,Text::Whitespace,Punctuation,Text::Whitespace,Text,Text::Whitespace,Text
          pop!
        end

        rule %r/([^\s(❙❚:=]+)(\s*)(?:(\()([^)]*)(\)))?(\s*)(?:(:)(\s*)([^❘❙❚=]+))?(\s*)/im do
          groups Name::Class,Text::Whitespace,Punctuation,Name::Variable,Punctuation,Text::Whitespace,Punctuation,Text::Whitespace,Name::Variable,Text::Whitespace
          push :moduleDefiniens
        end
      end

      state :theoryHeader do
        rule %r/\s+/im, Text::Whitespace

        rule %r/([^\s❙❚:=]+)(\s*)(?:(:)(\s*)([^\s❙❚=]+))?(\s*)(?:(>)([^❙❚=]+))?/im do
          groups Name::Class,Text::Whitespace,Punctuation,Text::Whitespace,Text,Text::Whitespace,Punctuation,Name::Variable
          push :moduleDefiniens
        end
      end

      state :moduleDefiniens do
        rule %r/\s+/im, Text::Whitespace
        rule %r/❘/im, Text
        rule %r/#+/im, Punctuation, :notationExpression
        rule %r/=/im, Punctuation, :moduleBody
        rule %r/❚/im do
          token Text
          pop!(2)
        end
      end

      state :viewHeader do
        rule %r/\s+/im, Text::Whitespace
        rule %r/(\S+)(\s*)(:)(\s*)(\S+)(\s*)(->|→)(\s*)([^❚=]+)/im do
          groups Name::Class,Text::Whitespace,Punctuation,Text::Whitespace,Text,Text::Whitespace,Punctuation,Text::Whitespace,Text
          push :moduleDefiniens
        end
      end

      state :diagramHeader do
        rule %r/\s+/im, Text::Whitespace

        rule %r/(\S+)(\s*)(:)(\s*)([^❚=]+)/im do
          groups Name::Variable,Text::Whitespace,Punctuation,Text::Whitespace,Name::Variable
          push :expression
        end

        rule %r/[^❚=]+/im, Name::Variable, :expression
        rule %r/❚/im, Text, :pop!
      end

      state :moduleBody do
        rule %r/\s+/im, Text::Whitespace
        rule %r/\/T .*?(❙|❚)/im, Comment::Multiline
        rule %r/\/\/.*?(❙|❚)/im, Comment::Multiline

        rule %r/(@_description)(\s+)([^❙])+(❙)/im do
          groups Keyword,Text::Whitespace,Literal::String,Text
        end

        rule %r/(meta)(\s+)(\S+)(\s+)([^❙❚]+)(\s*)(❙)/im do
          groups Keyword::Declaration,Text::Whitespace,Text,Text::Whitespace,Text,Text::Whitespace,Text
        end

        rule %r/(include)(\s+)([^❙]+)(❙)/im do
          groups Keyword::Namespace,Text::Whitespace,Text,Text
        end

        rule %r/(constant)(\s+)([^\s:❘❙]+)/im do
          groups Keyword::Declaration,Text::Whitespace,Name::Variable::Class
          push :constantDeclaration
        end

        rule %r/(rule)(\s+)([^❙]+)(\s*)(❙)/im do
          groups Keyword::Namespace,Text::Whitespace,Text,Text::Whitespace,Text
        end

        rule %r/(realize)(\s+)([^❙]+)(\s*)(❙)/im do
          groups Keyword,Text::Whitespace,Text,Text::Whitespace,Text
        end

        rule %r/(?:(total|implicit)(\s+))?(?:(total|implicit)(\s+))?(structure\b)/im do
          groups Keyword,Text::Whitespace,Keyword,Text::Whitespace,Keyword::Declaration
          push :structuralFeatureHeader
        end

        rule %r/theory\b/im, Keyword::Declaration, :theoryHeader

        rule %r/(?:(total|implicit)(\s+))?(?:(total|implicit)(\s+))?(view\b)/im do
          groups Keyword,Text::Whitespace,Keyword,Text::Whitespace,Keyword::Declaration
          push :viewHeader
        end

        rule %r/(#+)([^❙]+)(❙)/im do
          groups Literal::String::Doc,Literal::String::Doc,Text
        end

        rule %r/([^\s:=#❘❙❚]+)(\s+)(?=[^\s:=@#❘❙❚]+)/im do
          groups Keyword::Declaration,Text::Whitespace
          push :structuralFeatureHeader
        end

        rule %r/[^\s:=#❘❙❚]+/im, Name::Variable::Class, :constantDeclaration
        rule %r/[^❚]*?❙/im, Generic::Error

        rule %r/❚/im do
          token Text
          pop!(3)
        end
      end

      state :constantDeclaration do
        rule %r/\s+/im, Text::Whitespace
        rule %r/:/im, Punctuation, :expression
        rule %r/=/im, Punctuation, :expression
        rule %r/#+/im, Punctuation, :notationExpression

        rule %r/(@_description)(\s+)([^❘❙])+/im do
          groups Keyword,Text::Whitespace,Literal::String
        end

        rule %r/(@)([^❘❙]+)/im do
          groups Punctuation,Name::Constant
        end

        rule %r/role\b/im, Keyword, :expression

        rule %r/(meta)(\s+)(\S+)(\s+)([^❘❙]+)(\s*)(?=❘|❙)/im do
          groups Keyword::Declaration,Text::Whitespace,Text,Text::Whitespace,Text,Text::Whitespace
        end

        rule %r/\/\/[^❘❙]*/im, Comment::Multiline
        rule %r/❘/im, Text
        rule %r/❙/im, Text, :pop!
        rule %r/[^❙❚]*?=[^❚]*?❚/im, Generic::Error, :pop!
        rule %r/[^❚]*?❙/im, Generic::Error, :pop!
      end

      state :notationExpression do
        rule %r/\s+/im, Text::Whitespace
        rule %r/\d+/im, Literal::String::Interpol
        rule %r/%?((I|V|L)\d+[Td]*)(_(I|L)\d+[Td]*)*/im, Literal::String::Interpol
        rule %r/…/im, Literal::String::Interpol

        rule %r/(\bprec)(\s+)(-?\d+)/im do
          groups Keyword,Text::Whitespace,Literal::Number::Integer
          pop!
        end

        rule %r/([^\s\d…❘❙❚]+)/im, Literal::String::Symbol
        rule %r/(?=[❘❙❚])/im, Text::Whitespace, :pop!
      end

      state :expression do
        rule %r/\s+/im, Text::Whitespace
        rule %r/[^❘❙❚]*/im, Text, :pop!
      end
    end
  end
end
