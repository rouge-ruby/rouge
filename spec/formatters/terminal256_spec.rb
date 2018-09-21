# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Formatters::Terminal256 do
  let(:subject) { Rouge::Formatters::Terminal256.new }

  it 'renders a thing' do
    result = subject.format([[Token['Text'], 'foo']])

    assert { result == "\e[38;5;230mfoo\e[39m" }
  end
end
