# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class EPP < TemplateLexer
      title "EPP"
      desc "Embedded Puppet template files"

      tag 'epp'

      filenames '*.epp'

      def initialize(opts={})
        @puppet_lexer = Puppet.new(opts)

        super(opts)
      end

      start do
        parent.reset!
        @puppet_lexer.reset!
      end

      open  = /<%%|<%=|<%#|(<%-|<%)(\s*\|)?/
      close = /%%>|(\|\s*)?(-%>|%>)/

      state :root do
        rule /<%#/, Comment, :comment

        rule open, Comment::Preproc, :puppet

        rule /.+?(?=#{open})|.+/m do
          delegate parent
        end
      end

      state :comment do
        rule close, Comment, :pop!
        rule /.+?(?=#{close})|.+/m, Comment
      end

      state :puppet do
        rule close, Comment::Preproc, :pop!

        rule /.+?(?=#{close})|.+/m do
          delegate @puppet_lexer
        end
      end
    end
  end
end
