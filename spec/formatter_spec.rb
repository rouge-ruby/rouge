# frozen_string_literal: true

class TestFormatter < Rouge::Formatter
  def token_lines(tokens)
    super.to_a
  end
end

describe Rouge::Formatter do
  describe '#token_lines' do
    let(:formatter) { TestFormatter.new }

    it 'splits tokens into lines' do
      tokens = [[Token['Text'], "foo\nbar"]]
      expected = [
        [[Token['Text'], 'foo']],
        [[Token['Text'], 'bar']]
      ]

      assert { formatter.token_lines(tokens) == expected }
    end

    it 'splits multibyte content' do
      tokens = [[Token['Text'], "café\n日本"]]
      expected = [
        [[Token['Text'], 'café']],
        [[Token['Text'], '日本']]
      ]

      assert { formatter.token_lines(tokens) == expected }
    end

    it 'preserves tokens across multiple lines' do
      tokens = [
        [Token['Name'], 'foo'],
        [Token['Text'], ' '],
        [Token['Name'], "bar\nbaz"]
      ]

      expected = [
        [
          [Token['Name'], 'foo'],
          [Token['Text'], ' '],
          [Token['Name'], 'bar']
        ],
        [
          [Token['Name'], 'baz']
        ]
      ]

      assert { formatter.token_lines(tokens) == expected }
    end

    it 'preserves binary encoding' do
      tokens = [[Token['Text'], "foo\nbar".b]]

      expected = [
        [[Token['Text'], 'foo'.b]],
        [[Token['Text'], 'bar'.b]]
      ]

      assert { formatter.token_lines(tokens) == expected }
    end

    it 'preserves the error for non-ASCII-compatible encoding' do
      value = "foo\nbar".encode(Encoding::UTF_16LE)
      tokens = [[Token['Text'], value]]

      assert_raises(Encoding::CompatibilityError) do
        formatter.token_lines(tokens)
      end
    end

    it 'preserves the error for invalid encoding' do
      value = "foo\xFF\nbar".dup.force_encoding(Encoding::UTF_8)
      tokens = [[Token['Text'], value]]

      assert_raises(ArgumentError) do
        formatter.token_lines(tokens)
      end
    end
  end

  it 'finds terminal256' do
    assert { Rouge::Formatter.find('terminal256') }
  end

  it 'is found by Rouge.highlight' do
    assert { Rouge.highlight('puts "Hello"', 'ruby', 'terminal256') }
  end

  it 'does not escape by default' do
    assert { not Rouge::Formatter.escape_enabled? }
  end

  it 'escapes in all threads with #enable_escape!' do
    begin
      Rouge::Formatter.enable_escape!
      assert { Rouge::Formatter.escape_enabled? }
    ensure
      Rouge::Formatter.disable_escape!
    end
  end

  it 'escapes locally with #with_escape' do
    Rouge::Formatter.with_escape do
      assert { Rouge::Formatter.escape_enabled? }
      assert { not Thread.new { Rouge::Formatter.escape_enabled? }.value }
      Rouge::Formatter.disable_escape!
      assert { not Rouge::Formatter.escape_enabled? }
    end

    assert { not Rouge::Formatter.escape_enabled? }
  end
end
