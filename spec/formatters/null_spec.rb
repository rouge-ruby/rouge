# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Formatters::Null do
  let(:subject) { Rouge::Formatters::Null.new }

  it 'renders nothing' do
    result = subject.format([[Token['Name.Constant'], 'foo']])

    assert { result == %|Name.Constant "foo"\n| }
  end

  it 'consumes tokens' do
    consumed = false
    tokens = Enumerator.new { consumed = true }

    subject.format(tokens)

    assert consumed
  end
end
