# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Formatters::TerminalTruecolor do
  let(:subject) { Rouge::Formatters::TerminalTruecolor.new }

  it 'renders a thing' do
    result = subject.format([[Token['Text'], 'foo']])

    assert { result == "\e[38;2;250;246;228mfoo\e[39m" }
  end
end
