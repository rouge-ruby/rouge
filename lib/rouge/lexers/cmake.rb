# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class CMake < RegexLexer
      title 'CMake'
      desc 'The cross-platform, open-source build system'
      tag 'cmake'
      filenames 'CMakeLists.txt', '*.cmake'
      mimetypes 'text/x-cmake'

      SPACE = /[ \t]/
      BRACKET_OPEN = /\[=*\[/

      STATES_MAP = {
        :root => Text,
        :bracket_string => Str::Double,
        :quoted_argument => Str::Double,
        :bracket_comment => Comment::Multiline,
        :variable_reference => Name::Variable,
      }

      lazy { require_relative 'cmake/builtins' }

      state :default do
        rule %r/\r\n?|\n/ do
          token STATES_MAP[state.name.to_sym]
        end
        rule %r/./ do
          token STATES_MAP[state.name.to_sym]
        end
      end

      state :variable_interpolation do
        rule %r/\$\{/ do
          token Str::Interpol
          push :variable_reference
        end
      end

      state :bracket_close do
        rule %r/\]=*\]/ do |m|
          token STATES_MAP[state.name.to_sym]
          goto :root if m[0].length == @bracket_len
        end
      end

      state :root do
        mixin :variable_interpolation

        rule SPACE, Text
        rule %r/[()]/, Punctuation

        rule %r/##{BRACKET_OPEN}/ do |m|
          token Comment::Multiline
          @bracket_len = m[0].length - 1 # decount '#'
          goto :bracket_comment
        end

        rule BRACKET_OPEN do |m|
          token Str::Double
          @bracket_len = m[0].length
          goto :bracket_string
        end

        rule %r/\\"/, Str::Escape
        rule %r/"/, Str::Double, :quoted_argument

        keywords %r/([A-Za-z_][A-Za-z0-9_]*)(#{SPACE}*)(\()/ do
          group 1

          rule(BUILTIN_COMMANDS) { groups Name::Builtin, Text, Punctuation }
          default { groups Name::Function, Text, Punctuation }
        end

        rule %r/#.*/, Comment::Single

        mixin :default
      end

      state :bracket_string do
        mixin :bracket_close
        mixin :variable_interpolation
        mixin :default
      end

      state :bracket_comment do
        mixin :bracket_close
        mixin :default
      end

      state :variable_reference do
        mixin :variable_interpolation

        rule %r/}/, Str::Interpol, :pop!

        mixin :default
      end

      state :quoted_argument do
        mixin :variable_interpolation

        rule %r/"/, Str::Double, :root
        rule %r/\\[()#" \\$@^trn;]/, Str::Escape

        mixin :default
      end
    end
  end
end
