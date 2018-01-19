# -*- coding: utf-8 -*- #

# TODO: 
# featurename at end of feature/lookup/table/...
# 



module Rouge
  module Lexers
    class OpenTypeFeature < RegexLexer
      title "OpenType"
      desc "OpenType feature code"
      tag 'opentype'
      aliases 'feature', 'fea'
      filenames '*.fea'
      # mimetypes 'text/x-python', 'application/x-python'

      def self.detect?(text)
        # return true if text.shebang?(/pythonw?(3|2(\.\d)?)?/)
      end

      def self.keywords
        @keywords ||= %w(
          Ascender Attach CapHeight CaretOffset CodePageRange Descender FontRevision 
          GlyphClassDef HorizAxis.BaseScriptList HorizAxis.BaseTagList HorizAxis.MinMax 
          IgnoreBaseGlyphs IgnoreLigatures IgnoreMarks LigatureCaretByDev LigatureCaretByIndex 
          LigatureCaretByPos LineGap MarkAttachClass MarkAttachmentType NULL Panose RightToLeft 
          TypoAscender TypoDescender TypoLineGap UnicodeRange UseMarkFilteringSet Vendor 
          VertAdvanceY VertAxis.BaseScriptList VertAxis.BaseTagList VertAxis.MinMax VertOriginY 
          VertTypoAscender VertTypoDescender VertTypoLineGap XHeight 

          anchorDef anchor anonymous anon by contour cursive device enumerate enum 
          exclude_dflt featureNames feature from ignore include_dflt include languagesystem 
          language lookupflag lookup markClass mark nameid name parameters position pos required 
          reversesub rsub script sizemenuname substitute subtable sub table useExtension 
          valueRecordDef winAscent winDescent
        )
      end


      identifier =        /[a-z_][a-z0-9_]*/i
      #dotted_identifier = /[a-z_.][a-z0-9_.]*/i

      state :root do
        rule /\n+/m, Text
        rule /^(:)(\s*)([ru]{,2}""".*?""")/mi do
          groups Punctuation, Text, Str::Doc
        end

        # whitespaces
        rule /[^\S\n]+/, Text
        # start with # = comment
        rule /#.*$/, Comment

        rule /\[|\]|\{|\}|\:|\(|\)|\.|\,|\;|\\|\-|\=|\%|\*|\/|\<|\>/, Punctuation

        #rule /(?</=J)(.*)(?/=K)/, Generic:Error


        # rule /\\\n/, Text
        # rule /\\/, Text
        # rule /@[a-zA-Z0-9_.]/,Function

        rule /(include )\b/, Keyword
        rule /!=|==|<<|>>|[-~+\/*%=<>&^|.]/, Operator

        # rule /(from)((?:\\\s|\s)+)(#{dotted_identifier})((?:\\\s|\s)+)(import)/ do
        #   groups Keyword::Namespace,
        #          Text,
        #          Name::Namespace,
        #          Text,
        #          Keyword::Namespace
        # end

        # rule /(import)(\s+)(#{dotted_identifier})/ do
        #   groups Keyword::Namespace, Text, Name::Namespace
        # end

        rule /(anonymous|anon|feature|lookup|table)((?:\s|\\\s)+)/ do
          groups Keyword, Text
          push :featurename
        end



        rule /`.*?`/, Str::Backtick
        rule /(?:r|ur|ru)"""/i, Str, :raw_tdqs
        # rule /(?:r|ur|ru)'''/i, Str, :raw_tsqs
        # rule /(?:r|ur|ru)"/i,   Str, :raw_dqs
        # rule /(?:r|ur|ru)'/i,   Str, :raw_sqs
        # rule /u?"""/i,          Str, :tdqs
        # rule /u?'''/i,          Str, :tsqs
        rule /u?\"/i,            Str, :dqs
        rule /u?\'/i,            Str, :sqs

        # rule /\"|\'+/, Generic::Deleted, :string
        rule /u?\(/i,            Str, :par

        # classes, start with @
        rule /@#{identifier}/i, Name::Class


        rule /(\})((?:\s|\\\s)*)((?:\s|\\\s)*)/  do
          groups Generic::Error
          push :featurenameEnd
        end
        

        # using negative lookbehind so we don't match property names
        rule /(?<!\.)#{identifier}/ do |m|
          if self.class.keywords.include? m[0]
            token Keyword
          # elsif self.class.exceptions.include? m[0]
          #   token Name::Builtin
          # elsif self.class.builtins.include? m[0]
          #   token Name::Builtin
          # elsif self.class.builtins_pseudo.include? m[0]
          #   token Name::Builtin::Pseudo
          else
            token Name
          end
        end



        # rule identifier, Name

        # rule /(\d+\.\d*|\d*\.\d+)(e[+-]?[0-9]+)?/i, Num::Float
        # rule /\d+e[+-]?[0-9]+/i, Num::Float
        # # rule /0[0-7]+/, Num::Oct
        # rule /0x[a-f0-9]+/i, Num::Hex
        # rule /\d+L/, Num::Integer::Long
        rule /\d+/, Num::Integer
      end

      state :featurename do
        rule identifier, Name::Function, :pop!
      end

      state :featurenameEnd do
        rule identifier, Generic::Error, :pop!
      end


      # state :raise do
      #   rule /from\b/, Keyword
      #   rule /raise\b/, Keyword
      #   rule /yield\b/, Keyword
      #   rule /\n/, Text, :pop!
      #   rule /;/, Punctuation, :pop!
      #   mixin :root
      # end

      # state :yield do
      #   mixin :raise
      # end

      state :strings do
        rule /%(\([a-z0-9_]+\))?[-#0 +]*([0-9]+|[*])?(\.([0-9]+|[*]))?/i, Str::Interpol
      end

      state :strings_double do
        rule /[^\\"%\n]+/, Str
        mixin :strings
      end

      state :strings_single do
        rule /[^\\'%\n]+/, Str
        mixin :strings
      end

      # state :nl do
      #   rule /\n/, Str
      # end

      state :escape do
        rule %r(\\
          ( [\\abfnrtv"']
          | \n
          | N{[a-zA-z][a-zA-Z ]+[a-zA-Z]}
          | u[a-fA-F0-9]{4}
          | U[a-fA-F0-9]{8}
          | x[a-fA-F0-9]{2}
          | [0-7]{1,3}
          )
        )x, Str::Escape
      end



      # state :string do
      #   # rule /\(?s\)\(\\\\|\\[0-7]+|\\.|[^"\'\\]\)/, Generic::Deleted
      #   # rule /"|\'/, Generic::Deleted, :pop!
      # end
      # state :raw_escape do
      #   rule /\\./, Str
      # end
      state :sqs do
        rule /'/, Str, :pop!
        mixin :escape
        mixin :strings_single
      end
      state :dqs do
        rule /"/, Str, :pop!
        mixin :escape
        mixin :strings_double
      end

    end
  end
end
