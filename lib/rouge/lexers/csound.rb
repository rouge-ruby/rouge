# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    # @abstract
    class Csound < RegexLexer
      def self.identifier
        /[A-Z_a-z]\w*/
      end

      state :whitespace do
        rule /[ \t]+/, Text
        rule %r(/\*.*?\*/)m, Comment::Multiline
        rule %r((?:;|//).*$), Comment::Single
        rule(/(\\)(\n)/) { groups Text::Whitespace, Text }
      end

      state :preprocessor_directives do
        rule /#(?:e(?:nd(?:if)?|lse)\b|##)|@@?[ \t]*\d+/, Comment::Preproc
        rule /#include/, Comment::Preproc, :include_directive
        rule /#[ \t]*define/, Comment::Preproc, :define_directive
        rule /#(?:ifn?def|undef)\b/, Comment::Preproc, :macro_directive
      end

      state :include_directive do
        mixin :whitespace
        rule /([^ \t]).*?\1/, Str, :pop!
      end

      state :define_directive do
        mixin :whitespace
        rule /\n/, Text
        rule /(#{Csound.identifier})(\()/ do
          groups Comment::Preproc, Punctuation
          goto :macro_parameter_name_list
        end
        rule Csound.identifier do
          token Comment::Preproc
          goto :before_macro_body
        end
      end
      state :macro_parameter_name_list do
        mixin :whitespace
        rule Csound.identifier, Comment::Preproc
        rule /['#]/, Punctuation
        rule /\)/ do
          token Punctuation
          goto :before_macro_body
        end
      end
      state :before_macro_body do
        mixin :whitespace
        rule /\n/, Text
        rule /#/ do
          token Punctuation
          goto :macro_body
        end
      end
      state :macro_body do
        rule /(?:\\(?!#)|[^#\\]|\n)+/m do
          recurse
        end
        rule /\\#/, Comment::Preproc
        rule /(?<!\\)#/, Punctuation, :pop!
      end

      state :macro_directive do
        mixin :whitespace
        rule Csound.identifier, Comment::Preproc, :pop!
      end

      state :macro_uses do
        rule /(\$#{Csound.identifier}\.?)(\()/ do
          groups Comment::Preproc, Punctuation
          push :macro_parameter_value_list
        end
        rule /\$#{Csound.identifier}(?:\.|\b)/, Comment::Preproc
      end
      state :macro_parameter_value_list do
        rule(/[^'#"{()]+/) { recurse }
        rule /['#]/, Punctuation
        # Csound’s preprocessor can’t handle right parentheses in parameter
        # values <https://github.com/csound/csound/issues/721>. For example,
        #   $MACRO((value))
        # passes (value, not (value), to MACRO. The workaround for this
        # implemented in
        # https://github.com/csound/csound/commit/3e0b441b55fd8e07d70b0908da8165b889feb883
        # is to require escaping right parentheses. Because this is not required
        # by the C preprocessor, it is likely to be unexpected, so use a
        # different token type for parentheses in macro parameter values.
        rule /"/, Str, :macro_parameter_value_quoted_string
        rule /{{/, Str, :macro_parameter_value_braced_string
        rule /\(/, Comment::Preproc, :macro_parameter_value_parenthetical
        rule /\)/, Punctuation, :pop!
      end
      state :macro_parameter_value_quoted_string do
        rule /\\\)/, Comment::Preproc
        rule /\)/, Error
        mixin :quoted_string
      end
      state :macro_parameter_value_braced_string do
        rule /\\\)/, Comment::Preproc
        rule /\)/, Error
        mixin :braced_string
      end
      state :macro_parameter_value_parenthetical do
        rule(/[^\\()]+/) { recurse }
        rule /\(/, Comment::Preproc, :push
        rule /\\\)/, Comment::Preproc, :pop!
        rule /\)/, Error, :pop!
      end

      state :whitespace_and_macro_uses do
        mixin :whitespace
        mixin :macro_uses
      end

      state :numbers do
        rule /\d+[Ee][+-]?\d+|(\d+\.\d*|\d*\.\d+)([Ee][+-]?\d+)?/, Num::Float
        rule /0[Xx][0-9A-Fa-f]+/, Num::Hex
        rule /\d+/, Num::Integer
      end
    end

    class CsoundOrchestra < Csound
      title 'Csound'
      desc 'Csound (https://csound.github.io)'
      tag 'csound'
      aliases 'csound-orc'
      filenames '*.orc', '*.udo'

      def user_defined_opcodes
        @user_defined_opcodes
      end

      start do
        load Pathname.new(__FILE__).dirname.join('csound/builtins.rb')
        @user_defined_opcodes = Set.new
        @csound_score_lexer = CsoundScore.new options
        @python_lexer = Python.new options
        @lua_lexer = Lua.new options
      end

      state :root do
        rule /\n+/m, Text

        rule(/^([ \t]*)(\w+)(:)(?:[ \t]+|$)/) { groups Text, Name::Label, Punctuation }

        mixin :whitespace_and_macro_uses
        mixin :preprocessor_directives

        rule /\binstr\b/, Keyword::Declaration, :instrument_numbers_and_identifiers
        rule /\bopcode\b/, Keyword::Declaration, :after_opcode_keyword
        rule /\b(?:end(?:in|op))\b/, Keyword::Declaration

        mixin :partial_statements
      end

      state :partial_statements do
        rule /\b(?:0dbfs|A4|k(?:r|smps)|nchnls(?:_i)?|sr)\b/, Name::Variable::Global

        mixin :numbers

        rule %r(\+=|-=|\*=|/=|<<|>>|<=|>=|==|!=|&&|\|\||[~¬]|[=!+\-*/^%&|<>#?:]), Operator
        rule /[(),\[\]]/, Punctuation

        rule /"/, Str, :quoted_string
        rule /{{/, Str, :braced_string

        rule /\b(?:do|else(?:if)?|end(?:if|until)|fi|i(?:f|then)|kthen|od|then|until|while)\b/, Keyword
        rule /\br(?:ir)?eturn\b/, Keyword::Pseudo
        rule /\b[ik]?goto\b/, Keyword, :goto_before_label
        rule /\b(r(?:einit|igoto)|tigoto)(\(|\b)/ do
          groups Keyword::Pseudo, Punctuation
          push :goto_before_label
        end
        rule /\b(c(?:g|in?|k|nk?)goto)(\(|\b)/ do
          groups Keyword::Pseudo, Punctuation
          push :goto_before_label
          push :goto_before_argument
        end
        rule /\b(timout)(\(|\b)/ do
          groups Keyword::Pseudo, Punctuation
          push :goto_before_label
          push :goto_before_argument
          push :goto_before_argument
        end
        rule /\b(loop_[gl][et])(\(|\b)/ do
          groups Keyword::Pseudo, Punctuation
          push :goto_before_label
          push :goto_before_argument
          push :goto_before_argument
          push :goto_before_argument
        end
        rule /\bprintk?s\b/, Name::Builtin, :prints_opcode
        rule /\b(?:readscore|scoreline(?:_i)?)\b/, Name::Builtin, :csound_score_opcode
        rule /\bpyl?run[it]?\b/, Name::Builtin, :python_opcode
        rule /\blua_(exec|opdef)\b/, Name::Builtin, :lua_opcode
        rule /\bp\d+\b/, Name::Variable::Instance
        rule /\b(#{Csound.identifier})(?:(:)([A-Za-z]))?\b/ do |m|
          name = m[1]
          if self.class.opcodes.include?(name) || self.class.deprecated_opcodes.include?(name)
            token Name::Builtin, name
            if m[2]
              token Punctuation, m[2]
              token Keyword::Type, m[3]
            end
          elsif user_defined_opcodes.include? name
            token Name::Function, name
          else
            if m = /^(g?[aikSw])(\w+)/.match(name)
              token Keyword::Type, m[1]
              token Name, m[2]
            else
              token Name, name
            end
          end
        end
      end

      state :instrument_numbers_and_identifiers do
        mixin :whitespace_and_macro_uses
        rule /\d+|#{Csound.identifier}/, Name::Function
        rule /[+,]/, Punctuation
        rule /\n/, Text, :pop!
      end

      state :after_opcode_keyword do
        mixin :whitespace_and_macro_uses
        rule Csound.identifier do |m|
          user_defined_opcodes.add m[0]
          token Name::Function
          goto :opcode_type_signatures
        end
        rule /\n/, Text, :pop!
      end
      state :opcode_type_signatures do
        mixin :whitespace_and_macro_uses
        rule /\b(?:0|[afijkKoOpPStV\[\]]+)\b/, Keyword::Type
        rule /,/, Punctuation
        rule /\n/, Text, :pop!
      end

      state :quoted_string do
        rule /"/, Str, :pop!
        rule /[^\\"$%]/, Str
        mixin :macro_uses
        mixin :escape_sequences
        mixin :format_specifiers
        rule /[\\$%]/, Str
      end
      state :braced_string do
        rule /}}/, Str, :pop!
        rule /[^\\}]|}(?!})/, Str
        mixin :escape_sequences
        mixin :format_specifiers
      end
      state :escape_sequences do
        # https://github.com/csound/csound/search?q=unquote_string+path%3AEngine+filename%3Acsound_orc_compile.c
        rule /\\(?:[\\abnrt"]|[0-7]{1,3})/, Str::Escape
      end
      # Format specifiers are highlighted in all strings, even though only
      #   fprintks        https://csound.github.io/docs/manual/fprintks.html
      #   fprints         https://csound.github.io/docs/manual/fprints.html
      #   printf/printf_i https://csound.github.io/docs/manual/printf.html
      #   printks         https://csound.github.io/docs/manual/printks.html
      #   prints          https://csound.github.io/docs/manual/prints.html
      #   sprintf         https://csound.github.io/docs/manual/sprintf.html
      #   sprintfk        https://csound.github.io/docs/manual/sprintfk.html
      # work with strings that contain format specifiers. In addition, these
      # opcodes’ handling of format specifiers is inconsistent:
      #   - fprintks, fprints, printks, and prints do accept %a and %A
      #     specifiers, but can’t accept %s specifiers.
      #   - printf, printf_i, sprintf, and sprintfk don’t accept %a and %A
      #     specifiers, but can accept %s specifiers.
      # See https://github.com/csound/csound/issues/747 for more information.
      state :format_specifiers do
        rule /%[#0\- +]*\d*(?:\.\d+)?[diuoxXfFeEgGaAcs]/, Str::Interpol
        rule /%%/, Str::Escape
      end

      state :goto_before_argument do
        mixin :whitespace_and_macro_uses
        rule /,/, Punctuation, :pop!
        mixin :partial_statements
      end
      state :goto_before_label do
        mixin :whitespace_and_macro_uses
        rule /\w+/, Name::Label, :pop!
        rule /(?!\w)/, Text, :pop!
      end

      state :prints_opcode do
        mixin :whitespace_and_macro_uses
        rule /"/, Str, :prints_quoted_string
        rule /(?!")/, Text, :pop!
      end
      state :prints_quoted_string do
        rule /\\\\[aAbBnNrRtT]/, Str::Escape
        rule /%[!nNrRtT]|[~^]{1,2}/, Str::Escape
        mixin :quoted_string
      end

      # TODO: Is there a way to encapsulate these?

      state :csound_score_opcode do
        mixin :whitespace_and_macro_uses
        rule /{{/, Str, :csound_score
        rule /\n/, Text, :pop!
        mixin :partial_statements
      end
      state :csound_score do
        rule /}}/, Str, :pop!
        rule /(?:[^}]|}(?!}))+/m do
          @csound_score_lexer.reset!
          delegate @csound_score_lexer
        end
      end

      state :python_opcode do
        mixin :whitespace_and_macro_uses
        rule /{{/, Str, :python
        rule /\n/, Text, :pop!
        mixin :partial_statements
      end
      state :python do
        rule /}}/, Str, :pop!
        rule /(?:[^}]|}(?!}))+/m do
          @python_lexer.reset!
          delegate @python_lexer
        end
      end

      state :lua_opcode do
        mixin :whitespace_and_macro_uses
        rule /{{/, Str, :lua
        rule /\n/, Text, :pop!
        mixin :partial_statements
      end
      state :lua do
        rule /}}/, Str, :pop!
        rule /(?:[^}]|}(?!}))+/m do
          @lua_lexer.reset!
          delegate @lua_lexer
        end
      end
    end

    class CsoundScore < Csound
      title 'Csound Score'
      desc 'Csound (https://csound.github.io)'
      tag 'csound_score'
      aliases 'csound-sco', 'csound-score'
      filenames '*.sco'

      state :root do
        rule /\n+/m, Text
        mixin :whitespace_and_macro_uses
        mixin :preprocessor_directives

        rule /[abCefiqstvxy]/, Keyword
        # There is also a w statement that is generated internally and should
        # not be used; see https://github.com/csound/csound/issues/750.

        rule /z/, Keyword::Constant
        # z is a constant equal to 800,000,000,000. 800 billion seconds is about
        # 25,367.8 years. See also
        # https://csound.github.io/docs/manual/ScoreTop.html and
        # https://github.com/csound/csound/search?q=stof+path%3AEngine+filename%3Asread.c.

        rule(/([np]p)(\d+)/i) { groups Keyword, Num::Integer }

        rule /[mn]/, Keyword, :mark_statement

        mixin :numbers
        rule /"/, Str, :quoted_string
        rule /{/, Comment::Preproc, :loop_after_left_brace
      end

      state :mark_statement do
        mixin :whitespace_and_macro_uses
        rule Csound.identifier, Name::Label
        rule /\n/, Text, :pop!
      end

      state :quoted_string do
        rule /"/, Str, :pop!
        rule /[^"$]+/, Str
        mixin :macro_uses
        rule /$/, Str
      end

      state :loop_after_left_brace do
        mixin :whitespace_and_macro_uses
        rule /\d+/ do
          token Num::Integer
          goto :loop_after_repeat_count
        end
      end
      state :loop_after_repeat_count do
        mixin :whitespace_and_macro_uses
        rule Csound.identifier do
          token Comment::Preproc
          goto :loop
        end
      end
      state :loop do
        rule /}/, Comment::Preproc, :pop!
        mixin :root
      end
    end

    class CsoundDocument < RegexLexer
      title 'Csound Document'
      desc 'Csound (https://csound.github.io)'
      tag 'csound_document'
      aliases 'csound-csd', 'csound-document'
      filenames '*.csd'

      start do
        @orchestra_lexer = CsoundOrchestra.new options
        @score_lexer = CsoundScore.new options
        @html_lexer = HTML.new options
      end

      state :root do
        rule %r(/\*.*?\*/)m, Comment::Multiline
        rule %r((?:;|//).*$), Comment::Single
        rule %r([^/;<]+|/)m, Text

        rule /<\s*CsInstruments\s*/m do
          token Name::Tag
          push :orchestra
          push :tag
        end

        rule /<\s*CsScore\s*/m do
          token Name::Tag
          push :score
          push :tag
        end

        rule /<\s*html\s*/im do
          token Name::Tag
          push :html
          push :tag
        end

        rule /<\s*[\w:-]+/, Name::Tag, :tag
        rule %r(<\s*/\s*[\w:-]+\s*>), Name::Tag
      end

      state :tag do
        rule /\s+/m, Text
        rule /([\w.:-]+\s*)(=)/m do
          groups Name::Attribute, Punctuation
          push :attribute
        end
        rule %r((?:/\s*)?>), Name::Tag, :pop!
      end

      state :attribute do
        rule /\s+/m, Text
        rule /".*?"|'.*?'|[^\s>]+/, Str, :pop!
      end

      state :orchestra do
        end_tag = %r(<\s*/\s*CsInstruments\s*>)m
        rule end_tag, Name::Tag, :pop!
        rule %r(.+?(?=#{end_tag}))m do
          @orchestra_lexer.reset!
          delegate @orchestra_lexer
        end
      end

      state :score do
        end_tag = %r(<\s*/\s*CsScore\s*>)m
        rule end_tag, Name::Tag, :pop!
        rule %r(.+?(?=#{end_tag}))m do
          @score_lexer.reset!
          delegate @score_lexer
        end
      end

      state :html do
        end_tag = %r(<\s*/\s*html\s*>)im
        rule end_tag, Name::Tag, :pop!
        rule %r(.+?(?=#{end_tag}))m do
          @html_lexer.reset!
          delegate @html_lexer
        end
      end
    end
  end
end
