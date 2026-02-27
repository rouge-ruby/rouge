# -*- coding: utf-8 -*- #
# frozen_string_literal: true

require_relative 'lua'

module Rouge
  module Lexers
    class Moonscript < RegexLexer
      title "MoonScript"
      desc "Moonscript (http://www.moonscript.org)"
      tag 'moonscript'
      aliases 'moon'
      filenames '*.moon'
      mimetypes 'text/x-moonscript', 'application/x-moonscript'

      option :function_highlighting, 'Whether to highlight builtin functions (default: true)'
      option :disabled_modules, 'builtin modules to disable'

      # depends on lua builtins
      lazy { Lua.eager_load! }

      def initialize(*)
        super

        @function_highlighting = bool_option(:function_highlighting) { true }
        @disabled_modules = list_option(:disabled_modules)
      end

      def self.detect?(text)
        return true if text.shebang? 'moon'
      end

      def builtins
        return [] unless @function_highlighting

        @builtins ||= Set.new.tap do |builtins|
          Lua::BUILTINS.each do |mod, fns|
            next if @disabled_modules.include? mod
            builtins.merge(fns)
          end
        end
      end

      state :root do
        rule %r(#!(.*?)$), Comment::Preproc # shebang
        rule %r//, Text, :main
      end

      state :base do
        rule %r((\d*\.\d+|\d+\.\d*)(e[+-]?\d+)?')i, Num::Float
        rule %r(\d+e[+-]?\d+)i, Num::Float
        rule %r(0x\h*), Num::Hex
        rule %r(\d+), Num::Integer
        rule %r(@\w+), Name::Variable::Instance
        rule %r([A-Z]\w*), Name::Class
        rule %r("?[^"]+":), Literal::String::Symbol
        rule %r(\w+:), Literal::String::Symbol
        rule %r(:\w+), Literal::String::Symbol

        rule %r(\s+), Text::Whitespace
        rule %r((==|~=|!=|<=|>=|\.\.\.|\.\.|->|=>|[=+\-*/%^<>#!\\])), Operator
        rule %r([\[\]\{\}\(\)\.,:;]), Punctuation
        rule %r((and|or|not)\b), Operator::Word

        keywords = Set.new %w{
          break class continue do else elseif end extends for if import in from
          repeat return switch super then unless until using when with while
        }
        rule %r((local|export)\b), Keyword::Declaration
        rule %r((true|false|nil)\b), Keyword::Constant

        rule %r([a-z_]\w*(\.[a-z_]\w*)?)i do |m|
          name = m[0]
          if keywords.include?(name)
            token Keyword
          elsif self.builtins.include?(name)
            token Name::Builtin
          elsif name.include?('.')
            a, b = name.split('.', 2)
            token Name, a
            token Punctuation, '.'
            token Name, b
          else
            token Name
          end
        end
      end

      state :main do
        rule %r(--.*$), Comment::Single
        rule %r(\[(=*)\[.*?\]\1\])m, Str::Heredoc

        mixin :base

        rule %r('), Str::Single, :sqs
        rule %r("), Str::Double, :dqs
      end

      state :sqs do
        rule %r('), Str::Single, :pop!
        rule %r([^']+), Str::Single
      end

      state :interpolation do
        rule %r(\}), Str::Interpol, :pop!
        mixin :base
      end

      state :dqs do
        rule %r(#\{), Str::Interpol, :interpolation
        rule %r("), Str::Double, :pop!
        rule %r(#[^{]), Str::Double
        rule %r([^"#]+), Str::Double
      end
    end
  end
end
