# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Formatters::HTML do
  let(:subject) { Rouge::Formatters::HTMLLegacy.new(options) }
  let(:options) { {} }

  describe 'skipping the wrapper' do
    let(:subject) { Rouge::Formatters::HTML.new }
    let(:output) { subject.format([[Token['Name'], 'foo']]) }
    let(:options) { { :wrap => false } }

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

  describe 'format using lexer instance called with options' do
    let(:text) { %(<meta name="description" content="foo">\n<script>alert("bar")</script>) }
    let(:subject) { Rouge::Formatters::HTML.new }
    let(:tokens) { Rouge::Lexers::HTML.new.lex text, {} }
    let(:output) { subject.format(tokens) }

    it 'should format token stream' do
      assert { output == '<span class="nt">&lt;meta</span> <span class="na">name=</span><span class="s">"description"</span> <span class="na">content=</span><span class="s">"foo"</span><span class="nt">&gt;</span>
<span class="nt">&lt;script&gt;</span><span class="nx">alert</span><span class="p">(</span><span class="dl">"</span><span class="s2">bar</span><span class="dl">"</span><span class="p">)</span><span class="nt">&lt;/script&gt;</span>' }
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
