# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class MsgTrans < RegexLexer
      title "MessageTrans"
      desc "RISC OS message translator messages file"
      tag 'msgtrans'
      filenames 'Messages*'

      state :root do
        rule %r/^#[^\n]*/, Comment
        rule %r/[^\n ,):?\/]+/, Name::Variable
        rule %r/[\n\/?]/, Operator
        rule %r/:/, Operator, :value
      end

      state :value do
        rule %r/\n/, Text, :pop!
        rule %r/%[0-3%]/, Operator
        rule %r/./, Literal::String
      end
    end
  end
end
