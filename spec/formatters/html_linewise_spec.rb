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
      assert { output == %(<div class="line-1"><span class="n">foo</span></div>) }
    end
  end

  describe 'final newlines' do
    let(:input_stream) { [[Token['Text'], "foo\n"], [Token['Name'], "bar\n"]] }

    it 'formats' do
      assert { output == %(<div class="line-1">foo</div><div class="line-2"><span class="n">bar</span></div>) }
    end
  end

  describe 'intermediate newlines' do
    let(:input_stream) { [[Token['Name'], "foo\nbar"]] }

    it 'formats' do
      assert { output == %(<div class="line-1"><span class="n">foo</span></div><div class="line-2"><span class="n">bar</span></div>) }
    end
  end

  describe 'with an improper inner formatter' do
    it 'raises an error' do
      assert do
        rescuing(ArgumentError, /got Rouge::Formatters::HTMLTable\b/) do
          Rouge::Formatters::HTMLLinewise.new(Rouge::Formatters::HTMLTable.new(Rouge::Formatters::HTML.new))
        end
      end
    end
  end

  describe 'inside html table formatter' do
    let(:input_stream) { [[Token['Text'], "foo\n"], [Token['Name'], "bar\n"]] }

    it 'should delegate to linewise formatter' do
      warnings, formatter = capture_warnings do
        Rouge::Formatters::HTMLTable.new(subject)
      end

      assert { warnings.size == 1}
      warning = warnings.first
      assert { warning.match?(/DEPRECATED/) }

      expected = %(<table class="rouge-table"><tbody><tr><td class="rouge-gutter gl" aria-hidden="true"><pre class="lineno">1\n2\n</pre></td><td class="rouge-code"><pre><code><div class="line-1">foo</div><div class="line-2"><span class="n">bar</span></div></code></pre></td></tr></tbody></table>)

      actual = formatter.format(input_stream)

      assert { actual == expected }
    end
  end


  describe 'alternate tag name' do
    let(:input_stream) { [[Token['Text'], "foo\n"], [Token['Name'], "bar\n"]] }
    let(:options) { { tag_name: 'florbis' } }

    it 'should use tag name specified by :tag_name option' do
      assert { output == %(<florbis class="line-1">foo</florbis><florbis class="line-2"><span class="n">bar</span></florbis>) }
    end
  end
end
