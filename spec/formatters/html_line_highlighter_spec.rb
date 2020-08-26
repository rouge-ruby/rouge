# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Formatters::HTMLLineHighlighter do
  let(:subject) { Rouge::Formatters::HTMLLineHighlighter.new(formatter, options) }
  let(:formatter) { Rouge::Formatters::HTML.new }

  let(:options) { {} }
  let(:output) { subject.format(input_stream) }

  describe 'highlight lines' do
    let(:input_stream) { [[Token['Text'], "foo\n"], [Token['Name'], "bar\n"]] }
    let(:options) { { highlight_lines: [2] } }

    it 'should add highlight line class to lines specified by :highlight_lines option' do
      assert { output == %(foo\n<span class="hll"><span class="n">bar</span>\n</span>) }
    end
  end

  describe 'configure highlight line class' do
    let(:input_stream) { [[Token['Text'], "foo\n"], [Token['Name'], "bar\n"]] }
    let(:options) { { highlight_lines: [1, 2], highlight_line_class: 'hiline' } }

    it 'should add highlight line class to lines specified by :highlight_lines option' do
      assert { output == %(<span class="hiline">foo\n</span><span class="hiline"><span class="n">bar</span>\n</span>) }
    end
  end
end
