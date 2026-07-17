# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Thrift do
  let(:subject) { Rouge::Lexers::Thrift.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'service.thrift'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-thrift'
      assert_guess :mimetype => 'application/x-thrift'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'recognizes header forms' do
      assert_tokens_equal 'namespace py.twisted thrift.test',
        ['Keyword.Declaration', 'namespace'],
        ['Text', ' '],
        ['Keyword.Namespace', 'py.twisted'],
        ['Text', ' '],
        ['Name.Namespace', 'thrift.test']

      assert_tokens_equal 'namespace * thrift.test',
        ['Keyword.Declaration', 'namespace'],
        ['Text', ' '],
        ['Punctuation', '*'],
        ['Text', ' '],
        ['Name.Namespace', 'thrift.test']

      assert_tokens_equal 'include "shared.thrift"',
        ['Keyword.Declaration', 'include'],
        ['Text', ' '],
        ['Literal.String.Double', '"shared.thrift"']
    end

    it 'recognizes definitions and core IDL terminals' do
      assert_tokens_includes 'service Calculator extends Shared { oneway void zip() throws (1: InvalidOperation ouch) }',
        ['Keyword.Declaration', 'service'],
        ['Name.Class', 'Calculator'],
        ['Keyword', 'extends'],
        ['Keyword', 'oneway'],
        ['Keyword.Type', 'void'],
        ['Keyword', 'throws']
    end

    it 'recognizes base and container types' do
      assert_tokens_includes '1: required map<string, list<uuid>> values',
        ['Keyword', 'required'],
        ['Keyword.Type', 'map'],
        ['Keyword.Type', 'string'],
        ['Keyword.Type', 'list'],
        ['Keyword.Type', 'uuid']
    end

    it 'recognizes cpp_type container clauses' do
      assert_tokens_includes 'typedef list cpp_type "std::vector<double>" <double> doubles',
        ['Keyword.Declaration', 'typedef'],
        ['Keyword.Type', 'list'],
        ['Keyword', 'cpp_type'],
        ['Literal.String.Double', '"std::vector<double>"'],
        ['Keyword.Type', 'double']

      assert_tokens_includes 'typedef list<double> cpp_type "std::vector<double>" old_doubles',
        ['Keyword.Type', 'list'],
        ['Keyword.Type', 'double'],
        ['Keyword', 'cpp_type']
    end

    it 'recognizes constants without splitting valid numbers' do
      assert_tokens_includes 'const list<double> values = [1, -0x10, 3.14, .5, 1e9, -1.7e+308]',
        ['Literal.Number.Integer', '1'],
        ['Literal.Number.Hex', '-0x10'],
        ['Literal.Number.Float', '3.14'],
        ['Literal.Number.Float', '.5'],
        ['Literal.Number.Float', '1e9'],
        ['Literal.Number.Float', '-1.7e+308']
    end

    it 'does not treat exponent-looking identifiers as floats' do
      assert_tokens_equal 'e10',
        ['Name', 'e10']
    end

    it 'recognizes boolean constants' do
      assert_tokens_includes '1: optional bool enabled = true; 2: optional bool hidden = false',
        ['Keyword.Constant', 'true'],
        ['Keyword.Constant', 'false']
    end

    it 'recognizes recursive field references' do
      assert_tokens_equal '1: optional RecursiveStruct & recurse',
        ['Literal.Number.Integer', '1'],
        ['Punctuation', ':'],
        ['Text', ' '],
        ['Keyword', 'optional'],
        ['Text', ' '],
        ['Name', 'RecursiveStruct'],
        ['Text', ' '],
        ['Operator', '&'],
        ['Text', ' '],
        ['Name', 'recurse']
    end

    it 'recognizes all Thrift comment forms' do
      assert_tokens_equal '# shell comment',
        ['Comment.Single', '# shell comment']

      assert_tokens_equal '// line comment',
        ['Comment.Single', '// line comment']

      assert_tokens_equal '/** doc */ /* block */',
        ['Comment.Multiline', '/** doc */'],
        ['Text', ' '],
        ['Comment.Multiline', '/* block */']
    end

    it 'recognizes escaped literals and annotations' do
      thrift = %q(1: optional string comment = "has \"quotes\"" (go.tag = 'json:"comment"', deprecated))

      assert_no_errors thrift
      assert_tokens_includes thrift,
        ['Literal.String.Double', '"has \"quotes\""'],
        ['Name', 'go.tag'],
        ['Literal.String.Single', '\'json:"comment"\''],
        ['Name', 'deprecated']
    end

    it 'recognizes valid annotation-heavy Thrift' do
      thrift = <<~THRIFT
        typedef list< double ( cpp.fixed_point = "16" ) > tiny_float_list

        struct foo {
          1: i32 bar ( presence = "required" );
          2: optional list<i64> values = [1, 2] (cpp.ref = "")
        } (
          cpp.type = "DenseFoo",
          annotation.without.value,
        )

        service deprecate_everything {
          void Foo() ( deprecated = "This method has neither 'x' nor \\"y\\"" )
          async void Old()
        }
      THRIFT

      assert_no_errors thrift
    end
  end
end
