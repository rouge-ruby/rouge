# -*- coding: utf-8 -*- #

describe Rouge::Formatters::HTML do
  let(:subject) { Rouge::Formatters::HTMLLegacy.new(options) }
  let(:options) { {} }
  Token = Rouge::Token

  it 'formats a simple token stream' do
    out = subject.format([[Token['Name'], 'foo']])
    assert { out == %(<span class="n">foo</span>) }
  end

  describe 'skipping the wrapper' do
    let(:subject) { Rouge::Formatters::HTML.new }
    let(:output) { subject.format([[Token['Name'], 'foo']]) }

    it 'skips the wrapper' do
      assert { output == '<span class="n">foo</span>' }
    end
  end

  describe '#inline_theme' do
    class InlineTheme < Rouge::CSSTheme
      style Name, :bold => true
    end

    let(:options) { { :inline_theme => InlineTheme.new, :wrap => false } }

    let(:output) {
      subject.format([[Token['Name'], 'foo']])
    }

    it 'inlines styles given a theme' do
      assert { output == '<span style="font-weight: bold">foo</span>' }
    end
  end

  describe 'tableized line numbers' do
    let(:options) { { :line_numbers => true } }

    let(:tokens) { Rouge::Lexers::Clojure.lex(text) }

    let(:output) { subject.format(tokens) }
    let(:line_numbers) { output[%r[<pre class="lineno".*?</pre>]m].scan(/\d+/m).size }

    let(:output_code) {
      output =~ %r(<td.*?>(.*?)</td>)m
      $1
    }

    let(:code_lines) { output_code.scan(/\n/).size }

    describe 'newline-terminated text' do
      let(:text) { Rouge::Lexers::Clojure.demo }

      it 'preserves the number of lines' do
        assert { code_lines == line_numbers }
      end
    end

    describe 'non-newline-terminated text' do
      let(:text) { Rouge::Lexers::Clojure.demo.chomp }

      it 'preserves the number of lines' do
        assert { code_lines == line_numbers }
      end
    end
  end
end
