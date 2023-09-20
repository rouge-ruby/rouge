# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    load_lexer "python.rb"

    class Mojo < Python
      title "Mojo"
      desc "The Mojo programming language"
      tag "mojo"
      filenames "*.mojo", "*.🔥"
      mimetypes "text/x-mojo", "application/x-mojo"

      def self.builtins
        @builtins ||= %w(
          Float16 Float32 Float64 Int8 Int16 Int32 Int64
          UInt8 UInt16 UInt32 UInt64
        )
      end

      state :root do
        rule %r/(fn)((?:\s|\\\s)+)/ do
          groups Keyword, Text
          push :funcname
        end

        rule %r/([a-z_]\w*)[ \t]*(?=(\[.*\]))/m, Name::Function
      end
    end
  end
end
