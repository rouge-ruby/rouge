# -*- coding: utf-8 -*- #
# frozen_string_literal: true

# http://www.adobe.com/devnet/opentype/afdko/topic_feature_file_syntax.html

module Rouge
  module Lexers
    class OpenTypeFeature < RegexLexer
      title "OpenTypeFeature"
      desc "OpenType feature code"
      tag 'opentypefeature'
      aliases 'feature', 'fea', 'opentype'
      filenames '*.fea'

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


      identifier = /[a-z_][a-z0-9\/_]*/i

      state :root do
        rule /\n+/m, Text
        rule /\s+/, Text::Whitespace
        rule /#.*$/, Comment

        # feature <tag>
        rule /(anonymous|anon|feature|lookup|table)((?:\s|\\\s)+)/ do
          groups Keyword, Text
          push :featurename
        end
        # } <tag> ;
        rule /(\})((?:\s|\\\s)*)((?:\s|\\\s)*)/ do
          groups Punctuation, Text
          push :featurename
        end
        # solve include( ../path)
        rule /(include)/i, Keyword, :includepath

        rule /[\[\]\/(\){},.:;-=%*<>']/, Punctuation

        rule /`.*?/, Str::Backtick
        rule /\"/i, Str, :dqs

        # classes, start with @<nameOfClass
        rule /@#{identifier}/i, Name::Class

        # using negative lookbehind so we don't match property names
        rule /(?<!\.)#{identifier}/ do |m|
          if self.class.keywords.include? m[0]
            token Keyword
          else
            token Name
          end
        end

        rule identifier, Name
        rule /-?\d+/, Num::Integer
      end

      state :featurename do
        rule identifier, Name::Function, :pop!
      end

      state :includepath do
        rule /\s+/, Text::Whitespace
        rule /\)/i, Num::Integer, :pop!
        rule /\(/i, Num::Integer
        rule /[a-z0-9\/_.]*/i, Str
      end

      state :strings do
        rule /%(\([a-z0-9_]+\))?[-#0 +]*([0-9]+|[*])?(\.([0-9]+|[*]))?/i, Str::Interpol
      end

      state :strings_double do
        rule /[^\\"%\n]+/, Str
        mixin :strings
      end

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

      state :dqs do
        rule /"/, Str, :pop!
        mixin :escape
        mixin :strings_double
      end


    end
  end
end
