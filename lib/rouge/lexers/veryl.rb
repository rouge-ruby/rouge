# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Veryl < RegexLexer
      title "Veryl"
      desc "The Veryl hardware description language (https://veryl-lang.org)"
      tag 'veryl'
      filenames '*.veryl'
      mimetypes 'text/x-veryl'

      # Characters

      WHITE_SPACE = /\s+/
      NEWLINE     = /\n/

      # Comments

      LINE_COMMENT    = /\/\/(?:(?!#{NEWLINE}).)*/
      GENERAL_COMMENT = /\/\*(?:(?!\*\/).)*\*\//m
      COMMENT         = /#{LINE_COMMENT}|#{GENERAL_COMMENT}/

      # Numeric literals

      EXPONENT    = /[0-9]+(?:_[0-9]+)*\.[0-9]+(?:_[0-9]+)*[eE][+-]?[0-9]+(?:_[0-9]+)*/
      FIXED_POINT = /[0-9]+(?:_[0-9]+)*\.[0-9]+(?:_[0-9]+)*/
      BASED       = /(?:[0-9]+(?:_[0-9]+)*)?'s?[bodh][0-9a-fA-FxzXZ]+(?:_[0-9a-fA-FxzXZ]+)*/
      ALL_BIT     = /(?:[0-9]+(?:_[0-9]+)*)?'[01xzXZ]/
      BASE_LESS   = /[0-9]+(?:_[0-9]+)*/
 
      # Operators and delimiters

      OPERATOR  = / -:     | ->     | \+:    | \+=    | -=
                  | \*=    | \/=    | %=     | &=     | \|=
                  | \^=    | <<=    | >>=    |<<<=    |>>>=
                  | <>     | \*\*   | \/     | \|     | %
                  | \+     | -      | <<<    | >>>    | <<
                  | >>     | <=     | >=     | <:     | >:
                  | ===    | ==\?   | \!==   | \!=\?  | ==
                  | \!=    | &&     | \|\|   | &      | \^~
                  | \^     | ~\^    | \|     | ~&     | ~\|
                  | \!     | ~
                  /x

      SEPARATOR = / ::<    | ::     | :      | ,      | \.\.=
                  | \.\.   | \.     | =      | \#     | <
                  | \?     | '      | '\{    | \{     | \[
                  | \(     | >      | \}     | \]     | \)
                  | ;      | \*
                  /x

      # Identifiers

      DOLLAR_IDENTIFIER = /\$[a-zA-Z_][0-9a-zA-Z_$]*/
      IDENTIFIER        = /(?:r#)?[a-zA-Z_][0-9a-zA-Z_$]*/

      # Keywords

      def self.keywords
        @keywords ||= Set.new %w(
          embed enum function include interface modport module package proto pub struct union unsafe
          alias always_comb always_ff assign as bind block connect const final import initial inst let param return break type var
          converse inout input output same
          case default else if_reset if inside outside switch
          for in repeat rev step
        )
      end

      def self.keywords_type
        @keywords_type ||= Set.new %w(
          bit bbool lbool clock clock_posedge clock_negedge f32 f64 i8 i16 i32 i64 logic reset reset_async_high reset_async_low reset_sync_high reset_sync_low signed string tri u8 u16 u32 u64
        )
      end

      state :root do
        rule(COMMENT          , Comment             )
        rule(EXPONENT         , Num::Float          )
        rule(FIXED_POINT      , Num::Float          )
        rule(BASED            , Num::Integer        )
        rule(ALL_BIT          , Num::Integer        )
        rule(BASE_LESS        , Num::Integer        )
        rule(OPERATOR         , Operator            )
        rule(SEPARATOR        , Punctuation         )
        rule(DOLLAR_IDENTIFIER, Name                )
        rule(WHITE_SPACE      , Text                )
        rule(/"/              , Str::Double, :string)

        rule IDENTIFIER do |m|
          name = m[0]

          if self.class.keywords.include? name
            token Keyword
          elsif self.class.keywords_type.include? name
            token Keyword::Type
          else
            token Name
          end
        end
      end

      state :string do
        rule(/[^\\"]+/, Str::Double       )
        rule(/\\./    , Str::Escape       )
        rule(/"/      , Str::Double, :pop!)
      end
    end
  end
end
