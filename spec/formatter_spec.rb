# frozen_string_literal: true

describe Rouge::Formatter do
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
