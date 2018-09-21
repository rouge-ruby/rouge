# frozen_string_literal: true

describe Rouge::Formatter do
  it 'finds terminal256' do
    assert { Rouge::Formatter.find('terminal256') }
  end

  it 'is found by Rouge.highlight' do
    assert { Rouge.highlight('puts "Hello"', 'ruby', 'terminal256') }
  end
end
