# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class SQF < RegexLexer
      tag "sqf"
      filenames "*.sqf"

      title "SQF"
      desc "Status Quo Function, a Real Virtuality engine scripting language"

      WORDOPERATORS = Set.new %w(
        and or not
      )

      INITIALIZERS = Set.new %w(
        private param params
      )

      CONTROLFLOW = Set.new %w(
        if then else exitwith switch do case default while for from to step
        foreach
      )

      CONSTANTS = Set.new %w(
        true false player confignull controlnull displaynull grpnull
        locationnull netobjnull objnull scriptnull tasknull teammembernull
      )

      NAMESPACES = Set.new %w(
        currentnamespace missionnamespace parsingnamespace profilenamespace
        uinamespace
      )

      DIAG_COMMANDS = Set.new %w(
        diag_activemissionfsms diag_activesqfscripts diag_activesqsscripts
        diag_activescripts diag_captureframe diag_captureframetofile
        diag_captureslowframe diag_codeperformance diag_drawmode diag_enable
        diag_enabled diag_fps diag_fpsmin diag_frameno diag_lightnewload
        diag_list diag_log diag_logslowframe diag_mergeconfigfile
        diag_recordturretlimits diag_setlightnew diag_ticktime diag_toggle
      )

      lazy do
        require_relative 'sqf/keywords.rb'
      end

      state :root do
        # Whitespace
        rule %r"\s+", Text

        # Preprocessor instructions
        rule %r"/\*.*?\*/"m, Comment::Multiline
        rule %r"//.*", Comment::Single
        rule %r"#(define|undef|if(n)?def|else|endif|include)", Comment::Preproc
        rule %r"\\\r?\n", Comment::Preproc
        rule %r"__(EVAL|EXEC|LINE__|FILE__)", Name::Builtin

        # Literals
        rule %r"\".*?\"", Literal::String
        rule %r"'.*?'", Literal::String
        rule %r"(\$|0x)[0-9a-fA-F]+", Literal::Number::Hex
        rule %r"[0-9]+(\.)?(e[0-9]+)?", Literal::Number::Float

        # Symbols
        rule %r"[\!\%\&\*\+\-\/\<\=\>\^\|\#]", Operator
        rule %r"[\(\)\{\}\[\]\,\:\;]", Punctuation

        rule %r/_[a-z0-9]+/i, Name::Variable

        # Identifiers (variables and functions)
        keywords %r"[a-z0-9_]+"i do
          transform(&:downcase)

          rule WORDOPERATORS, Operator::Word
          rule INITIALIZERS, Keyword::Declaration
          rule CONTROLFLOW, Keyword::Reserved
          rule CONSTANTS, Keyword::Constant
          rule NAMESPACES, Keyword::Namespace
          rule DIAG_COMMANDS, Name::Function
          rule COMMANDS, Name::Function
          default Name
        end
      end
    end
  end
end
