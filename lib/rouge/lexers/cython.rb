# -*- coding: utf-8 -*- #
# frozen_string_literal: true

require_relative 'python'

module Rouge
  module Lexers
    class Cython < Python
      title "Cython"
      desc "Cython and Pyrex source code (cython.org)"
      tag 'cython'
      aliases 'pyx', 'pyrex'
      filenames '*.pyx', '*.pxd', '*.pxi'
      mimetypes 'text/x-cython', 'application/x-cython'

      def initialize(opts = {})
        super opts
        @indentation = nil
      end

      def self.keywords
        @keywords ||= super + %w(
          by except? fused gil nogil
        )
      end

      def self.c_keywords
        @c_keywords ||= Set.new %w(
          public readonly extern api inline enum union
        )
      end

      def self.builtins
        @builtins ||= super + %w(python_call)
      end

      identifier = /[a-z_]\w*/i

      prepend :from_import do
        rule %r/cimport\b/, Keyword::Namespace, :pop!
      end

      prepend :root do
        rule %r/cp?def|ctypedef/ do
          token Keyword
          push :c_definitions
          push :c_start
        end

        rule %r/cimport\b/, Keyword::Namespace, :import

        rule %r/(struct)((?:\\\s|\s)+)/ do
          groups Keyword, Text
          push :classname
        end

        rule %r/[(,]/, Punctuation, :c_start
      end

      # The Cython lexer adds three states to those already in the Python lexer.
      # Calls to `cdef`, `cpdef` and `ctypedef` move the lexer into the :c_start
      # state. The primary purpose of this state is to highlight datatypes. Once
      # this has been done, the lexer moves to the :c_definitions state where
      # the majority of text in a definition is lexed. Finally, newlines cause
      # the lexer to move to :c_indent. This state is used to check whether we
      # have moved out of a C block.

      state :c_start do
        mixin :inline_whitespace

        rule %r/cp?def|ctypedef/, Keyword

        rule %r/(?:un)?signed/, Keyword::Type

        # This rule matches identifiers that could be type declarations. The
        # lookahead matches (1) pointers, (2) arrays and (3) variable names.
        rule %r/#{identifier}(?=(?:\*+)|(?:[ \t]*\[)|(?:[ \t]+\w))/ do |m|
          if self.class.keywords.include?(m[0])
            token Keyword
            pop!
          elsif m[0] == 'def'
            token Keyword
            goto :funcname
          elsif %w(struct class).include?(m[0])
            token Keyword
            goto :funcname
          elsif self.class.c_keywords.include?(m[0])
            token Keyword::Reserved
          else
            token Keyword::Type
            pop!
          end
        end

        rule(//) { pop! }
      end

      state :c_definitions do
        rule %r/\n/, Text, :c_indent
        mixin :root
      end

      state :c_indent do
        rule %r/[ \t]+/ do |m|
          token Text
          goto :c_start

          if @indentation.nil?
            @indentation = m[0]
          elsif @indentation.length > m[0].length
            @indentation = nil
            pop! 2 # Pop :c_start and :c_definitions
          end
        end

        rule(//) do
          @indentation = nil
          # pop c_indent
          pop!

          # replace :c_definitions with :newline
          goto :newline
        end
      end
    end
  end
end
