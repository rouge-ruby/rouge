# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Formatters::HTMLLinewise do
  let(:subject) { Rouge::Formatters::HTMLLinewise.new(formatter, options) }
  let(:formatter) { Rouge::Formatters::HTML.new }

  let(:options) { {} }
  let(:output) { subject.format(input_stream) }

  describe 'a simple token stream' do
    let(:input_stream) { [[Token['Name'], 'foo']] }

    it 'formats' do
      assert { output == %(<div class="line-1"><span class="n">foo</span>\n</div>) }
    end
  end

  describe 'final newlines' do
    let(:input_stream) { [[Token['Text'], "foo\n"], [Token['Name'], "bar\n"]] }

    it 'formats' do
      assert { output == %(<div class="line-1">foo\n</div><div class="line-2"><span class="n">bar</span>\n</div>) }
    end
  end

  describe 'intermediate newlines' do
    let(:input_stream) { [[Token['Name'], "foo\nbar"]] }

    it 'formats' do
      assert { output == %(<div class="line-1"><span class="n">foo</span>\n</div><div class="line-2"><span class="n">bar</span>\n</div>) }
    end
  end

  describe 'alternate tag name' do
    let(:input_stream) { [[Token['Text'], "foo\n"], [Token['Name'], "bar\n"]] }
    let(:options) { { tag_name: 'span' } }

    it 'should use tag name specified by :tag_name option' do
      assert { output == %(<span class="line-1">foo\n</span><span class="line-2"><span class="n">bar</span>\n</span>) }
    end
  end

  describe 'inside html table formatter' do
    let(:input_stream) { [[Token['Text'], "foo\n"], [Token['Name'], "bar\n"]] }

    it 'should delegate to linewise formatter' do
      assert { Rouge::Formatters::HTMLTable.new(subject).format(input_stream) == %(<table class="rouge-table"><tbody><tr><td class="rouge-gutter gl"><pre class="lineno">1\n2\n</pre></td><td class="rouge-code"><pre><div class="line-1">foo\n</div><div class="line-2"><span class="n">bar</span>\n</div></pre></td></tr></tbody></table>) }
    end
  end
end
