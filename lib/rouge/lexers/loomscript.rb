# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
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
          for if in return switch while with yield

          as is instanceof new typeof
        )
      end

      def self.declarations
        @declarations ||= Set.new %w(
          class delegate enum function interface
          namespace operator package struct var
        )
      end

      def self.reserved
        @reserved ||= Set.new %w(
          abstract const dynamic extends final get
          implements import include internal native
          override private protected public
          set static super this

          debugger export goto syncronized transient volatile
        )
      end

      def self.constants
        @constants ||= Set.new %w(
          false NaN null true undefined void
        )
      end

      def self.builtins
        # builtin functions
        @builtins ||= %w(
          isNaN parseFloat parseInt trace
        )

        # builtin types
        @builtins ||= %w(
          Assembly Boolean ByteArray Coroutine Date Dictionary File Function
          GUID Null Number Object Path Process Socket String Type Vector Void

          AbstractClassError ArgumentError Error
          IllegalOperationError RangeError TypeError

          XMLAttribute XMLComment XMLDeclaration XMLDocument
          XMLElement XMLError XMLNode XMLPrinter XMLText
        )

        # builtin utilities
        @builtins ||= %w(
          Base64 CommandLine Console Debug GC IO JSON Math Metrics
          NativeDelegate ObjectInspector Platform Profiler Random Telemetry VM

          BaseApplication ConsoleApplication
        )
      end

    end
  end
end
