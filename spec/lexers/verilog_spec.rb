# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Verilog do
  let(:subject) { Rouge::Lexers::Verilog.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.v'
      assert_guess :filename => 'foo.sv'
      assert_guess :filename => 'foo.svh'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-verilog'
      assert_guess :mimetype => 'text/x-systemverilog'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'recognizes one-line comments not followed by a newline' do
      assert_tokens_equal '// comment', ['Comment.Single', '// comment']
    end
  end
end
