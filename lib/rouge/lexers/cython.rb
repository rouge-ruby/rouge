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

      def self.keywords
        @keywords ||= super + %w(
          by ctypedef except? fused gil nogil 
        )
      end

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

        rule %r/(cp?def)(\s+)/ do
          groups Keyword, Text
          push :cdef
        end

        rule %r/(cdef)(:)/ do
          groups Keyword, Punctuation
        end

        rule %r/(struct)((?:\\\s|\s)+)/ do
          groups Keyword, Text
          push :classname
        end
      end

      state :cdef do
        rule %r/(public|readonly|extern|api|inline)\b/, Keyword::Reserved
        rule %r/(struct|enum|union|class)\b/, Keyword
        rule %r/([a-zA-Z_]\w*)(\s*)(?=[(:#=]|$)/ do 
          groups Name::Function, Text
          :pop!
        end
        rule %r/([a-zA-Z_]\w*)(\s*)(,)/ do
          groups Name::Function, Text, Punctuation
        end
        rule %r/from\b/, Keyword, :pop!
        rule %r/as\b/, Keyword

        rule %r/:/, Punctuation, :pop!
        rule %r/(?=["\'])/, Text, :pop!
        rule %r/[a-zA-Z_]\w*/, Keyword::Type
        rule %r/./m, Text
      end

    end
  end
end
