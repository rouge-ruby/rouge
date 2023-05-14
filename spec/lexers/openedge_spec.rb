# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::OpenEdge do
  let(:subject) { Rouge::Lexers::OpenEdge.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.w'
      assert_guess :filename => 'foo.i'
      assert_guess :filename => 'foo.cls', :source => "BLOCK-LEVEL ON ERROR UNDO, THROW\r\nDEF VAR toto AS CHAR NO-UNDO."
      assert_guess :filename => 'foo.p', :source => "BLOCK-LEVEL ON ERROR UNDO, THROW\r\nDEF VAR toto AS CHAR NO-UNDO."
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-openedge'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'recognizes one-line comments not followed by a newline (#796)' do
      assert_tokens_equal '// comment', ['Comment.Single', '// comment']
    end

    it 'recognizes multiline comment ' do
      assert_tokens_equal "/*** \r\n/* *  hello\r\n */*/", ["Comment.Multiline", "/*** \r\n/* *  hello\r\n */*/"]
    end

    it 'recognizes comment at end of line' do
      assert_tokens_equal '&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 // hello', ["Comment.Preproc", "&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 "], ["Comment.Single", "// hello"]
    end

    it 'recognizes preprocess' do 
      assert_tokens_equal "{ test.i\r\n&abc = ABC\r\n&def    = 'D E  F'\r\n&hij=\"H   I   J\" }",
        ["Comment.Preproc", "{ test.i\r\n&abc = ABC\r\n&def    = 'D E  F'\r\n&hij=\"H   I   J\" }"]
      assert_tokens_equal "{ test.i \"{&Test}\" }",  ["Comment.Preproc", "{ test.i \"{&Test}\" }"]
    end
  end
end
