# -*- coding: utf-8 #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Scala < RegexLexer
      title "Scala"
      desc "The Scala programming language (scala-lang.org)"
      tag 'scala'
      aliases 'scala'
      filenames '*.scala', '*.sbt'

      mimetypes 'text/x-scala', 'application/x-scala'

      # As documented in the ENBF section of the scala specification
      # Scala 2: https://scala-lang.org/files/archive/spec/2.13/13-syntax-summary.html
      # Scala 3: https://docs.scala-lang.org/scala3/reference/syntax.html
      # https://en.wikipedia.org/wiki/Unicode_character_property#General_Category
      whitespace = /\p{Space}/
      letter = /[\p{L}$_]/
      upper = /[\p{Lu}$_]/
      lower = /[\p{Ll}$_]/
      digits = /[0-9]/
      parens = /[(){}\[\]]/
      delims = %r([''".;,])

      # negative lookahead to filter out other classes
      op = %r(
        (?!#{whitespace}|#{letter}|#{digits}|#{parens}|#{delims})
        [-!#%&*/:?@\\^\p{Sm}\p{So}]  # Basic operators and Unicode math/symbol chars
      )x
      # Note: Some operators like +<=>|~ are in Unicode property Sm

      idrest_core = %r((?:#{letter}|#{digits})*(?:_#{op}+)?)x
      idrest = %r(#{lower}#{idrest_core})x
      upper_idrest = %r(#{upper}#{idrest_core})x

      # For string interpolation prefixes like s"", f"" - simplified identifier
      plain_interpol_id = %r(#{letter}(?:#{letter}|#{digits})*)x

      keywords = %w(
        abstract case catch def do else extends final finally for forSome
        if implicit lazy match new override private protected requires return
        sealed super this throw try val var while with yield
        enum export given open transparent extension using derives then end
        inline opaque infix transparent
      )

      state :root do
        rule %r/(class|trait|object)(\s+)/ do
          groups Keyword, Text
          push :class
        end
        rule %r/'#{idrest}(?!')/, Str::Symbol
        rule %r/[^\S\n]+/, Text

        rule %r(//.*), Comment::Single
        rule %r(/\*), Comment::Multiline, :comment

        # Interpolated strings: s"...", f"""...""", etc.
        # Must be before general string rules and identifier rules that might catch the prefix.
        # s"..."
        rule %r/(#{plain_interpol_id})(")((?:\\(?:["\\\/bfnrt']|u[0-9a-fA-F]{4})|[^"\\])*?)(")/ do
          groups Name::Tag, Str, Str, Str
        end
        # s"""..."""
        rule %r/(#{plain_interpol_id})(""".*?"""(?!"))/m do
          groups Name::Tag, Str
        end

        rule %r/@#{idrest}/, Name::Decorator

        rule %r/(def)(\s+)(#{idrest}|#{op}+|`[^`]+`)(\s*)/ do
          groups Keyword, Text, Name::Function, Text
        end

        rule %r/(val)(\s+)(#{idrest}|#{op}+|`[^`]+`)(\s*)/ do
          groups Keyword, Text, Name::Variable, Text
        end

        rule %r/(this)(\n*)(\.)(#{idrest})/ do
          groups Keyword, Text, Operator, Name::Property
        end

        rule %r/(#{idrest}|_)(\n*)(\.)(#{idrest})/ do
          groups Name::Variable, Text, Operator, Name::Property
        end

        rule %r/#{upper_idrest}\b/, Name::Class

        rule %r/(#{idrest})(#{whitespace}*)(\()/ do
          groups Name::Function, Text, Operator
        end

        rule %r/(\.)(#{idrest})/ do
          groups Operator, Name::Property
        end

        rule %r(
          (#{keywords.join("|")})\b|
          (<[%:-]|=>|>:|[#=@_\u21D2\u2190])(\b|(?=\s)|$)
        )x, Keyword
        rule %r/:(?!#{op})/, Keyword, :type
        rule %r/(true|false|null)\b/, Keyword::Constant
        rule %r/(import|package)(\s+)/ do
          groups Keyword, Text
          push :import
        end

        rule %r/(type)(\s+)/ do
          groups Keyword, Text
          push :type
        end

        rule %r/""".*?"""(?!")/m, Str
        rule %r/"(\\\\|\\"|[^"])*"/, Str
        rule %r/'([^'\\]|\\[\\'"bfnrt]|\\u[0-9a-fA-F]{4})'/, Str::Char
        rule %r/'[^']*'/, Str

        rule idrest, Name
        rule %r/`[^`]+`/, Name

        rule %r/\[/, Operator, :typeparam
        rule %r/[\(\)\{\};,.#]/, Operator
        rule %r/#{op}+/, Operator

        # Order: Floats, Binary, Hex, Decimal Integers.
        # Floating point with optional underscores
        rule %r/([0-9](?:_?[0-9])*\.(?:_?[0-9])*(?:[eE][+-]?[0-9](?:_?[0-9])*)?|\.[0-9](?:_?[0-9])*(?:[eE][+-]?[0-9](?:_?[0-9])*)?)[fFdD]?/, Num::Float
        rule %r/([0-9](?:_?[0-9])*)[fFdD]/, Num::Float

        # Binary literals (e.g., 0b1010, 0B1_0_1L)
        rule %r/0[bB][01](?:_?[01])*[lL]?/, Num::Integer
        # Hex literals (e.g., 0xFF, 0xAB_CDL)
        rule %r/0[xX][0-9a-fA-F](?:_?[0-9a-fA-F])*[lL]?/, Num::Hex
        # Decimal integers (e.g., 123, 1_000_000L)
        # This must be after float, hex, bin which might also start with digits.
        rule %r/[0-9](?:_?[0-9])*[lL]?/, Num::Integer

        rule %r/\n/, Text

        # End markers for control structures and definitions
        rule %r/(end)(\s+)(if|while|for|match|try|new|this|given|extension|val|def|class|object|trait)\b/ do
          groups Keyword, Text, Keyword
        end

        # Type operators for union and intersection types
        rule %r/[&|](?![&|])/, Operator

        # Named type arguments
        rule %r/([A-Z]\w*)(\s*)(=)(?=\s*[A-Z])/ do
          groups Name::Class, Text, Operator
        end

        # Context function type
        rule %r/\?=>/, Operator
      end

      state :class do
        rule %r/(#{idrest}|#{upper_idrest}|#{op}+|`[^`]+`)(\s*)(\[)/ do
          groups Name::Class, Text, Operator
          push :typeparam
        end

        rule %r/\s+/, Text
        rule %r/{/, Operator, :pop!
        rule %r/\(/, Operator, :pop!
        rule %r(//.*), Comment::Single, :pop!
        rule %r(#{idrest}|#{upper_idrest}|#{op}+|`[^`]+`), Name::Class, :pop!
      end

      state :type do
        rule %r/\s+/, Text
        rule %r/<[%:]|>:|[#_\u21D2]|forSome|type/, Keyword
        rule %r/([,\);}]|=>|=)(\s*)/ do
          groups Operator, Text
          pop!
        end
        rule %r/[\(\{]/, Operator, :type

        typechunk = /(?:#{idrest}|#{upper_idrest}|#{op}+\`[^`]+`)/
        rule %r/(#{typechunk}(?:\.#{typechunk})*)(\s*)(\[)/ do
          groups Keyword::Type, Text, Operator
          pop!
          push :typeparam
        end

        rule %r/(#{typechunk}(?:\.#{typechunk})*)(\s*)$/ do
          groups Keyword::Type, Text
          pop!
        end

        rule %r(//.*), Comment::Single, :pop!
        rule %r/\.|#{idrest}|#{upper_idrest}|#{op}+|`[^`]+`/, Keyword::Type
      end

      state :typeparam do
        rule %r/[\s,]+/, Text
        rule %r/<[%:]|=>|>:|[#_\u21D2]|forSome|type/, Keyword
        rule %r/([\]\)\}])/, Operator, :pop!
        rule %r/[\(\[\{]/, Operator, :typeparam
        rule %r/\.|#{idrest}|#{upper_idrest}|#{op}+|`[^`]+`/, Keyword::Type
      end

      state :comment do
        rule %r([^/\*]+), Comment::Multiline
        rule %r(/\*), Comment::Multiline, :comment
        rule %r(\*/), Comment::Multiline, :pop!
        rule %r([*/]), Comment::Multiline
      end

      state :import do
        # Handle 'as' imports with optional whitespace
        rule %r/((#{idrest}|#{upper_idrest}|\.)+)(\s*)(as)(\s*)(#{idrest}|#{upper_idrest})/ do |m|
          groups Name::Namespace, Text, Keyword, Text, Name::Namespace
          pop!
        end
        rule %r/((#{idrest}|#{upper_idrest}|\.)+)/, Name::Namespace, :pop!
      end
    end
  end
end
