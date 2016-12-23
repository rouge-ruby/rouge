# -*- coding: utf-8 -*- #

describe Rouge::Formatters::HTMLLinewise do
  let(:subject) { Rouge::Formatters::HTMLLinewise.new(formatter, options) }
  let(:formatter) { Rouge::Formatters::HTML.new }

  let(:options) { {} }
  let(:output) { subject.format(input_stream) }
  token = Rouge::Token

  describe 'a simple token stream' do
    let(:input_stream) { [[token['Name'], 'foo']] }

    it 'formats' do
      assert { output == %(<div class="line-1"><span class="n">foo</span></div>) }
    end
  end

  describe 'final newlines' do
    let(:input_stream) { [[token['Text'], "foo\n"], [token['Name'], "bar\n"]] }

    it 'formats' do
      assert { output == %(<div class="line-1">foo</div><div class="line-2"><span class="n">bar</span></div>) }
    end
  end

  describe 'intermediate newlines' do
    let(:input_stream) { [[token['Name'], "foo\nbar"]] }

    it 'formats' do
      assert { output == %(<div class="line-1"><span class="n">foo</span></div><div class="line-2"><span class="n">bar</span></div>) }
    end
  end
end
