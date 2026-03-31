# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::YAML do
  let(:subject) { Rouge::Lexers::YAML.new }

  describe 'lexing' do
    include Support::Lexing

    describe 'quoted keys' do
      describe 'double quoted keys in block context' do
        it 'highlights quoted key and colon correctly' do
          assert_tokens_equal '"$schema": http://json-schema.org/draft-07/schema#',
            ['Name.Attribute', '"$schema"'],
            ['Punctuation.Indicator', ':'],
            ['Text', ' '],
            ['Literal.String', 'http://json-schema.org/draft-07/schema#']
        end

        it 'handles quoted keys with unescaped single quote characters' do
          assert_tokens_equal %("key'with'single'quotes": value),
            ['Name.Attribute', %("key'with'single'quotes")],
            ['Punctuation.Indicator', ':'],
            ['Text', ' '],
            ['Literal.String', 'value']
        end

        it 'handles quoted keys with unescaped YAML syntax characters' do
          assert_tokens_equal '"normally disallowed: []{}:,#": value',
            ['Name.Attribute', '"normally disallowed: []{}:,#"'],
            ['Punctuation.Indicator', ':'],
            ['Text', ' '],
            ['Literal.String', 'value']
        end

        it 'handles quoted keys with escaped double quotes' do
          assert_tokens_equal '"key\"with\"escaped\"quotes: 3": value',
            ['Name.Attribute', '"key\"with\"escaped\"quotes: 3"'],
            ['Punctuation.Indicator', ':'],
            ['Text', ' '],
            ['Literal.String', 'value']
        end

        it 'handles quoted keys with whitespace before colon' do
          assert_tokens_equal '"$defs"  : value',
            ['Name.Attribute', '"$defs"'],
            ['Text', '  '],
            ['Punctuation.Indicator', ':'],
            ['Text', ' '],
            ['Literal.String', 'value']
        end

        it 'handles an empty key' do
          assert_tokens_equal '"": value',
            ['Name.Attribute', '""'],
            ['Punctuation.Indicator', ':'],
            ['Text', ' '],
            ['Literal.String', 'value']
        end
      end

      describe 'single quoted keys in block context' do
        it 'highlights single key and colon correctly' do
          assert_tokens_equal "'$schema': http://json-schema.org/draft-07/schema#",
            ['Name.Attribute', "'$schema'"],
            ['Punctuation.Indicator', ':'],
            ['Text', ' '],
            ['Literal.String', 'http://json-schema.org/draft-07/schema#']
        end

        it 'handles quoted keys with unescaped double quote characters' do
          assert_tokens_equal %('key"with"double"quotes': value),
            ['Name.Attribute', %('key"with"double"quotes')],
            ['Punctuation.Indicator', ':'],
            ['Text', ' '],
            ['Literal.String', 'value']
        end

        it 'handles quoted keys with unescaped YAML syntax characters' do
          assert_tokens_equal "'normally disallowed: []{}:,#': value",
            ['Name.Attribute', "'normally disallowed: []{}:,#'"],
            ['Punctuation.Indicator', ':'],
            ['Text', ' '],
            ['Literal.String', 'value']
        end

        it 'handles quoted keys with escaped single quotes' do
          assert_tokens_equal "'key\\'with\\'escaped\\'quotes: 3': value",
            ['Name.Attribute', "'key\\'with\\'escaped\\'quotes: 3'"],
            ['Punctuation.Indicator', ':'],
            ['Text', ' '],
            ['Literal.String', 'value']
        end

        it 'handles quoted keys with whitespace before colon' do
          assert_tokens_equal "'$defs'  : value",
            ['Name.Attribute', "'$defs'"],
            ['Text', '  '],
            ['Punctuation.Indicator', ':'],
            ['Text', ' '],
            ['Literal.String', 'value']
        end

        it 'handles an empty key' do
          assert_tokens_equal "'': value",
            ['Name.Attribute', "''"],
            ['Punctuation.Indicator', ':'],
            ['Text', ' '],
            ['Literal.String', 'value']
        end
      end

      it 'handles combination of quoted and unquoted keys' do
        yaml = <<~YAML.strip
          "$schema": http://json-schema.org/draft-07/schema#
          json_schema_version: 1
          "$defs":
            Album:
              type: object
        YAML

        tokens = subject.lex(yaml).to_a

        # Check that quoted keys have correct tokens
        schema_key_index = tokens.find_index { |token| token[1] == '"$schema"' }
        assert schema_key_index, "Could not find '$schema' key"
        assert_equal 'Name.Attribute', tokens[schema_key_index][0].qualname
        assert_equal 'Punctuation.Indicator', tokens[schema_key_index + 1][0].qualname
        assert_equal ':', tokens[schema_key_index + 1][1]

        defs_key_index = tokens.find_index { |token| token[1] == '"$defs"' }
        assert defs_key_index, "Could not find '$defs' key"
        assert_equal 'Name.Attribute', tokens[defs_key_index][0].qualname
        assert_equal 'Punctuation.Indicator', tokens[defs_key_index + 1][0].qualname
        assert_equal ':', tokens[defs_key_index + 1][1]

        # Check that unquoted keys still work
        version_key_index = tokens.find_index { |token| token[1] == 'json_schema_version' }
        assert version_key_index, "Could not find 'json_schema_version' key"
        assert_equal 'Name.Attribute', tokens[version_key_index][0].qualname
      end

      it 'handles nested quoted keys' do
        yaml = <<~YAML.strip
          "$defs":
            'Album':
              "$ref": "#/definitions/Album"
        YAML

        tokens = subject.lex(yaml).to_a

        # Should not contain any error tokens
        error_tokens = tokens.select { |token| token[0] == 'Error' }
        assert error_tokens.empty?, "Found error tokens: #{error_tokens}"
      end
    end
  end

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.yml'
      assert_guess :filename => 'foo.yaml'
      assert_guess :filename => '.travis.yml'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-yaml'
    end

    it 'guesses by source' do
      assert_guess :source => "\n\n%YAML 1.2"
    end
  end
end
