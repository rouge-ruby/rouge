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

      affix_long  = '[rR]|[uUbB][rR]|[rR][uUbB]|[@]'
      affix_short = '[uUbB]?'

      keywords = %w(
        and in not or as breakpoint class class_name extends is func setget
        signal tool const enum export onready static var break continue
        if elif else for pass return match while remote master puppet
        remotesync mastersync puppetsync
      ).join('|')

      # Reserved for future implementation
      keywords_reserved = %w(
        do switch case
      ).join('|')

      buildins = %w(
        Color8 ColorN abs acos asin assert atan atan2 bytes2var ceil char
        clamp convert cos cosh db2linear decimals dectime deg2rad dict2inst
        ease exp floor fmod fposmod funcref hash inst2dict instance_from_id
        is_inf is_nan lerp linear2db load log max min nearest_po2 pow
        preload print print_stack printerr printraw prints printt rad2deg
        rand_range rand_seed randf randi randomize range round seed sign
        sin sinh sqrt stepify str str2var tan tan tanh type_exist typeof
        var2bytes var2str weakref yield
      ).join('|')

      builtins_type = %w(
        bool int float String Vector2 Rect2 Transform2D Vector3 AABB
        Plane Quat Basis Transform Color RID Object NodePath Dictionary
        Array PoolByteArray PoolIntArray PoolRealArray PoolStringArray
        PoolVector2Array PoolVector3Array PoolColorArray null
      ).join('|')

      state :root do
        rule %r/\n/, Text
        rule %r/^(\s*)([rRuUbB]{,2})("""(?:.|\n)*?""")/ do
          # groups Text, Str::Affix, Str::Doc
          groups Text, Str::Char, Str::Doc
        end
        rule %r/^(\s*)([rRuUbB]{,2})('''(?:.|\n)*?''')/ do
          # groups Text, Str::Affix, Str::Doc
          groups Text, Str::Char, Str::Doc
        end
        rule %r/[^\S\n]+/, Text
        rule %r/#.*$/, Comment::Single
        rule %r/[\[\]{}:(),;]/, Punctuation
        rule %r/\\\n/, Text
        rule %r/\\/, Text
        rule %r/(in|and|or|not)\b/, Operator::Word
        rule %r/!=|==|<<|>>|&&|\+=|-=|\*=|\/=|%=|&=|\|=|\|\||[-~+\/*%=<>&^.!|$]/, Operator
        rule %r/(func)((?:\s|\\\s)+)/ do
          groups Keyword, Text
          push :funcname
        end
        rule %r/(class)((?:\s|\\\s)+)/ do
          groups Keyword, Text
          push :classname
        end
        mixin :keywords
        mixin :buildins
        rule %r/(#{affix_long})(""")/ do
          # groups Str::Affix, Str::Double
          groups Str::Char, Str::Double
          push :tdqs
        end
        rule %r/(#{affix_long})(''')/ do
          # groups Str::Affix, Str::Double
          groups Str::Char, Str::Single
          push :tsqs
        end
        rule %r/(#{affix_long})(")/ do
          # groups Str::Affix, Str::Double
          groups Str::Char, Str::Double
          push :dqs
        end
        rule %r/(#{affix_long})(')/ do
          # groups Str::Affix, Str::Double
          groups Str::Char, Str::Single
          push :sqs
        end
        rule %r/(#{affix_short})(""")/ do
          # groups Str::Affix, Str::Double
          groups Str::Char, Str::Double
          push :escape_tdqs
        end
        rule %r/(#{affix_short})(''')/ do
          # groups Str::Affix, Str::Double
          groups Str::Char, Str::Single
          push :escape_tsqs
        end
        rule %r/(#{affix_short})(")/ do
          # groups Str::Affix, Str::Double
          groups Str::Char, Str::Double
          push :escape_dqs
        end
        rule %r/(#{affix_short})(')/ do
          # groups Str::Affix, Str::Double
          groups Str::Char, Str::Single
          push :escape_sqs
        end
        mixin :name
        mixin :numbers
      end

      state :keywords do
        rule %r/(#{keywords})\b/, Keyword
        rule %r/(?<!\.)(#{keywords_reserved})\b/, Keyword::Reserved
      end

      state :buildins do
        rule %r/(?<!\.)(#{buildins})\b/, Name::Builtin
        rule %r/((?<!\.)(self|false|true)|(PI|TAU|NAN|INF))\b/, Name::Builtin::Pseudo
        rule %r/(?<!\.)(#{builtins_type})\b/, Keyword::Type
      end

      state :numbers do
        rule %r/(\d+\.\d*|\d*\.\d+)([eE][+-]?[0-9]+)?j?/, Num::Float
        rule %r/\d+[eE][+-]?[0-9]+j?/, Num::Float
        rule %r/0[xX][a-fA-F0-9]+/, Num::Hex
        rule %r/\d+j?/, Num::Integer
      end

      state :name do
        rule %r/[a-zA-Z_]\w*/, Name
      end

      state :funcname do
        rule %r/[a-zA-Z_]\w*/, Name::Function, :pop!
      end

      state :classname do
        rule %r/[a-zA-Z_]\w*/, Name::Class, :pop!
      end

      state :string_escape do
        rule %r/\\([\\abfnrtv"\']|\n|N\{.*?\}|u[a-fA-F0-9]{4}|U[a-fA-F0-9]{8}|x[a-fA-F0-9]{2}|[0-7]{1,3})/, Str::Escape
      end

      state :strings_single do
        rule %r/%(\(\w+\))?[-#0 +]*([0-9]+|[*])?(\.([0-9]+|[*]))?[hlL]?[E-GXc-giorsux%]/, Str::Interpol
        rule %r/[^\\\'"%\n]+/, Str::Single
        rule %r/[\'"\\]/, Str::Single
        rule %r/%/, Str::Single
      end

      state :strings_double do
        rule %r/%(\(\w+\))?[-#0 +]*([0-9]+|[*])?(\.([0-9]+|[*]))?[hlL]?[E-GXc-giorsux%]/, Str::Interpol
        rule %r/[^\\\'"%\n]+/, Str::Double
        rule %r/[\'"\\]/, Str::Double
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
