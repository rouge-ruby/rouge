# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    load_lexer 'actionscript.rb'

    class LoomScript < Actionscript
      title 'LoomScript'
      desc "Scripting language for the Loom SDK, a native mobile app and game framework (https://github.com/LoomSDK/LoomSDK)"

      tag 'loomscript'
      aliases 'ls'
      filenames '*.ls'
      mimetypes 'application/loomscript', 'application/x-loomscript',
                'text/loomscript', 'text/x-loomscript'

      # LoomScript token reference (as of sprint34):
      # https://github.com/LoomSDK/LoomSDK/blob/sprint34/loom/script/compiler/lsToken.cpp#L111

      def self.keywords
        @keywords ||= Set.new %w(
          break case continue default delete do each else
          for each in if return super switch while with yield

          as is instanceof new typeof
        )
      end

      def self.constants
        @constants ||= Set.new %w(
          false Infinity NaN null this true undefined
        )
      end

      def self.declarations
        @declarations ||= Set.new %w(
          class const delegate enum extends function get implements
          interface namespace operator package set struct var
        )
      end

      def self.reserved
        @reserved ||= Set.new %w(
          import include

          debugger export goto syncronized transient volatile
        )
      end

      def self.types
        base_types = %w(
          int uint void

          Assembly Boolean ByteArray Coroutine Date Dictionary File Function
          GUID Null Number Object Path Process Socket String Type Vector

          AbstractClassError ArgumentError Error
          IllegalOperationError RangeError TypeError

          XMLAttribute XMLComment XMLDeclaration XMLDocument
          XMLElement XMLError XMLNode XMLPrinter XMLText
        )

        utils = %w(
          Base64 CommandLine Console Debug GC IO JSON Math Metrics
          NativeDelegate ObjectInspector Platform Profiler Random Telemetry VM

          BaseApplication ConsoleApplication
        )

        @types ||= Set.new (base_types + utils)
      end

      def self.attributes
        @attributes ||= Set.new %w(
          abstract dynamic final internal native
          override private protected public static
        )
      end

      def self.builtins
        @builtins ||= Set.new %w(
          isNaN parseFloat parseInt trace
        )
      end

    end
  end
end
