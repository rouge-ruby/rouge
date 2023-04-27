# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::IRBLexer do
  let(:subject) { Rouge::Lexers::IRBLexer.new }
  let(:klass) { Rouge::Lexers::IRBLexer }

  include Support::Lexing
  
  it "parses IRB's :DEFAULT prompt" do
    assert_tokens_equal 'irb(main):001:0> self',
      ['Generic.Prompt', 'irb(main):001:0>'],
      ['Text.Whitespace', ' '],
      ['Name.Builtin', 'self']
  end
  
  it "parses IRB's :SIMPLE prompt" do
    assert_tokens_equal '>> self',
      ['Generic.Prompt', '>>'],
      ['Text.Whitespace', ' '],
      ['Name.Builtin', 'self']
  end
  
  it "parses Pry's default prompt" do
    assert_tokens_equal 'pry(main)> self',
      ['Generic.Prompt', 'pry(main)>'],
      ['Text.Whitespace', ' '],
      ['Name.Builtin', 'self']
  end
end
