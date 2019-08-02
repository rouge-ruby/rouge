# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    load_lexer 'python.rb'

    class Cython < Python
      title "Cython"
      desc "Cython and Pyrex source code (cython.org)"
      tag 'cython'
      aliases 'pyx', 'pyrex'
      filenames '*.pyx', '*.pxd', '*.pxi'
      mimetypes 'text/x-cython', 'application/x-cython'

      def initialize(opts = {})
        super opts
        @indentation = []
      end

      def self.keywords
        @keywords ||= super + %w(
          by cdef cpdef ctypedef except? fused gil nogil 
        )
      end

      def self.ckeywords
        @ckeywords ||= %w(
          public readonly extern api inline struct enum union class
        )
      end

      identifier = /[a-z_]\w*/i
      dotted_identifier = /[a-z_.][a-z0-9_.]*/i
      
      prepend :root do
        rule %r/(cimport)(\s+)(#{dotted_identifier})/ do
          groups Keyword::Namespace, Text, Name::Namespace
        end

        rule %r/(from)((?:\\\s|\s)+)(#{dotted_identifier})((?:\\\s|\s)+)(cimport)/ do
          groups Keyword::Namespace,
                 Text,
                 Name::Namespace,
                 Text,
                 Keyword::Namespace
        end

        rule %r/cp?def|ctypedef/, Keyword, :ctype

        rule %r/(struct)((?:\\\s|\s)+)/ do
          groups Keyword, Text
          push :classname
        end
        
        rule %r/(#{identifier})(\()/ do |m|
          if self.class.keywords.include? m[1]
            groups Keyword, Punctuation
          elsif self.class.exceptions.include? m[1]
            groups Name::Builtin, Punctuation
          elsif self.class.builtins.include? m[1]
            groups Name::Builtin, Punctuation
          elsif self.class.builtins_pseudo.include? m[1]
            groups Name::Builtin::Pseudo, Punctuation
          else
            groups Name::Function, Punctuation
          end
          goto :ctype
        end
      end

      state :ctype do
        rule %r/[^\S\n]+/, Text
        
        rule %r/cp?def|ctypedef/ do |m|
          token Keyword
        end
        
        rule %r/#{identifier}(?=(?:\*+)|(?:[ \t]*\[)|(?:[ \t]+\w))/ do |m|
          if self.class.keywords.include? m[0]
            token Keyword
          elsif self.class.ckeywords.include? m[0]
            token Keyword::Reserved
          else
            token Keyword::Type
          end
          goto :cdef
        end
        
        rule(//) { goto :cdef }
      end

      state :cdef do
        rule %r/\n/, Text, :cindent
        
        rule %r/cp?def|ctypedef/ do |m|
          token Keyword
          goto :ctype
        end

        rule %r/(public|readonly|extern|api|inline)\b/, Keyword::Reserved
        rule %r/(struct|enum|union|class)\b/, Keyword

        mixin :root
      end

      state :cindent do
        rule %r/[ \t]+/ do |m|
          token Text

          if @indentation.nil?
            @indentation = m[0]
          elsif @indentation.length > m[0].length
            @indentation = nil
            pop!
          end

          goto :ctype
        end
        
        rule(//) { @indentation = nil; reset_stack }
      end
    end
  end
end
