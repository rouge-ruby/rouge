# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class GDScript < RegexLexer
      title "GDScript"
      desc "The Godot Engine programming language (https://godotengine.org/)"
      tag 'gdscript'
      aliases 'gd', 'gdscript'
      filenames '*.gd'
      mimetypes 'text/x-gdscript', 'application/x-gdscript'

      KEYWORDS = Set.new %w(
        and in not or as breakpoint class class_name extends is func setget
        signal tool const enum export onready static var break continue
        if elif else for pass return match while remote master puppet
        remotesync mastersync puppetsync
      )

      # Reserved for future implementation
      KEYWORDS_RESERVED = Set.new %w(do switch case)

      BUILTINS = Set.new %w(
        Color8 ColorN abs acos asin assert atan atan2 bytes2var ceil char
        clamp convert cos cosh db2linear decimals dectime deg2rad dict2inst
        ease exp floor fmod fposmod funcref hash inst2dict instance_from_id
        is_inf is_nan lerp linear2db load log max min nearest_po2 pow
        preload print print_stack printerr printraw prints printt rad2deg
        rand_range rand_seed randf randi randomize range round seed sign
        sin sinh sqrt stepify str str2var tan tan tanh type_exist typeof
        var2bytes var2str weakref yield
      )

      CONSTANTS = Set.new %w(self false true PI TAU NAN INF)

      BUILTINS_TYPE = Set.new %w(
        bool int float String Vector2 Rect2 Transform2D Vector3 AABB
        Plane Quat Basis Transform Color RID Object NodePath Dictionary
        Array PoolByteArray PoolIntArray PoolRealArray PoolStringArray
        PoolVector2Array PoolVector3Array PoolColorArray null
      )

      state :inline_whitespace do
        rule %r/[ \t]+/, Text
        rule %r/\\[ \t]*\n/, Str::Escape
        rule %r/(\\[ \t]*)(#.*?\n)/ do
          groups Str::Escape, Comment
        end
      end

      state :root do
        rule %r/\n/, Text
        rule %r/[^\S\n]+/, Text
        rule %r/#.*/, Comment::Single
        rule %r/[\[\]{}:(),;]/, Punctuation
        rule %r/\\\n/, Text
        rule %r/(in|and|or|not)\b/, Operator::Word
        rule %r/!=|==|<<|>>|&&|\+=|-=|\*=|\/=|%=|&=|\|=|\|\||[-~+\/*%=<>&^.!|$]/, Operator
        rule %r/func\b/, Keyword, :funcname
        rule %r/class\b/, Keyword, :classname

        keywords %r/[a-z]\w*/i do
          rule KEYWORDS, Keyword
          rule KEYWORDS_RESERVED, Keyword::Reserved
          rule BUILTINS, Name::Builtin
          rule CONSTANTS, Name::Constant
          rule BUILTINS_TYPE, Keyword::Type
          default Name
        end

        rule %r/"""/, Str::Double, :escape_tdqs
        rule %r/'''/, Str::Double, :escape_tsqs
        rule %r/"/, Str::Double, :escape_dqs
        rule %r/'/, Str::Double, :escape_sqs
        mixin :numbers
      end

      state :numbers do
        rule %r/(\d+\.\d*|\d*\.\d+)([eE][+-]?[0-9]+)?j?/, Num::Float
        rule %r/\d+[eE][+-]?[0-9]+j?/, Num::Float
        rule %r/0[xX][a-fA-F0-9]+/, Num::Hex
        rule %r/\d+j?/, Num::Integer
      end

      state :funcname do
        mixin :inline_whitespace
        rule %r/[a-zA-Z_]\w*/, Name::Function, :pop!
      end

      state :classname do
        mixin :inline_whitespace
        rule %r/[a-zA-Z_]\w*/, Name::Class, :pop!
      end

      state :string_escape do
        rule %r/\\([\\abfnrtv"\']|\n|N\{.*?\}|u[a-fA-F0-9]{4}|U[a-fA-F0-9]{8}|x[a-fA-F0-9]{2}|[0-7]{1,3})/, Str::Escape
      end

      state :strings_single do
        rule %r/%(\(\w+\))?[-#0 +]*([0-9]+|[*])?(\.([0-9]+|[*]))?[hlL]?[E-GXc-giorsux%]/, Str::Interpol
        rule %r/[^\\'%\n]+/, Str::Single
        rule %r/["\\]/, Str::Single
        rule %r/%/, Str::Single
      end

      state :strings_double do
        rule %r/%(\(\w+\))?[-#0 +]*([0-9]+|[*])?(\.([0-9]+|[*]))?[hlL]?[E-GXc-giorsux%]/, Str::Interpol
        rule %r/[^\\"%\n]+/, Str::Double
        rule %r/['\\]/, Str::Double
        rule %r/%/, Str::Double
      end

      state :dqs do
        rule %r/"/, Str::Double, :pop!
        rule %r/\\\\|\\"|\\\n/, Str::Escape
        mixin :strings_double
      end

      state :escape_dqs do
        mixin :string_escape
        mixin :dqs
      end

      state :sqs do
        rule %r/'/, Str::Single, :pop!
        rule %r/\\\\|\\'|\\\n/, Str::Escape
        mixin :strings_single
      end

      state :escape_sqs do
        mixin :string_escape
        mixin :sqs
      end

      state :tdqs do
        rule %r/"""/, Str::Double, :pop!
        mixin :strings_double
        rule %r/\n/, Str::Double
      end

      state :escape_tdqs do
        mixin :string_escape
        mixin :tdqs
      end

      state :tsqs do
        rule %r/'''/, Str::Single, :pop!
        mixin :strings_single
        rule %r/\n/, Str::Single
      end

      state :escape_tsqs do
        mixin :string_escape
        mixin :tsqs
      end
    end
  end
end
