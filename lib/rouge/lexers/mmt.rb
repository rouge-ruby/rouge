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
        rule %r/\/T .*?\u275a/im, Comment::Multiline
        rule %r/\/\/.*?\u275a/im, Comment::Multiline

        rule %r/(document)((?: |\t)+)(\S+?)(?=\s+)/im do
          groups Keyword::Declaration,Text::Whitespace,Name::Namespace
        end

        rule %r/(meta)(\s+)(\S+)(\s+)([^\u275a]+)(\s*)(\u275a)/im do
          groups Keyword::Declaration,Text::Whitespace,Text,Text::Whitespace,Text,Text::Whitespace,Text
        end

        rule %r/(namespace)(\s+)(\S+?)(\s*)(\u275a)/im do
          groups Keyword::Namespace,Text::Whitespace,Text,Text::Whitespace,Text
        end

        rule %r/(import)(\s+)(\S+)(\s+)(\S+?)(\s*)(\u275a)/im do
          groups Keyword::Namespace,Text::Whitespace,Name::Namespace,Text::Whitespace,Text,Text::Whitespace,Text
        end

        rule %r/(fixmeta|ref|rule)(\s+)(\S+?)(\s*)(\u275a)/im do
          groups Comment::Preproc,Text::Whitespace,Text,Text::Whitespace,Text
        end

        rule %r/(diagram)\b/im, Keyword::Declaration, :diagramHeader
        rule %r/(theory)\b/im, Keyword::Declaration, :theoryHeader

        rule %r/(?:(total|implicit)(\s+))?(?:(total|implicit)(\s+))?(view)\b/im do
          groups Keyword,Text::Whitespace,Keyword,Text::Whitespace,Keyword::Declaration
          push :viewHeader
        end

        rule %r/[^\u275a]*?\u275a/im, Generic::Error
      end

      state :expectMD do
        rule %r/(\s*)(\u275a)/im do
          groups Text::Whitespace,Text
          pop!
        end
      end

      state :expectDD do
        rule %r/(\s*)(\u2759)/im do
          groups Text::Whitespace,Text
          pop!
        end
      end

      state :expectOD do
        rule %r/(\s*)(\u2758)/im do
          groups Text::Whitespace,Text
          pop!
        end
      end

      state :structuralFeatureHeader do
        rule %r/\s+/im, Text::Whitespace

        rule %r/([^\s(\u2759\u275a:=]+)(\s*)(?:(\()([^)]*)(\)))?(\s*)(?:(:)(\s*)([^\u2758\u2759\u275a=]+))?(\s*)(?:(=)(\s*)([^\s:\u2759\u275a]+))?(\s*)(\u2759)/im do
          groups Name::Class,Text::Whitespace,Punctuation,Name::Variable,Punctuation,Text::Whitespace,Punctuation,Text::Whitespace,Name::Variable,Text::Whitespace,Punctuation,Text::Whitespace,Text,Text::Whitespace,Text
          pop!
        end

        rule %r/([^\s(\u2759\u275a:=]+)(\s*)(?:(\()([^)]*)(\)))?(\s*)(?:(:)(\s*)([^\u2758\u2759\u275a=]+))?(\s*)/im do
          groups Name::Class,Text::Whitespace,Punctuation,Name::Variable,Punctuation,Text::Whitespace,Punctuation,Text::Whitespace,Name::Variable,Text::Whitespace
          push :moduleDefiniens
        end
      end

      state :theoryHeader do
        rule %r/\s+/im, Text::Whitespace

        rule %r/([^\s\u2759\u275a:=]+)(\s*)(?:(:)(\s*)([^\s\u2759\u275a=]+))?(\s*)(?:(>)([^\u2759\u275a=]+))?/im do
          groups Name::Class,Text::Whitespace,Punctuation,Text::Whitespace,Text,Text::Whitespace,Punctuation,Name::Variable
          push :moduleDefiniens
        end
      end

      state :moduleDefiniens do
        rule %r/\s+/im, Text::Whitespace
        rule %r/\u2758/im, Text
        rule %r/#+/im, Punctuation, :notationExpression
        rule %r/=/im, Punctuation, :moduleBody
        rule %r/\u275a/im do
          token Text
          pop!(2)
        end
      end

      state :viewHeader do
        rule %r/\s+/im, Text::Whitespace
        rule %r/(\S+)(\s*)(:)(\s*)(\S+)(\s*)(->|\u2192)(\s*)([^\u275a=]+)/im do
          groups Name::Class,Text::Whitespace,Punctuation,Text::Whitespace,Text,Text::Whitespace,Punctuation,Text::Whitespace,Text
          push :moduleDefiniens
        end
      end

      state :diagramHeader do
        rule %r/\s+/im, Text::Whitespace

        rule %r/(\S+)(\s*)(:)(\s*)([^\u275a=]+)/im do
          groups Name::Variable,Text::Whitespace,Punctuation,Text::Whitespace,Name::Variable
          push :expression
        end

        rule %r/[^\u275a=]+/im, Name::Variable, :expression
        rule %r/\u275a/im, Text, :pop!
      end

      state :moduleBody do
        rule %r/\s+/im, Text::Whitespace
        rule %r/\/T .*?(\u2759|\u275a)/im, Comment::Multiline
        rule %r/\/\/.*?(\u2759|\u275a)/im, Comment::Multiline

        rule %r/(@_description)(\s+)([^\u2759])+(\u2759)/im do
          groups Keyword,Text::Whitespace,Literal::String,Text
        end

        rule %r/(meta)(\s+)(\S+)(\s+)([^\u2759\u275a]+)(\s*)(\u2759)/im do
          groups Keyword::Declaration,Text::Whitespace,Text,Text::Whitespace,Text,Text::Whitespace,Text
        end

        rule %r/(include)(\s+)([^\u2759]+)(\u2759)/im do
          groups Keyword::Namespace,Text::Whitespace,Text,Text
        end

        rule %r/(constant)(\s+)([^\s:\u2758\u2759]+)/im do
          groups Keyword::Declaration,Text::Whitespace,Name::Variable::Class
          push :constantDeclaration
        end

        rule %r/(rule)(\s+)([^\u2759]+)(\s*)(\u2759)/im do
          groups Keyword::Namespace,Text::Whitespace,Text,Text::Whitespace,Text
        end

        rule %r/(realize)(\s+)([^\u2759]+)(\s*)(\u2759)/im do
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

        rule %r/(#+)([^\u2759]+)(\u2759)/im do
          groups Literal::String::Doc,Literal::String::Doc,Text
        end

        rule %r/([^\s:=#\u2758\u2759\u275a]+)(\s+)(?=[^\s:=@#\u2758\u2759\u275a]+)/im do
          groups Keyword::Declaration,Text::Whitespace
          push :structuralFeatureHeader
        end

        rule %r/[^\s:=#\u2758\u2759\u275a]+/im, Name::Variable::Class, :constantDeclaration
        rule %r/[^\u275a]*?\u2759/im, Generic::Error

        rule %r/\u275a/im do
          token Text
          pop!(3)
        end
      end

      state :constantDeclaration do
        rule %r/\s+/im, Text::Whitespace
        rule %r/:/im, Punctuation, :expression
        rule %r/=/im, Punctuation, :expression
        rule %r/#+/im, Punctuation, :notationExpression

        rule %r/(@_description)(\s+)([^\u2758\u2759])+/im do
          groups Keyword,Text::Whitespace,Literal::String
        end

        rule %r/(@)([^\u2758\u2759]+)/im do
          groups Punctuation,Name::Constant
        end

        rule %r/role\b/im, Keyword, :expression

        rule %r/(meta)(\s+)(\S+)(\s+)([^\u2758\u2759]+)(\s*)(?=\u2758|\u2759)/im do
          groups Keyword::Declaration,Text::Whitespace,Text,Text::Whitespace,Text,Text::Whitespace
        end

        rule %r/\/\/[^\u2758\u2759]*/im, Comment::Multiline
        rule %r/\u2758/im, Text
        rule %r/\u2759/im, Text, :pop!
        rule %r/[^\u2759\u275a]*?=[^\u275a]*?\u275a/im, Generic::Error, :pop!
        rule %r/[^\u275a]*?\u2759/im, Generic::Error, :pop!
      end

      state :notationExpression do
        rule %r/\s+/im, Text::Whitespace
        rule %r/\d+/im, Literal::String::Interpol
        rule %r/%?((I|V|L)\d+[Td]*)(_(I|L)\d+[Td]*)*/im, Literal::String::Interpol
        rule %r/\u2026/im, Literal::String::Interpol

        rule %r/(\bprec)(\s+)(-?\d+)/im do
          groups Keyword,Text::Whitespace,Literal::Number::Integer
          pop!
        end

        rule %r/([^\s\d\u2026\u2758\u2759\u275a]+)/im, Literal::String::Symbol
        rule %r/(?=[\u2758\u2759\u275a])/im, Text::Whitespace, :pop!
      end

      state :expression do
        rule %r/\s+/im, Text::Whitespace
        rule %r/[^\u2758\u2759\u275a]*/im, Text, :pop!
      end
    end
  end
end
