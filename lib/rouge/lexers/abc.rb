# -*- coding: utf-8 -*- #
# frozen_string_literal: true

# Need to match /[^\r\n]*/ instead of /.*/
# Seems like . matches \n

module Rouge
  module Lexers
    class Abc < RegexLexer
      title "Abc"
      desc "Abc music notation"
      tag "abc"
      aliases "abc"
      filenames "*.abc"
      mimetypes "text/vnd.abc", "text/x-abc"

      start do
        # Nothing to do, yet
      end

      decorations = %w!+ <( <) > >( >) ^ 0 1 2 3 4 5 accent
        arpeggio breath coda courtesy crescendo( crescendo) dacapo
        dacoda D.C. D.C.alcoda D.C.alfine diminuendo( diminuendo)
        downbow D.S. D.S.alcoda D.S.alfine editorial emphasis f
        fermata ff fff ffff fine invertedfermata invertedturn
        invertedturnx longphrase lowermordent marcato mediumphrase mf
        mordent mp open p plus pp ppp pppp pralltriller roll segno sfz
        shortphrase slide snap tenuto thumb trill trill( trill) turn
        turnx upbow uppermordent wedge!

      instructions = %w"abc-charset abc-version abc-include abc-creator linebreak decoration"

      @@UNKNOWN = Text
      @@QUOTE = Str::Double
      @@CHORD = Name::Attribute
      @@CHORD_PITCH = Str::Backtick
      @@KEY = Keyword::Reserved
      @@LYRICS = Keyword::Reserved
      @@CONTINUATION = Text::Whitespace
      @@LYRICS_VALUE = Str::Regex
      @@FIELD = Keyword::Declaration
      @@FIELD_VALUE = Str
      @@INLINE_FIELD = Str::Escape# @@FIELD
      @@BAR_LINE = Punctuation
      @@OCTAVE = Operator
      @@ACCIDENTAL = Operator
      @@NOTE = Name::Constant# Str::Symbol
      @@REST = @@NOTE
      @@DECORATION = Name::Decorator
      @@BUILTIN_DECORATION = Name::Builtin
      @@GRACE = Punctuation
      @@VOICE = Name::Constant
      @@DIRECTIVE = Comment::Preproc
      @@DIRECTIVE_BUILTIN = Name::Builtin
      @@DIRECTIVE_NAME = Name::Tag
      @@DIRECTIVE_BEGIN_LABEL = Name::Variable
      @@DIRECTIVE_ARGS = Name::Attribute
      @@XREF = Keyword::Namespace
      @@XREF_VALUE = Name::Namespace
      @@TITLE = Generic::Heading
      @@DURATION = Num::Integer
      @@TUPLET = Name::Function# Keyword::Variable
      @@SLUR = Operator
      @@TIE = Operator
      @@TEXT_MULTILINE = Str::Heredoc

      @@RE_EOL = /(?:\r\n?|\n)/
      @@RE_COMMENT = /%[^\r\n]*?/

      state :root do
        rule /^$/ do
          @last_field = nil
        end
        rule @@RE_EOL, Text
        # Directives must be at beginning of line
        rule /[\t ]+#{@@RE_COMMENT}$/o, Comment
        rule %r(
          ^(%%|I:)
          (begin)
          (text)
          ([^%\r\n]+?)? # Arguments
          (%[^\r\n]+?)? # Comment
          $
        )xm do |m|
          type = m[3]
          groups @@DIRECTIVE, @@DIRECTIVE_NAME, @@DIRECTIVE_BEGIN_LABEL, @@DIRECTIVE_ARGS, Comment
          push :begin_text
        end
        rule %r/
          ^(%%|\\|I:)
          (\S+?(?=\s))  # Name
          ([^%\r\n]+?)? # Arguments
          (%[^\r\n]+?)? # Comment
          $
        /ox do |m|
          if (%r|#{instructions.map{|s|Regexp.escape s}.join('|')}|o =~ m[2])
            type = @@DIRECTIVE_BUILTIN
          else
            type = @@DIRECTIVE_NAME
          end
          groups @@DIRECTIVE, type, @@DIRECTIVE_ARGS, Comment
        end

        mixin :check_field
        #mixin :check_comment
        mixin :body
      end

      state :check_field do
        rule /^([a-z+])(:)([ \t]*)/i do |m|
          field_type = @@FIELD
          next_state = nil
          # + means repeat last field
          if m[1] == "+"
            tmp_field = @last_field
          else
            tmp_field = m[1] unless m[1] == "+"
          end
          case tmp_field
          when "X"
            field_type = @@XREF
            next_state = :xref
          when "w"
            next_state = :lyrics
          when "K"
            field_type = @@KEY
          when "T"
            field_type = @@TITLE
          end
          field_type = Error if m[1] == "+" && !@last_field
          groups field_type, Punctuation, Text
          if next_state
            push next_state
          else
            push do
              case tmp_field
              when "T"
                field_value_type = field_type
              else
                field_value_type = @@FIELD_VALUE
              end
              mixin :entity
              mixin :line_continuation
              mixin :escape
              rule @@RE_COMMENT, Comment
              rule @@RE_EOL, Text, :pop!
              rule /[^\r\n]/, field_value_type
            end
          end
          if /[XI]/ =~ tmp_field
            @last_field = nil
          else
            @last_field = m[1] unless field_type == Error || m[1] == "+"
          end
        end
      end

      state :xref do
        rule /\d+/, @@XREF_VALUE
        rule /\d+#{@@RE_EOL}/o, @@XREF_VALUE, :pop!

        rule /([ \t]*)(%[^\r\n]*)/ do
          groups Text, Comment
        end
        rule @@RE_EOL, Text, :pop!
        mixin :check_comment
        rule /[^\r\n]*/, Error
      end

      state :decorations do
        rule /(!)([^!\r\n]+?)(!)/ do |m|
          if (%r|#{decorations.map{|s|Regexp.escape s}.join('|')}|o =~ m[2])
            tokenType = @@BUILTIN_DECORATION
          else
            tokenType =  @@DECORATION
          end
          groups Punctuation, tokenType, Punctuation
        end
      end

      state :body do
        mixin :decorations
        rule /(\[)([a-z])(:)([^\r\n]*?)(\])/i do |w|
          if w[2] == "K"
            field_type = @@KEY
          else
            field_type = @@FIELD
          end
          groups @@INLINE_FIELD, field_type, Punctuation, @@FIELD_VALUE, @@INLINE_FIELD
        end

        rule /\([2-9]((:[\(2-9]?)){0,2}/, @@TUPLET

        rule /([=_^]*)([a-g])([,\']*)([<>\d\/]*)/i do
          groups @@ACCIDENTAL, @@NOTE, @@OCTAVE, @@DURATION
        end

        rule /[_^]/, @@ACCIDENTAL
        rule /[,\']/, @@ACCIDENTAL
        rule %r/
          ([.:]?\|+)?
          [ \t]*?\[[1-9]+ # Alternate ending no. 1
          ([-,][1-9]+)*   # More alternate endings
        /x, @@BAR_LINE
        rule /[|:\[\]]/, @@BAR_LINE
        rule /(")([?<>@^]?)/ do
          groups Str::Double, Operator
          push :string
        end

        rule /[.~HJLMNOPRSTuv]/, @@BUILTIN_DECORATION
        rule /[<>\d\/]/, @@DURATION

        rule /(\{\/?|})/i, @@GRACE
        rule /[xz]/i, @@REST

        rule /y&/, Operator

        rule /\([,']?/, @@SLUR
        rule /\)/, @@SLUR
        rule /-/, @@TIE
        rule /\s+/, Text
        mixin :line_continuation

        # http://abcnotation.com/wiki/abc:standard:v2.2#tune_body
        rule /[#*;?@]/, Error # Reserved for future use
        # All printable ASCII characters may be used in tune body
        mixin :check_comment
        rule /[ -~]/, @@UNKNOWN
        # Everything else is an error
      end

      state :line_continuation do
        rule /(\\[ \t]*)(%[^\r\n]*?)?(#{@@RE_EOL})/o do
          groups Text::Whitespace, Comment, Text::Whitespace
        end
      end

      state :escape do
        rule /(\\)(.)/ do
          groups Str::Escape, @@FIELD_VALUE
        end
      end

      state :string do
        mixin :line_continuation
        mixin :entity
        rule /\\"/, Str::Escape
        rule /"/, Str::Double, :pop!
        rule /#{@@RE_EOL}/o, Error, :pop!
        rule /./, Str::Double
      end

      state :lyrics do
        mixin :line_continuation
        mixin :check_comment
        mixin :entity
        rule /(\\)(%)/ do
          groups Str::Escape, @@LYRICS_VALUE
        end
        rule /[-~_]/, Operator
        rule /\|/, @@BAR_LINE
        rule /[*]/, @@REST
        rule /%[^\r\n]*?#{@@RE_EOL}/o, Comment, :pop!
        rule @@RE_EOL, Text, :pop!
        rule /./, @@LYRICS_VALUE
      end

      state :entity do
        rule /&\S*?;/, Name::Entity
        rule /\\u[0-9a-f]{4}/i, Str::Escape
      end

      state :check_comment do
        rule /(%[^\r\n]*)$/, Comment
      end

      state :begin_text do
        rule /^(%%|I:)(end)(text)([^\r\n]*)/m do |n|
          groups @@DIRECTIVE, @@DIRECTIVE_NAME, @@DIRECTIVE_BEGIN_LABEL, Comment
          pop!
        end
        rule /^%%/, Text::Whitespace
        rule /^\s*$/, Text, :pop!
        rule /.+$/ do
          token @@TEXT_MULTILINE
        end
      end
    end
  end
end
