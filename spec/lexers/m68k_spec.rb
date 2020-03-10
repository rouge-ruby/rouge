# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::M68k do
  let(:subject) { Rouge::Lexers::M68k.new }
  
  describe 'lexing' do
    include Support::Lexing
    
    it 'recognizes ";" comments not followed by a newline' do
      assert_tokens_equal '; comment', ['Comment.Single', '; comment']
    end
    
    it 'recognizes "*" comments not followed by a newline' do
      assert_tokens_equal '* comment', ['Comment.Single', '* comment']
    end
  end
end
