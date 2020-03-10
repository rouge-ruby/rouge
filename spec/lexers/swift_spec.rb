# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Swift do
  let(:subject) { Rouge::Lexers::Swift.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.swift'
    end
  end

  describe 'lexer' do
    include Support::Lexing

    it 'lexes multiline comments with asterisks and forward slashes' do
      multiline_comment = <<EOS.strip
/*
  Multiline comment
  with asterisks (*) and forward slashes (//)
*/
EOS

      assert_tokens_equal multiline_comment,
                          ['Comment.Multiline', multiline_comment]
    end

    it 'lexes nested comments as a single comment' do
      nested_comment = <<EOS.strip
/*
  /*
    Define a and b constants
  */

  let a = 1
  let b = 2

  /*
    Define c and d constants
  */

  let c = 3
  let d = 4
*/
EOS

      separate_comment = <<EOS.strip
/*
  A separate comment
*/
EOS
      combined_comments = "#{nested_comment}\n\n#{separate_comment}"

      assert_tokens_equal combined_comments,
                          ['Comment.Multiline', nested_comment],
                          ['Text', "\n\n"],
                          ['Comment.Multiline', separate_comment]
    end
  end
end
